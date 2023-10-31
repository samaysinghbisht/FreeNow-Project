import os
from flask import Flask, redirect, request, jsonify, render_template
import boto3
import psycopg2
from botocore.exceptions import ClientError

app = Flask(__name__)

table_name=os.environ.get("TABLE_NAME")

# Connect to RDS
connection = psycopg2.connect(
    host=os.environ.get("RDS_HOSTNAME"),
    user=os.environ.get("RDS_USERNAME"),
    password=os.environ.get("RDS_PASSWORD"),
    database=os.environ.get("DATABASE_NAME"),
    port='5432'
)

# Connect to S3 using IAM role of the EC2 instance
s3 = boto3.client('s3')

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/add', methods=['POST'])
def add_to_db():
    data = request.form['data']
    with connection.cursor() as cursor:
        # Check if the table exists, and create it if it doesn't
        cursor.execute(f'''
        CREATE TABLE IF NOT EXISTS {table_name} (
            id SERIAL PRIMARY KEY,
            data TEXT NOT NULL
        );
        ''')
        connection.commit()

        # Insert the new data
        sql = f"INSERT INTO {table_name} (data) VALUES (%s)"
        cursor.execute(sql, (data,))
        connection.commit()
    return redirect('/')

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return redirect(request.url)

    uploaded_file = request.files['file']

    if uploaded_file.filename != '':
        try:
            bucket_name = os.environ.get("BUCKET_NAME")
            if bucket_name:
                s3.put_object(Bucket=bucket_name, Key=uploaded_file.filename, Body=uploaded_file)
                return redirect('/')
            else:
                return "Environment variable BUCKET_NAME is not set.", 500
        except ClientError as e:
            return f"An error occurred: {e}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)

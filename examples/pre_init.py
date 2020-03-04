#!/usr/bin/python3
"""
This python utility reads terraform code and creates s3 bucket for backend if not created.
"""
import boto3
import hcl

def get_bucket_attributes():
    """
    This function fetches the bucket attributes from main.tf of terraform code.
    """
    with open('main.tf', 'r') as bucket:
        obj = hcl.load(bucket)['terraform']['backend']['s3']
    backend_bucket = obj['bucket']
    backend_region = obj['region']
    return(backend_bucket, backend_region)

def verifying_bucket():
    """
    This function gets the value of bucket attributes from get_bucket_attributes().
    And creates s3 buckets if not present.
    """
    backend_bucket, backend_region = \
        get_bucket_attributes()
    s3 = boto3.client('s3')
    bucket_name_list = []
    for s3_bucket_list in s3.list_buckets()['Buckets']:
        bucket_name_list.append(s3_bucket_list['Name'])

    if backend_bucket not in bucket_name_list:
        bucket = s3.create_bucket(
            Bucket=backend_bucket,
            CreateBucketConfiguration={
                'LocationConstraint': backend_region
            }
        )
        print((bucket)['ResponseMetadata']['HTTPHeaders']['location'])
    else:
        print("Bucket already exist")

get_bucket_attributes()
verifying_bucket()

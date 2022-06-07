import requests
import json
from datetime import datetime
import configparser

def find_product_by_name(host,api_key,product_name):
    headers = dict()
    AUTH_TOKEN = "Token " + str(api_key)
    headers['Authorization'] = AUTH_TOKEN
    print("\n==============Lists Products=================")
    r = requests.get(host + "/products/?name="+str(product_name), headers=headers, verify=True)
    print(r.text)

    r = json.loads(r.text)
    if(r['count'] > 0):
        return r['results']
    else:
        return None

def create_product(host,api_key,product_name,product_type,description):
    headers = dict()
    json = dict()

    AUTH_TOKEN = "Token "+str(api_key)
    headers['Authorization'] = AUTH_TOKEN
    headers['content-type'] = "application/json"
    print(headers)

    json['prod_type'] = str(product_type)
    json['name'] = str(product_name)
    json['description'] = str(description)

    r = requests.post(host+"/products/", headers=headers, verify=True, json=json)
    print(r)
    print(r.text)

    return r.status_code, r.text

def create_engagement(host,api_key,name,product_id,commit_hash,branch_tag):
    print("\n==============Create Engagement================")
    headers = dict()
    json = dict()

    AUTH_TOKEN = "Token " + str(api_key)
    headers['Authorization'] = AUTH_TOKEN
    headers['content-type'] = "application/json"
    print(headers)

    json['name'] = str(name)
    json['product'] = str(product_id)
    json['target_start'] = datetime.now().strftime("%Y-%m-%d")
    json['target_end'] = datetime.now().strftime("%Y-%m-%d")
    json['commit_hash'] = str(commit_hash)
    json['branch_tag'] = str(branch_tag)
    json['deduplication_on_engagement'] = True
    json['source_code_management_uri'] = ""
    json['engagement_type'] = "CI/CD"

    print(json)
    r = requests.post(host+"/engagements/", headers=headers, verify=True, json=json)
    print(r)
    print(r.text)
    return r.status_code, r.text

def upload_scan_result(host,api_key,product_name,engagement_name,scan_type,file_path):
    print("\n===============Upload Scan Results============")
    headers = dict()
    json = dict()

    AUTH_TOKEN = "Token " + str(api_key)
    headers['Authorization'] = AUTH_TOKEN
    print(headers)

    files = dict()
    files['file'] = open(file_path,'rb')

    json = dict()
    json['minimum_severity'] = "Info"
    json['scan_date'] = datetime.now().strftime("%Y-%m-%d")
    json['verified'] = False
    json['tags'] = "automated"
    json['active'] = True
    json['engagement_name'] = engagement_name
    json['product_name'] = product_name
    json['scan_type'] = scan_type

    r = requests.post(host+"/import-scan/", headers=headers, verify=True, data=json, files=files)
    print(r)
    print(r.text)
    return r.status_code, r.text

print("starting")
product_id = None

# Read config file
config = configparser.ConfigParser()
config.read('.github/workflows/dojo-env.ini')

url = config['server']['url']
api_key = config['server']['api_key']
#
product_name = config['product']['product_name']
description = config['product']['description']
product_type = config['product']['product_type']
#
engagement_name = config['engagement']['engagement_name']
commit_hash = config['engagement']['commit_hash']
branch = config['engagement']['branch']
#
scan_type = config['scan']['scan_type']
file_path = config['scan']['file_path']


# url = "https://defectdojo.devops.team.oozou.com/api/v2"
# api_key = "xxxxx"
# product_name = "test-from-python9"
# description = "test-from-python"
# product_type = "1"
# engagement_name = "from python1"
# commit_hash = "xxx1231"
# branch = "develop"
# scan_type = "KICS Scan"
# file_path = "results.json"

query_result = find_product_by_name(url,api_key,product_name)
if (query_result != None):
    print("Product is created already")
    product_id = query_result[0]['id']
else:
    print("Creating new Product")
    status_code, result = create_product(url,api_key,product_name,product_type,description)
    result = json.loads(result)
    product_id = result['id']
print(product_id)

status_code, result = create_engagement(url,api_key,engagement_name,product_id,commit_hash,branch)
result = json.loads(result)
engagement_id = result['id']
print(engagement_id)


status_code, result = upload_scan_result(url,api_key,product_name,engagement_name,scan_type,file_path)
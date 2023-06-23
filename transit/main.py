import boto3
import re
import yaml
from github import Github
import base64
from loguru import logger
import os

access_token = os.getenv("GITHUB_ACCESS_TOKEN")
repo_url = "rohit-dimagi/store-api-iac" 
file_path = "k8s/store-api/deployment.yaml"

def get_latest_master_image():
    """ Filter images and return the latest pushed one """
    client = boto3.client('ecr', region_name='ap-south-1')
    response = client.list_images(
        registryId='521558197391',
        repositoryName='store-api',
        maxResults=1000
    )

    latest = None
    temp_tag = None

    for image in response['imageIds']:
        tag = image['imageTag']
        if re.search("^[0-9]+", tag):
            img = client.describe_images(
                registryId='521558197391',
                repositoryName='store-api',
                imageIds=[
                    {
                        'imageTag': tag
                    },
                ]
            )
            pushed_at = img['imageDetails'][0]['imagePushedAt']
            if latest is None:
                latest = pushed_at
            else:
                if latest < pushed_at:
                    latest = pushed_at
                    temp_tag = tag
    return temp_tag, latest

def fetch_file(access_token, repo_url, file_path, latest_tag):
    """ Compare Latest and current Image and update Git repo with Latest image tag"""
    
    g = Github(access_token)
    repo = g.get_repo(repo_url)
    
    file_contents = repo.get_contents(file_path)    
    file_content = file_contents.content
    decoded_content = base64.b64decode(file_content)
    data = yaml.safe_load(decoded_content.decode("utf-8"))
    
    # Retrieve the image value
    image = data["spec"]["template"]["spec"]["containers"][0]["image"]
    current_tag = image.split(':')[1]
    
    if current_tag == latest_tag:
        print("Latest Version already running.")
    else:
        data["spec"]["template"]["spec"]["containers"][0]["image"] = f"{image.split(':')[0]}:{latest_tag}"
    
        updated_yaml_content = yaml.dump(data)
        repo.update_file(file_path, "Updating image tag", updated_yaml_content, file_contents.sha)
        

latest_tag, pushed_at = get_latest_master_image()
logger.info(f'Store-api Latest version is: {latest_tag},  pushed at: {pushed_at}')

fetch_file(access_token, repo_url, file_path, latest_tag)

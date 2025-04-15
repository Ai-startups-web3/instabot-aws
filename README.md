

for my Insta Bot

## Step 1
create instance and download pemkey and copy public ip address

## Step 1
running and starting the aws for server

ssh -i botkey.pem ec2-user@98.84.155.58

If permission error: chmod 400 botkey.pem

## Step 2 
Create a Script File to clone github repo + copy env + video Upload

- TODO: 1. Update Video info
        2. Update Env

## Step 3 
Upload the files to EC2

- Copy Installer :

- Copy file : scp -i botkey.pem Projects/Insta-bot/insta-bot.sh ec2-user@98.84.155.58:~/projects/Insta-bot/

- Copy env : scp -i botkey.pem Projects/Insta-bot/.env.myBot ec2-user@98.84.155.58:~/projects/Insta-bot/

- Copy assets : scp -i botkey.pem Projects/Insta-bot/videoToPost.mp4 ec2-user@98.84.155.58:~/projects/Insta-bot/

scp -i botkey.pem Projects/Installer/installSoftware.sh ec2-user@54.87.124.110:~/projects/Installer/
# react-app-deployment-github-runner
This repository contains documentation and snippets regarding first task of the assessment on server setup and deploying a simple react web application with Github hosted runner.

## Server Setup
- Install Docker (if not installed) and skip the installation (if already installed)
- Install Nginx (if not installed), configure and restart the server, and skip (if already installed)

### Docker Installation
- Inorder to install docker with bash script, we first check whether docker is installed on the system or not.
- If installed, we will skip the installation. 
- Due to security considerations, We will perform rootless installation of docker. This means that special privileges `sudo` are not required in order to run docker containers by the user installing the docker.


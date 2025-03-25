# react-app-deployment-github-runner
This repository contains documentation and snippets regarding first task of the assessment on server setup and deploying a simple react web application with Github hosted runner.

## Server Setup
- Install Docker (if not installed) and skip the installation (if already installed)
- Install Nginx (if not installed), configure and restart the server, and skip (if already installed)

### Docker Installation
- Inorder to install docker with bash script, we first check whether docker is installed on the system or not.
- If installed, we will skip the installation. 
- Due to security considerations, We will perform rootless installation of docker. This means that special privileges `sudo` are not required in order to run docker containers by the user installing the docker.

> Issues faced: While installing rootless docker, certain packages were needed as pre-requisites in linux distribution that I tried running the script on. For Debian based linux distributions, following packages were needed in advance. `uidmap` and `dbus-user-session`.

![Docker-Install-Issue](images/docker-install-issue.png)

> To resolve the issue, I installed the packages (within the script), depending upon the linux distribution of the host machine conditionally.

![Docker-Installation-Intermediary-Stage](images/docker-install-intermediary-stage.png)

> Although, the docker is installed, it shows `Docker installation failed`,  with not being the docker binary path on $PATH. For this, I added the Docker binary location on $PATH variable and exported $DOCKER_HOST variable. Finally, Docker installation was successful.

![Docker-Installation-Successful](images/docker-install-success.png)

> Running the script second time, the installation process is skipped.

![Skip-Docker-installation](images/skip-docker-installation.png)

I followed the ![Docker-Docs-on-Rootless-Installation](https://docs.docker.com/engine/security/rootless) guide from Docker documentation.



### Nginx Installation
- First, we check if nginx binary exists or not with `which nginx`.
- Test, if nginx is not only installed but working properly with `nginx -v`.
- We have multiple functions to detect linux distribution, install nginx according to distribution.
- Functions to configure nginx configuration and validate and restart nginx on the machine.
- We invoke different functions by conditionally checking different scenarios for nginx installation and working on the linux machine.

> I faced a slight issue while running the script. Although the nginx was installed, configured and started successfully, the script exited with error 1 code stating `Error: Nginx installation failed`.
This was really not a installation and configuration issue, but caused due to under privileges of the initial command present in the script to check nginx version (at the end of the script for `verify installation`). This issue was resolved by adding `sudo` before the command to give enough privileges to view the version of nginx (to verify nginx was installed and started as expected).

![Nginx-Installation-Failed-Issue](images/nginx-initial-issue.png)

**Nginx-Installation-Success**

![](images/nginx-install-success.png)

![](images/nginx-home-page.png)


**Nginx-Installation-script-second-run**

![](images/nginx-already-installed-working.png)

## Dependency setup (CI)
- Install Dependency for the project
- Build Docker images
- Push to Docker image to `DockerHub`

I already have a **TODO Application** in React, Express and Postgresql. The source code for the application along with Dockerfiles are present inside the **app** directory.

For Continuous Integration (CI) part, There is a **workflow.yml** file inside **.github/workflows** directory. 
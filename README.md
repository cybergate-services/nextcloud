# Nextcloud Installation Guide

# Install Docker CE in Ubuntu

## Prerequisites

Before continuing with this tutorial, make sure you are logged in as a user with sudo privileges. All the commands in this tutorial should be run as a non-root use

## Installing Docker on Ubuntu

Although the Docker installation package is available in the official Ubuntu 18.04 repository, it may not always be the latest version. The recommended approach is to install the latest Docker package from the Docker’s repositories.

### Enabling Docker repository

**01.** Start by updating the packages list and installing the dependencies necessary to add a new repository over HTTPS:

```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```
**02.** Import the repository’s GPG key using the following `curl` command:

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
**03.** Add the Docker APT repository to your system:

``` 
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
### Installing Docker CE

Now that the Docker repository is enabled, you can install any Docker version you need.

**01.** To install the latest version of Docker use the command below. If you want to install a specific Docker version, skip 
this step and go to the next one.

```
sudo apt update
sudo apt install docker-ce
```
**02.** Once the installation is completed, the Docker service will start automatically. You can verify it by typing:

```
sudo systemctl status docker
```

## Executing docker command without sudo

By default managing, Docker requires administrator privileges.

To run Docker commands as a non-root user without prepending `sudo` you need to add your user to the `docker` group. This group is created during the installation of the Docker CE package. To do that run the following command:

```
sudo usermod -aG docker $USER
```
`$USER` is an environment variable that holds your username.

Log out and log back in t0 refresh the group membership.

To verify that Docker has been successfully installed and that you can run docker commands without prepending sudo, run:

```
docker container run hello-world
```








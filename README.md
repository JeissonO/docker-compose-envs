# docker-compose-envs

Docker Compose configurations to spin up multiple custom environments.

## Overview

This project provides a setup to create and manage custom environments using Docker Compose. It includes:
- A `Dockerfile` (`Dockerfile202504`) to build a custom environment with pre-installed tools.
- A `docker-compose.yaml` file to define services and configurations.
- A shell script (`start-docker-compose.sh`) to simplify starting services and managing environment variables.

---

## Environment Details

### Dockerfile (`Dockerfile202504`)

The `Dockerfile202504` creates a custom environment based on the latest Ubuntu image. It includes:
- **User Configuration**: Dynamically creates a user with sudo privileges based on the `user` and `rootpassword` arguments.
- **Installed Tools**:
  - **Node.js** (v18.x) and npm
  - **AWS CLI v2**
  - **Git**
  - **Zsh** (configured with a custom `.zshrc`)
- **Customizations**:
  - Configures npm to use a local directory for global installations.
  - Sets up the timezone (`America/Bogota`) and locale (`en_US.UTF-8`).

The default command for the container is `sleep infinity`, allowing you to interact with the container as needed.

---

## Docker Compose Configuration

The `docker-compose.yaml` file defines a service named `custom-env`. Key configurations include:
- **Build Arguments**:
  - `user`: The username for the container.
  - `rootpassword`: The root password for the user.
- **Volumes**:
  - Mounts the specified folder and user configuration files into the container.
- **Environment Variables**:
  - Uses environment variables (`DC_ROOTPASSWORD`, `DC_FOLDER`, etc.) to dynamically configure the service.

---

## How to Use

### Prerequisites

1. Install Docker and Docker Compose on your system.
2. Clone this repository:
```sh
    git clone <repository-url>
    cd docker-compose-envs
```

### Steps to Use
1. Configure Environment Variables
Create an .env file in the project directory to define the required environment variables:
```sh
    USER=your-username
    DC_ROOTPASSWORD=your-root-password
    DC_FOLDER=your-folder-name
```

2. Use the Shell Script
Run the start-docker-compose.sh script to start a service:
[start-docker-compose.sh](start-docker-compose.sh)

The script will:

- Prompt you for the following:
    DC_ROOTPASSWORD: The root password for the container user.
    DC_FOLDER: The folder to mount inside the container.
    DC_SERVICENAME: The name of the service to start.
- Log the service details (e.g., service name, user, root password) to service_log.txt.
- Start the specified service using docker-compose.

3. Access the Running Container
Once the service is up, you can access the container using:
```sh
    docker exec -it $(docker ps -q --filter name=<service_name>) /bin/zsh
```
Replace <service_name> with the name of the service you started.

---

## Example Workflow
1. Run the script:
```sh
    ./start-docker-compose.sh
```

2. Enter the required inputs when prompted:
```sh
    Enter the root password (DC_ROOTPASSWORD): mypassword
    Enter the folder name (DC_FOLDER): myfolder
    Enter the service name to start (DC_SERVICENAME): custom-env
```
3. Access the container in a new terminal:
```sh
    docker exec -it $(docker ps -q --filter name=custom-env) /bin/zsh
```
Check the **service_log.txt** file for logged details
```sh
    cat service_log.txt
```

### Notes
- Ensure the folder specified in **DC_FOLDER** exists on your host machine.
- The **start-docker-compose.sh** script simplifies managing environment variables and starting services, but you can also manually run docker-compose commands if needed.
- The **Dockerfile202504** is designed to be flexible and can be extended to include additional tools or configurations.

### Troubleshooting
If the container fails to start, check the logs using:
```sh
    docker-compose logs <service_name>
```
- Ensure Docker and Docker Compose are installed and running on your system.
- Verify that the .env file or the inputs provided to the script are correct.

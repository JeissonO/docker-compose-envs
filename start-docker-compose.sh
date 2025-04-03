#!/bin/bash

# Helper function to display usage information
function show_help() {
  echo "Usage: ./start-docker-compose.sh"
  echo "This script prompts for DC_ROOTPASSWORD, DC_FOLDER, and DC_SERVICENAME,"
  echo "then starts the specified Docker Compose service and logs the details."
  echo
  echo "Environment Variables:"
  echo "  DC_ROOTPASSWORD - The root password for the service."
  echo "  DC_FOLDER       - The folder to be mounted in the container."
  echo "  DC_SERVICENAME  - The name of the service to start."
  echo
}

# Function to log information to a file
function log_service_info() {
  local log_file="service_log.txt"
  echo "Service Name: $DC_SERVICENAME" >> "$log_file"
  echo "User: $USER" >> "$log_file"
  echo "Root Password: $DC_ROOTPASSWORD" >> "$log_file"
  echo "Timestamp: $(date)" >> "$log_file"
  echo "------------------------" >> "$log_file"
  echo "Service information logged to $log_file"
}

# Check if the user requested help
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  show_help
  exit 0
fi

# Prompt the user for required inputs
read -p "Enter the root password (DC_ROOTPASSWORD): " DC_ROOTPASSWORD
read -p "Enter the folder name (DC_FOLDER): " DC_FOLDER
read -p "Enter the service name to start (DC_SERVICENAME): " DC_SERVICENAME

# Export the variables so they can be used in docker-compose
export DC_ROOTPASSWORD
export DC_FOLDER

# Log the service information
log_service_info

# Display a message on how to access the container
echo "To access the Docker container after the service is up, use the following command:"
echo "docker exec -it \$(docker ps -q --filter name=$DC_SERVICENAME) /bin/zsh"

# Run docker-compose for the specified service
docker-compose up "$DC_SERVICENAME"
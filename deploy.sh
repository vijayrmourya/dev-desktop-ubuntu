#!/bin/bash

# Function to check the status of the last executed command and return on failure
check_status() {
  if [ $? -ne 0 ]; then
    echo "Error: Previous command failed. Exiting."
    return 1
  fi
}

# Main function to organize the script
main() {
  echo "TERRAFORM INITIALIZING"
  terraform init
  check_status || return 1

  echo "TERRAFORM FORMATTING"
  terraform fmt -recursive
  check_status || return 1

  echo "TERRAFORM VALIDATING"
  terraform validate
  check_status || return 1

  echo "TERRAFORM PLANNING"
  terraform plan
  check_status || return 1

  # Ask for user confirmation before applying the changes
  read -p "Press enter to apply the changes, or Ctrl+C to stop" ENTER

  echo "TERRAFORM APPLYING"
  terraform apply --auto-approve
  terraform output -json > output.json
  check_status || return 1

  echo "Terraform operations completed successfully."
}

# Call the main function
main

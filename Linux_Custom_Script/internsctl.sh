#!/bin/bash

get_cpu_info() {
  lscpu
}

get_memory_info() {
  free -h
}

create_user() {
  read -p "Enter the username for the new user: " username

  if [ -z "$username" ]; then
    echo "Username cannot be empty."
    exit 1
  fi

  sudo useradd -m "$username"
  sudo passwd "$username"
  echo "User '$username' created successfully."
}

list_users() {
  if [ "$2" == "--sudo-only" ]; then
    get_sudo_users
  else
    get_all_users
  fi
}

get_all_users() {
  cut -d: -f1 /etc/passwd
}

get_sudo_users() {
  grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n'
}

case "$1" in
  cpu)
    case "$2" in
      getinfo)
        get_cpu_info
        ;;
      *)
        echo "Unknown cpu subcommand: $2"
        echo "Usage: $0 cpu {getinfo}"
        exit 1
        ;;
    esac
    ;;
  memory)
    case "$2" in
      getinfo)
        get_memory_info
        ;;
      *)
        echo "Unknown memory subcommand: $2"
        echo "Usage: $0 memory {getinfo}"
        exit 1
        ;;
    esac
    ;;
  user)
    case "$2" in
      create)
        create_user
        ;;
      list)
        list_users "$@"
        ;;
      *)
        echo "Unknown user subcommand: $2"
        echo "Usage: $0 user {create|list}"
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Usage: $0 {cpu|memory|user}"
    exit 1
    ;;
esac

alias docker-cleanup='docker-stop-all; docker-rm-all; docker-rmi-all'
alias docker-compose-reload='docker compose down; docker compose build; docker compose up -d'
alias docker-rm-all='docker rm $(docker ps -a -q)'
alias docker-rmi-all='docker rmi $(docker images -q)'
alias docker-spawn-cli='docker exec -it cli bash'
alias docker-stop-all='docker stop $(docker ps -a -q)'
alias ecrlogin='$(aws ecr get-login --no-include-email --region eu-west-1)'
function spawn {
  if docker exec $1 sh -c 'which bash'; then
    echo "Container has bash"
    docker exec -it $1 bash
  else
    echo "Container doesn't have bash, using sh"
    docker exec -it $1 sh
  fi
}
function debinstall {
  sudo dpkg -i $1
}
function dockernetworkgraph {
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock leoverto/docker-network-graph
  echo "Paste the above output into https://dreampuf.github.io/GraphvizOnline"
}
# Function to backup or restore a Docker volume
function docker_volume() {
  (
    ColorOff='\033[0m' # Text Reset
    Yellow='\033[0;33m' # Yellow for important info
    Red='\033[0;31m' # Red for errors
    function infoMessage() {
        echo -e ${Yellow}
        echo $1
        echo -e ${ColorOff}
    }
    function errMessage() {
        echo -e ${Red}
        echo $1
        echo -e ${ColorOff}
    }
    errHandler() {
        # Any steps that must be taken prior to exiting due to error
        errMessage "Something went wrong. Exiting now."
        exit 1
    }
    set -eE # -e throw ERR for any non-zero exit codes, -E as well as in any child functions
    trap 'errHandler' ERR INT # Call errHandler function on ERR (non-zero exit code) or INT (ctrl-c interupt execution)

    local action=$1
    local volume_name=$2
    local file_path=$3

    if [[ -z $action || -z $volume_name || -z $file_path ]]; then
      infoMessage "Command may be used to backup or restore docker volumes to and from tar.gz files"
      infoMessage "Usage: docker_volume <backup|restore> <volume_name> <file_path>"
      infoMessage "Example: docker_volume backup my_volume_name /path/to/backup_file.tar.gz"
      return 1
    fi
    
    # Ensure file_path ends with .tar.gz
    if [[ ! "$file_path" =~ \.tar\.gz$ ]]; then
      infoMessage "File path does not end with .tar.gz, adjusting..."
      file_path="${file_path}.tar.gz"
      infoMessage "File path now set as $file_path"
    fi

    # Check if the volume exists
    if ! docker volume inspect "$volume_name" &>/dev/null; then
      errMessage "Volume '$volume_name' does not exist."
      # Try to list similar volume names
      local similar_volumes=$(docker volume ls --format '{{.Name}}' | grep -i "$volume_name" || true)
      if [[ -n "$similar_volumes" ]]; then
        infoMessage "However, similar volume names were found: $similar_volumes"
      else
        infoMessage "No similar volume names were found. Use \`docker volume ls\` to ensure the volume name is correct."
      fi

      if [ "$action" = "backup" ]; then
        return 1
      elif [ "$action" = "restore" ]; then
        infoMessage "Are you sure you want to proceed with restoring to '$volume_name'? [y/N]"
        read -r response
        if [[ ! "$response" =~ ^[yY]([eE][sS])?$ ]]; then
          errMessage "Restore operation aborted."
          return 1
        fi
      fi
    fi

    case $action in
      backup)
        if [ -f "$file_path" ]; then
          infoMessage "The file $file_path already exists. Overwrite? [y/N]"
          read -r response
          if [[ ! "$response" =~ ^[yY]([eE][sS])?$ ]]; then
            errMessage "Backup operation aborted to prevent overwriting existing file."
            return 1
          fi
        fi
        infoMessage "Starting backup..."
        docker run --rm -v "$volume_name":/volume -v "$(dirname "$file_path")":/backup alpine /bin/sh -c "apk add --no-cache tar > /dev/null && tar czf - -C /volume ./ > /backup/$(basename "$file_path")"
        infoMessage "Volume '$volume_name' has been backed up to '$file_path'"
        ;;
      restore)
        infoMessage "Starting restore..."
        docker run --rm -v "$volume_name":/volume -v "$(dirname "$file_path")":/backup alpine /bin/sh -c "apk add --no-cache tar > /dev/null && tar xzf /backup/$(basename "$file_path") -C /volume"
        infoMessage "Volume '$volume_name' has been restored from '$file_path'"
        ;;
      *)
        errMessage "Invalid action: $action"
        infoMessage "Usage: docker_volume <backup|restore> <volume_name> <file_path>"
        return 1
        ;;
    esac
  )
}

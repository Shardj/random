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
docker_volume() {
  local action=$1
  local volume_name=$2
  local file_path=$3

  if [[ -z $action || -z $volume_name || -z $file_path ]]; then
    echo "Usage: docker_volume <backup|restore> <volume_name> <file_path>"
    echo "Example: docker_volume backup my_volume_name /path/to/backup_file.tar.gz"
    return 1
  fi

  case $action in
    backup)
      docker run --rm -v "$volume_name":/volume -v "$(dirname "$file_path")":/backup ubuntu tar czf "/backup/$(basename "$file_path")" -C /volume ./
      echo "Volume '$volume_name' has been backed up to '$file_path'"
      ;;
    restore)
      docker run --rm -v "$volume_name":/volume -v "$(dirname "$file_path")":/backup ubuntu tar xzf "/backup/$(basename "$file_path")" -C /volume
      echo "Volume '$volume_name' has been restored from '$file_path'"
      ;;
    *)
      echo "Invalid action: $action"
      echo "Usage: docker_volume <backup|restore> <volume_name> <file_path>"
      return 1
      ;;
  esac
}

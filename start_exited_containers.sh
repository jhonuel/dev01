#!/bin/sh

while true; do
  echo "Comprobando contenedores en estado Exited... $(date)"
  # Obtener los IDs de los contenedores en estado Exited
  exited_containers=$(docker ps -a -q -f status=exited)

  # Verificar si hay contenedores en estado Exited
  if [ -z "$exited_containers" ]; then
    echo "No hay contenedores en estado Exited. $(date)"
  else
    # Iniciar los contenedores en estado Exited
    echo "Iniciando contenedores en estado Exited... $(date)"
    for container in $exited_containers; do
      docker start $container
      echo "Contenedor $container iniciado. $(date)"
    done
  fi

  echo "En  60 segundos se realizara la verificacion $(date)"
  sleep 60
done

#!/bin/bash
# Reemplazar <brunoportillo> y <portillo>
docker build -t web1-<portillo> .
docker tag web1-<portillo> <brunoportillo>/web1-<portillo>:latest
docker push <brunoportillo>/web1-<portillo>:latest
# Para ejecutar (host port 8080)
# docker run -d -p 8080:80 <DOCKERHUB_USER>/web1-<APELLIDO>:latest

cat > ~/UTN-FRA_SO_Examenes/202406/docker/run.sh <<'EOF'
#!/bin/bash
# Script de construcción y push de imagen Docker - Bruno Portillo

docker build -t web1-portillo .
docker tag web1-portillo blankito023/web1-portillo:latest
docker push blankito023/web1-portillo:latest

# Para ejecutar (host port 8080)
# docker run -d -p 8080:80 blankito023/web1-portillo:latest
EOF

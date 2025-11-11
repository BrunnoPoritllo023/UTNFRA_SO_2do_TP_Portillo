./UTN-FRA_SO_Examenes/202406/docker/run.sh
mkdir -p ~/UTN-FRA_SO_Examenes/202406/docker
cat > ~/UTN-FRA_SO_Examenes/202406/docker/index.html <<'EOF'
<html><body>
<h1>TP2 - Alumno: Tu Nombre</h1>
<p>Apellido: <b>Tu-Apellido</b></p>
</body></html>
EOF

cat > ~/UTN-FRA_SO_Examenes/202406/docker/Dockerfile <<'EOF'
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EOF

cat > ~/UTN-FRA_SO_Examenes/202406/docker/run.sh <<'EOF'
#!/bin/bash
# Reemplazar <DOCKERHUB_USER> y <APELLIDO>
docker build -t web1-<APELLIDO> .
docker tag web1-<APELLIDO> <DOCKERHUB_USER>/web1-<APELLIDO>:latest
docker push <DOCKERHUB_USER>/web1-<APELLIDO>:latest
# Para ejecutar (host port 8080)
# docker run -d -p 8080:80 <DOCKERHUB_USER>/web1-<APELLIDO>:latest
EOF

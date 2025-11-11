exit
git clone https://github.com/upszot/UTN-FRA_SO_Examenes.git
cd UTN-FRA_SO_Examenes/202406/
chmod +x ./script_Precondicion.sh
./script_Precondicion.sh
source ~/.bashrc
cd ~
mkdir -p RTA_Examen_20251111/
cd RTA_Examen_20251111/
pwd
cat > ~/RTA_Examen_$(date +%Y%m%d)/Punto_A.sh <<'EOF'
chmod +x ~/RTA_Examen_$(date +%Y%m%d)/Punto_A.sh
cat > ~/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh <<'EOF'
#!/bin/bash
# AltaUsers script
USUARIO_BASE="$1"
ARCHIVO_LISTA="$2"

if [ -z "$USUARIO_BASE" ] || [ -z "$ARCHIVO_LISTA" ]; then
  echo "Uso: $0 <usuario_base> <archivo_lista>"
  exit 1
fi

# Extraer hash de password del usuario base
CLAVE_HASH=$(sudo awk -F: -v u="$USUARIO_BASE" ' $1==u {print $2}' /etc/shadow)

while IFS=, read -r GRUPO USUARIO; do
  [ -z "$GRUPO" ] && continue
  [ -z "$USUARIO" ] && continue
  sudo groupadd -f "$GRUPO"
  # Crear usuario con la misma contraseña (hash)
  sudo useradd -m -g "$GRUPO" -p "$CLAVE_HASH" "$USUARIO" || true
done < "$ARCHIVO_LISTA"
EOF

chmod +x ~/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh
cat > ~/lista_prueba.txt <<EOL
devs,juan
devs,maria
2PSupervisores,super1
EOL

~/RTA_Examen_$(date +%Y%m%d)/Punto_B.sh vagrant ~/lista_prueba.txt
mkdir -p ~/UTN-FRA_SO_Examenes/202406/docker
cat > ~/UTN-FRA_SO_Examenes/202406/docker/index.html <<'EOF'
<html><body>
<h1>TP2 - Alumno: brunoportillo</h1>
<p>Apellido: <b>portillo</b></p>
</body></html>

su - brunoportillo
cd ~/UTN-FRA_SO_Examenes/202406/docker
cat > ~/UTN-FRA_SO_Examenes/202406/docker/index.html <<'EOF'
<html><body>
<h1>TP2 - Alumno: bruno portillo</h1>
<p>Apellido: <b>portillo</b></p>
</body></html>
EOF

cat > ~/UTN-FRA_SO_Examenes/202406/docker/Dockerfile <<'EOF'
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EOF

sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
docker --version
cd ~/UTN-FRA_SO_Examenes/202406/
mkdir -p docker
cd docker
cat > index.html <<'EOF'
<html>
  <body>
    <h1>TP2 - Arquitectura y Sistemas Operativos</h1>
    <p>Alumno: <b>Bruno Portillo</b></p>
  </body>
</html>
EOF

cat > Dockerfile <<'EOF'
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EOF

cat > run.sh <<'EOF'
#!/bin/bash
docker run -d -p 8080:80 brunoportillo/web1-portillo:latest
EOF

chmod +x run.sh
docker login
docker build -t web1-portillo .
docker tag web1-portillo brunoportillo/web1-portillo:latest
docker push brunoportillo/web1-portillo:latest
echo "./UTN-FRA_SO_Examenes/202406/docker/run.sh" > ~/RTA_Examen_20251111/Punto_C.sh
cat > ~/UTN-FRA_SO_Examenes/202406/docker/run.sh <<'EOF'
#!/bin/bash
# Reemplazar brunoportillo y portillo
docker build -t web1-portillo .
docker tag web1-portillo brunoportillo/web1-portillo:latest
docker push blankito023/web1-portillo:latest
# Para ejecutar (host port 8080)
# docker run -d -p 8080:80 DOCKERHUB_USER/web1-APELLIDO:latest
EOF

chmod +x ~/UTN-FRA_SO_Examenes/202406/docker/run.sh
cd ~/UTN-FRA_SO_Examenes/202406/docker
docker build -t web1-portillo .
mkdir -p ~/UTN-FRA_SO_Examenes/202406/ansible/roles/config/{tasks,templates}
cat > ~/UTN-FRA_SO_Examenes/202406/ansible/roles/config/tasks/main.yml <<'EOF'
---
- name: Crear estructura de directorios
  file:
    path: "{{ item }}"
    state: directory
    owner: root
    mode: 0755
  loop:
    - /tmp/2do_parcial/alumno
    - /tmp/2do_parcial/equipo

- name: Plantilla datos_alumno
  template:
    src: datos_alumno.txt.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt

- name: Plantilla datos_equipo
  template:
    src: datos_equipo.txt.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt

- name: Sudoers - 2PSupervisores sin password
  lineinfile:
    path: /etc/sudoers.d/2psuper
    create: yes
    line: '%2PSupervisores ALL=(ALL) NOPASSWD:ALL'
    validate: 'visudo -cf %s'
EOF

cat > ~/UTN-FRA_SO_Examenes/202406/ansible/roles/config/templates/datos_alumno.txt.j2 <<'EOF'
Alumno: {{ ansible_user_id }}
EOF

cat > ~/UTN-FRA_SO_Examenes/202406/ansible/roles/config/templates/datos_equipo.txt.j2 <<'EOF'
Equipo: {{ ansible_hostname }}
EOF

cd ~/UTN-FRA_SO_Examenes/202406/ansible
cat > site.yml <<'EOF'
- hosts: localhost
  connection: local
  roles:
    - config
EOF

ansible-playbook site.yml --connection=local
cd ~
mkdir -p UTNFRA_SO_2do_TP_<portillo>
mkdir -p UTNFRA_SO_2do_TP_portillo
cp -r ~/UTN-FRA_SO_Examenes/202406 ~/UTNFRA_SO_2do_TP_portillo/
cp -r ~/RTA_Examen_20251111/ ~/UTNFRA_SO_2do_TP_portillo/
history -a
cp ~/.bash_history ~/UTNFRA_SO_2do_TP_portillo/
cd UTNFRA_SO_2do_TP_portillo/
git init
git add .
git commit -m "Entrega TP2 - portillo"
git remote add origin https://github.com/BrunnoPoritllo023/UTNFRA_SO_2do_TP_Portillo.git
git branch -M main
git push -u origin main
git config --global user.name "Bruno Portillo"
git config --global user.email "brunolportillooficial@gmail.com"
git config --list
git remote set-url origin https://github.com/BrunnoPortillo023/UTNFRA_SO_2do_TP_portillo.git
git add .
git commit -m "Entrega TP2 - Bruno Portillo"
git branch -M main
git push -u origin main
git remote set-url origin https://github.com/BrunnoPoritllo023/UTNFRA_SO_2do_TP_Portillo.git
git add .
git commit -m "Entrega TP2 - Bruno Portillo"
git branch -M main
git push -u origin main
exit
cp -r ~/UTN-FRA_SO_Examenes/202406 ~/UTNFRA_SO_2do_TP_portillo/
cp -r ~/RTA_Examen_20251111/ ~/UTNFRA_SO_2do_TP_portillo/
history -a
cp ~/.bash_history ~/UTNFRA_SO_2do_TP_portillo/
cd ~/UTNFRA_SO_2do_TP_portillo/
ls
git config --global user.name "Bruno Portillo"
git config --global user.email "brunolportillooficial@gmail.com"
git config --list
cd ~/UTNFRA_SO_2do_TP_Portillo
cd ~/UTNFRA_SO_2do_TP_portillo/
git init
cp -r ~/UTN-FRA_SO_Examenes/202406 ~/UTNFRA_SO_2do_TP_portillo/
cp -r ~/RTA_Examen_20251111/ ~/UTNFRA_SO_2do_TP_portillo/
history -a
cp ~/.bash_history ~/UTNFRA_SO_2do_TP_portillo/
cd ~/UTNFRA_SO_2do_T
cd ~/UTNFRA_SO_2do_TP_portillo/
git config --global user.name "Bruno Portillo"
git config --global user.email "brunolportillooficial@gmail.com"
git config --list
cd ~/UTNFRA_SO_2do_TP_portillo/
git init
git add .
git commit -m "Entrega TP2 - Bruno Portillo"
git remote add origin git@github.com:BrunnoPoritllo023/UTNFRA_SO_2do_TP_Portillo.git
git remote -v
git remote remove origin
git remote add origin git@github.com:BrunnoPoritllo023/UTNFRA_SO_2do_TP_Portillo.git
git remote -v
git branch -M main
git push -u origin main
git remote set-url origin https://github.com/BrunnoPoritllo023/UTNFRA_SO_2do_TP_Portillo.git
git remote -v
git push -u origin main
docker login
login succeeded
cat > ~/UTN-FRA_SO_Examenes/202406/docker/run.sh <<'EOF'
#!/bin/bash
# Script de construcción y push de imagen Docker - Bruno Portillo

docker build -t web1-portillo .
docker tag web1-portillo BrunnoPortillo023/web1-portillo:latest
docker push BrunnoPortillo023/web1-portillo:latest

# Para ejecutar (host port 8080)
# docker run -d -p 8080:80 BrunnoPortillo023/web1-portillo:latest
EOF

chmod +x ~/UTN-FRA_SO_Examenes/202406/docker/run.sh
cd ~/UTN-FRA_SO_Examenes/202406/docker
bash run.sh
docker images
whoami
sudo usermod -aG docker $(whoami)
groups
sudo usermod -aG docker brunoportillo
getent group docker
groups
sudo usermod -aG docker brunoportillo
getent group docker
exit
groups
docker images
cd ~/UTN-FRA_SO_Examenes/202406/docker/
cat > ~/UTN-FRA_SO_Examenes/202406/docker/run.sh <<'EOF'
#!/bin/bash
# Script de construcción y push de imagen Docker - Bruno Portillo

docker build -t web1-portillo .
docker tag web1-portillo blankito023/web1-portillo:latest
docker push blankito023/web1-portillo:latest

# Para ejecutar (host port 8080)
# docker run -d -p 8080:80 blankito023/web1-portillo:latest
EOF

chmod +x ~/UTN-FRA_SO_Examenes/202406/docker/run.sh
cd ~/UTN-FRA_SO_Examenes/202406/docker
bash run.sh
docker images
cd ~/UTNFRA_SO_2do_TP_portillo/
cp ~/UTN-FRA_SO_Examenes/202406/docker/run.sh ~/UTNFRA_SO_2do_TP_portillo/
history -a

cd ~/UTNFRA_SO_2do_TP_portillo
tree -a

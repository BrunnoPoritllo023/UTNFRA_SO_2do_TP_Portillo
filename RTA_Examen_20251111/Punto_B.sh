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

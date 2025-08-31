#!/bin/bash
# config-p.sh - Portainer Configuration Script (principal)

echo "Criando rede para o Traefik"
docker network create --driver=overlay traefik-public

echo "Deploy da stack do Traefik..."
docker stack deploy -c traefik-stack.yml traefik

echo "Deploy da stack do Portainer..."
docker stack deploy -c portainer-stack.yml portainer

echo "Configuração concluída!"
echo "Acesse o Portainer através do domínio configurado: https://portainer.<SEU_DOMINIO>"
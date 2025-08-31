# 🐳 Portainer + Traefik + Docker Swarm

Uma solução completa para gerenciamento de contêineres Docker usando Portainer como interface web, Traefik como proxy reverso e load balancer, tudo rodando em um cluster Docker Swarm.

## 📋 O que é esta aplicação?

Esta aplicação fornece uma infraestrutura completa para:

- **Portainer**: Interface web moderna para gerenciar contêineres, imagens, volumes, redes e stacks Docker
- **Traefik**: Proxy reverso automático com SSL/TLS (Let's Encrypt) e descoberta de serviços
- **Docker Swarm**: Orquestração nativa do Docker para alta disponibilidade e escalabilidade

## 🚀 Características

### Portainer

- Interface web intuitiva para gerenciar Docker
- Suporte completo ao Docker Swarm
- Gerenciamento de stacks, serviços e recursos
- Controle de acesso baseado em roles
- Monitoramento em tempo real

### Traefik

- Proxy reverso automático
- Certificados SSL gratuitos via Let's Encrypt
- Descoberta automática de serviços
- Load balancing inteligente
- Dashboard integrado

### Arquitetura

- **Docker Swarm Mode**: Orquestração nativa
- **Redes Overlay**: Comunicação segura entre serviços
- **Volumes Persistentes**: Dados seguros e persistentes
- **Alta Disponibilidade**: Tolerância a falhas

## 📁 Estrutura do Projeto

```text
Portainer/
├── portainer-stack.yml     # Stack do Portainer
├── trarfik-stack.yml       # Stack do Traefik
├── README.MD               # Este arquivo
├── scripts/
│   ├── install-docker.sh   # Instalação do Docker
│   └── config-p.sh         # Configuração da aplicação
└── [outros serviços]/
    ├── database/           # PostgreSQL e Redis
    ├── n8n/               # Automação de workflows
    ├── chatwoot/          # Atendimento ao cliente
    ├── metricas/          # Prometheus e monitoramento
    └── ...                # Outros microserviços
```

## 🔧 Pré-requisitos

- **Sistema Operacional**: Ubuntu 20.04+ ou Debian 11+
- **VPS/Servidor**: Mínimo 2GB RAM, 2 vCPUs
- **Domínio**: Um domínio próprio apontando para seu servidor
- **Portas**: 80 (HTTP) e 443 (HTTPS) liberadas no firewall

## 📖 Instalação

### 1. Preparação do Servidor

Execute o script de instalação do Docker:

```bash
chmod +x scripts/install-docker.sh
./scripts/install-docker.sh
```

**⚠️ Importante**: Edite o arquivo `install-docker.sh` e substitua `<IP_DA_SUA_VPS>` pelo IP real do seu servidor antes de executar.

### 2. Configuração do projeto

Antes de executar a configuração, é necessário configurar alguns campos antes:

- **traefik-stack.yml:** Substitua `<YOUR_EMAIL>` pelo e-mail que deseja utilizar para gerar os certificados SSL.
- **portainer-stack.yml:** Substitua `<YOUR_DOMAIN>` pelo seu domínio.

### 3. Deploy da Aplicação

Execute o script de configuração:

```bash
chmod +x scripts/config-p.sh
./scripts/config-p.sh
```

Este script irá:

- Criar a rede overlay `traefik-public`
- Fazer deploy do Traefik
- Fazer deploy do Portainer

## 🌐 Acesso às Aplicações

### Interface do Portainer

- **URL**: `https://portainer.<YOUR_DOMAIN>` (após configurar domínio)
- **Credenciais**: Configure na primeira execução

## 📊 Monitoramento e Logs

- **Logs em tempo real**: Disponíveis via interface do Portainer
- **Métricas**: Configure o Prometheus usando os arquivos em `metricas/`
- **Health Checks**: Configurados automaticamente pelo Docker Swarm

## 🛡️ Segurança

### Práticas Implementadas

- **HTTPS Obrigatório**: Redirecionamento automático HTTP → HTTPS
- **Certificados SSL**: Renovação automática via Let's Encrypt
- **Isolamento de Rede**: Serviços em redes overlay dedicadas
- **Acesso Restrito**: Portainer protegido por autenticação

### Recomendações Adicionais

- Configure firewall (UFW) no servidor
- Use senhas fortes no Portainer
- Mantenha as imagens sempre atualizadas
- Configure backups regulares dos volumes

## 🔄 Backup e Restauração

### Backup dos Dados

```bash
# Backup do volume do Portainer
docker run --rm -v portainer_portainer_data:/data -v $(pwd):/backup alpine tar czf /backup/portainer-backup.tar.gz -C /data .

# Backup dos certificados SSL
docker run --rm -v traefik_traefik-ssl-certs:/data -v $(pwd):/backup alpine tar czf /backup/traefik-certs-backup.tar.gz -C /data .
```

### Restauração

```bash
# Restaurar dados do Portainer
docker run --rm -v portainer_portainer_data:/data -v $(pwd):/backup alpine tar xzf /backup/portainer-backup.tar.gz -C /data

# Restaurar certificados SSL
docker run --rm -v traefik_traefik-ssl-certs:/data -v $(pwd):/backup alpine tar xzf /backup/traefik-certs-backup.tar.gz -C /data
```

---

⭐ **Dica**: Após a instalação, explore os outros serviços disponíveis na pasta raiz para expandir sua infraestrutura com N8N, Chatwoot, PostgreSQL e outros!

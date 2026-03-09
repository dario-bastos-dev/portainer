# Implantação de IA com Portainer

## Serviços de IA configurados

- Dify

## Pré-requisitos

- Portainer instalado e em execução
- Traefik instalado e em execução
- Ambiente Docker (Swarm) configurado
- Acesso à interface web do Portainer
- Banco de dados PostgreSQL externo provisionado
- Instância Qdrant externa provisionada (banco vetorial)
- Bucket S3/MinIO externo provisionado (armazenamento de arquivos)
- Config do Squid criada no Swarm (`squid_config`) — arquivo em `IA/configs/squid.conf`

## Arquitetura dos serviços

O stack do Dify é composto pelos seguintes serviços:

| Serviço | Descrição |
|---|---|
| `dify-api` | API principal do Dify |
| `dify-worker` | Processamento assíncrono de tarefas (Celery) |
| `dify-worker_beat` | Agendador de tarefas periódicas (Celery Beat) |
| `dify-plugin` | Daemon de plugins do Dify |
| `dify-web` | Interface web (frontend Next.js) |
| `dify-redis` | Redis interno para filas e cache |
| `dify-sandbox` | Sandbox isolado para execução de código |
| `dify-ssrf_proxy` | Proxy Squid para proteção contra SSRF |

## Passos para Implantação

### 1. Criar a Config do Squid no Swarm

Antes de fazer o deploy do stack, é necessário criar a config `squid_config` no Portainer:

1. Vá em Configs -> Add config
2. Nomeie como `squid_config`
3. Copie e cole o conteúdo dentro de `IA/configs/squid.conf`
4. Clique em Create config para finalizar

### 2. Configurações das variáveis de ambiente

Na interface do Portainer, ao criar o stack, defina as seguintes variáveis de ambiente:

#### URLs e CORS
| Variável | Descrição | Exemplo |
|---|---|---|
| `CONSOLE_WEB_URL` | Domínio do console web | `console.seudominio.com` |
| `CONSOLE_API_URL` | Domínio da API do console | `api.seudominio.com` |
| `API_URL` | Domínio da API pública | `api.seudominio.com` |
| `APP_URL` | Domínio das aplicações | `app.seudominio.com` |
| `CONSOLE_CORS_ALLOW_ORIGINS` | Origens permitidas pelo CORS | `https://console.seudominio.com` |

#### Banco de Dados (PostgreSQL Externo)
| Variável | Descrição |
|---|---|
| `DB_USERNAME` | Usuário do banco de dados |
| `DB_PASSWORD` | Senha do banco de dados |
| `DB_HOST` | Host do banco de dados |
| `DB_PORT` | Porta do banco de dados (padrão: `5432`) |
| `DB_DATABASE` | Nome do banco de dados |

#### Redis (Interno)
| Variável | Descrição |
|---|---|
| `REDIS_PASSWORD` | Senha do Redis interno do Dify |

#### Banco Vetorial (Qdrant Externo)
| Variável | Descrição | Exemplo |
|---|---|---|
| `QDRANT_URL` | URL do servidor Qdrant | `http://qdrant:6333` |
| `QDRANT_API_KEY` | Chave de API do Qdrant | |

#### Armazenamento de Arquivos (S3/MinIO Externo)
| Variável | Descrição | Exemplo |
|---|---|---|
| `S3_ENDPOINT` | Endpoint do serviço S3 | `https://minio.seudominio.com` |
| `S3_BUCKET_NAME` | Nome do bucket | `dify` |
| `S3_ACCESS_KEY` | Access key do S3 | |
| `S3_SECRET_KEY` | Secret key do S3 | |
| `S3_REGION` | Região do bucket | `us-east-1` |

#### E-mail (SMTP)
| Variável | Descrição |
|---|---|
| `MAIL_DEFAULT_SEND_FROM` | Endereço de envio padrão |
| `SMTP_SERVER` | Host do servidor SMTP |
| `SMTP_PORT` | Porta SMTP (ex: `465`, `587`) |
| `SMTP_USERNAME` | Usuário SMTP |
| `SMTP_PASSWORD` | Senha SMTP |
| `SMTP_USE_TLS` | Usar TLS (`true` ou `false`) |

#### Segurança
| Variável | Descrição |
|---|---|
| `SECRET_KEY` | Chave secreta da aplicação (string aleatória longa) |
| `PLUGIN_DAEMON_KEY` | Chave de autenticação do daemon de plugins |
| `INNER_API_KEY` | Chave da API interna entre serviços |

### 3. Método 1: Usando Stacks do Portainer

1. Faça login na sua instância do Portainer
2. Navegue para **Stacks** na barra lateral esquerda
3. Clique em **Add stack**
4. Forneça um nome para o stack (ex: `dify`)
5. Na aba **Web editor**, cole o conteúdo de `IA/dify.yml`
6. Configure as variáveis de ambiente na seção **Environment variables**
7. Clique em **Deploy the stack**

### Método 2: Usando Upload do Docker Compose

1. Acesse **Stacks** → **Add stack**
2. Selecione a aba **Upload**
3. Escolha o arquivo `IA/dify.yml` do seu sistema local
4. Defina o nome do stack e configure as variáveis de ambiente
5. Implante o stack

## Roteamento com Traefik

O stack expõe os seguintes serviços via Traefik através da rede `traefik-public`:

- **Console Web** (`dify-web`) → `https://${CONSOLE_WEB_URL}`
- **API / Console API** (`dify-api`) → `https://${CONSOLE_API_URL}`
- **Daemon de Plugins** (`dify-plugin`) → porta `5003` exposta diretamente

> Certifique-se de que as labels do Traefik estão configuradas nos serviços `dify-web` e `dify-api` conforme necessário para o seu ambiente.

## Pós-Implantação

- Verifique o status dos containers na seção **Stacks** do Portainer
- Acesse o console em `https://${CONSOLE_WEB_URL}` para criar o usuário administrador
- Confira os logs dos containers para identificar possíveis erros de conexão com banco, Redis ou S3

## Solução de Problemas

- **Erro de conexão com banco de dados**: verifique as variáveis `DB_*` e confirme que o host é acessível pela rede `dev-network`
- **Erro de conexão com Redis**: verifique se o serviço `dify-redis` está saudável e a variável `REDIS_PASSWORD` está correta
- **Falha no upload de arquivos**: confirme as credenciais do S3/MinIO e a existência do bucket
- **Sandbox não funciona**: confirme que a config `squid_config` foi criada corretamente no Swarm
- **Plugins não instalam**: verifique as variáveis `PLUGIN_DAEMON_KEY` e `INNER_API_KEY` e os logs do serviço `dify-plugin`
- Revise os logs dos containers para mensagens de erro detalhadas

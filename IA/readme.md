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
- Config do Squid criada no Swarm (`squid_config`) — arquivo em `IA/configs/squid.conf` (Somente para o Dify)

## Passos para Implantação

### 1. Criar a Config do Squid no Swarm

Antes de fazer o deploy do stack, é necessário criar a config `squid_config` no Portainer:

1. Vá em Configs -> Add config
2. Nomeie como `squid_config`
3. Copie e cole o conteúdo dentro de `IA/configs/squid.conf`
4. Clique em Create config para finalizar

### 2. Método 1: Usando Stacks do Portainer

1. Faça login na sua instância do Portainer
2. Navegue para **Stacks** na barra lateral esquerda
3. Clique em **Add stack**
4. Forneça um nome para o stack
5. Na aba **Web editor**, cole o conteúdo da stack selecionada
6. Configure as variáveis de ambiente na seção **Environment variables**
7. Clique em **Deploy the stack**

### Método 2: Usando Upload do Docker Compose

1. Acesse **Stacks** → **Add stack**
2. Selecione a aba **Upload**
3. Escolha o arquivo `IA/dify.yml` do seu sistema local
4. Defina o nome do stack e configure as variáveis de ambiente
5. Implante o stack

## Pós-Implantação

1. Dify:

- Verifique o status dos containers na seção **Stacks** do Portainer
- Acesse o console em `https://${CONSOLE_WEB_URL}` para criar o usuário administrador
- Confira os logs dos containers para identificar possíveis erros

## Solução de Problemas

- **Erro de conexão com banco de dados**: verifique as variáveis `DB_*` e confirme que o host é acessível pela rede `dev-network`
- **Erro de conexão com Redis**: verifique se o serviço `dify-redis` está saudável e a variável `REDIS_PASSWORD` está correta
- **Falha no upload de arquivos**: confirme as credenciais do S3/MinIO e a existência do bucket
- **Sandbox não funciona**: confirme que a config `squid_config` foi criada corretamente no Swarm
- **Plugins não instalam**: verifique as variáveis `PLUGIN_DAEMON_KEY` e `INNER_API_KEY` e os logs do serviço `dify-plugin`
- Revise os logs dos containers para mensagens de erro detalhadas

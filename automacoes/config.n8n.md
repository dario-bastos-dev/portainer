# Configuração do Broker do n8n (HAProxy)

## Visão Geral

Para o pareamento dinâmico entre **workers** e **runners**, é necessário configurar um load balancer (HAProxy) que intercepte e distribua as conexões corretamente entre os workers registrados no Docker Swarm.

## Pré-requisito

Esta config deve ser criada **antes** de fazer o deploy do stack do n8n.

## Passo a Passo

### 1. Criar a Config no Portainer

Acesse o Portainer, entre no ambiente desejado e navegue até **Configs → Add config**.

Cole o conteúdo abaixo:

```haproxy
global
    log stdout format raw local0
defaults
    mode tcp
    option tcpka
    timeout connect 5s
    timeout client 20d
    timeout server 20d
    timeout tunnel 20d
frontend broker_front
    bind *:5679
    default_backend workers_back
backend workers_back
    balance leastconn
    server-template worker 1-20 tasks.n8n_worker:5679 check resolvers docker init-addr libc,none

resolvers docker
    nameserver dns 127.0.0.11:53
    resolve_retries 3
    timeout resolve 1s
    timeout retry   1s
    hold valid      10s
# FIM DO ARQUIVO

```

> **Atenção:** mantenha uma linha em branco após o comentário `# FIM DO ARQUIVO`, exatamente como exibido acima.

### 2. Nomear a Config

No campo de nome, informe:

```
haproxy_broker_cfg
```

### 3. Salvar

Clique em **Create config**.

---

## Observações

- Configs no Portainer são **imutáveis**. Para alterá-la, apague a existente e crie outra com o mesmo nome.
- O HAProxy usa o DNS interno do Docker (`127.0.0.11`) para resolver dinamicamente os workers via `tasks.n8n_worker`.

# Implantação de WordPress com Portainer

## Pré-requisitos

- Portainer instalado e em execução
- Traefik instalar e em execução
- Ambiente Docker configurado
- Acesso à interface web do Portainer

## Passos para Implantação

### Configurações

Dentro do arquivo `.env`, defina os valores corretos para as variáveis de configuração refetente ao banco que está configurando

### Método 1: Usando Stacks do Portainer

1. Faça login na sua instância do Portainer
2. Vá em **Configs** e depois em **Add Configs**, dê um nome para a configuração, copie e cole o conteúdo de `wp-php-confg` e depois **Create config**
3. Navegue para **Stacks** na barra lateral esquerda
4. Clique em **Add stack**
5. Forneça um nome para seu stack (ex: "wordpress")
6. Na aba **Web editor**, cole o conteúdo de um dos arquivos dentro de `/wordpress`
7. Configure qualquer variável de ambiente necessária na seção **Environment variables**
8. Clique em **Deploy the stack**

### Método 2: Usando Upload do Docker Compose

1. Acesse **Stacks** → **Add stack**
2. Selecione a aba **Upload**
3. Escolha um dos arquivos dentro de `/database` do seu sistema local
4. Defina o nome do stack e configure variáveis de ambiente se necessário
5. Implante o stack

## Pós-Implantação

- Verifique o status da implantação na seção Stacks
- Confira os logs dos containers para identificar problemas
- Acesse o serviço através do domínio configurado

## Solução de Problemas

- Certifique-se de que todas as variáveis de ambiente necessárias estão configuradas corretamente
- Verifique a conectividade da rede Docker
- Confirme os mounts de volume e permissões
- Revise os logs dos containers para mensagens de erro
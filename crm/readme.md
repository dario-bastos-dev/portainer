# Implantação de CRM com Portainer

## CRMs configurados

- Krayin

## Pré-requisitos

- Portainer instalado e em execução
- Traefik instalar e em execução
- Ambiente Docker configurado
- Acesso à interface web do Portainer

## Passos para Implantação

### Configurações

Dentro do arquivo `.env`, defina os valores corretos para as variáveis de configuração refetente ao crm que está configurando

### Método 1: Usando Stacks do Portainer

1. Faça login na sua instância do Portainer
2. Navegue para **Stacks** na barra lateral esquerda
3. Clique em **Add stack**
4. Forneça um nome para seu stack (ex: "nome do crm")
5. Na aba **Web editor**, cole o conteúdo de um dos arquivos em `/crm`
6. Configure qualquer variável de ambiente necessária na seção **Environment variables**
7. Clique em **Deploy the stack**

### Método 2: Usando Upload do Docker Compose

1. Acesse **Stacks** → **Add stack**
2. Selecione a aba **Upload**
3. Escolha um arquivo dentro de `/crm` do seu sistema local
4. Defina o nome do stack e configure variáveis de ambiente se necessário
5. Implante o stack

## Pós-Implantação

### Configuraçoes adicionais do krayin

#### Banco de dados

1. Acesse containers, na barra lateral do Portainer
2. Selecione o container do krayin
3. Cole o seguinte comando `cd laravel-crm && php artisan krayin-crm:install`, você deve confirmar as informações que ele irá pedir, após isso será feito a cofniguração do banco de dados
4. Após configurar o banco de dados, aparecerá uma opção para criar o usuário, defina o nome, e-mail e senha

#### API Rest

**Obs:** Certifique que os campos `SANCTUM_STATEFUL_DOMAINS` e `L5_SWAGGER_UI_PERSIST_AUTHORIZATION` estejam configurados

1. Acesse containers, na barra lateral do Portainer
2. Selecione o container do krayin
3. Cole o seguinte comando `composer require krayin/rest-api`
4. Acesse os Helpers do sistema `cd packages/Webkul/Email/src/Helpers && ls`
5. Verifique se possui um aquivo chamado **HtmlFilter.php**
6. Acesse o aquivo utilizando `nano Htmlfilter.php` e altere o nome da classe para `class Htmlfilter`
7. Execute o comando `php artisan krayin-rest-api:install` para instalar e ativar a API Rest do Krayin

### Acesso e monitoramento

- Verifique o status da implantação na seção Stacks
- Confira os logs dos containers para identificar problemas
- Acesse o chatwoot através da domínio configurado

## Solução de Problemas

- Certifique-se de que todas as variáveis de ambiente necessárias estão configuradas corretamente
- Verifique a conectividade da rede Docker
- Confirme os mounts de volume e permissões
- Revise os logs dos containers para mensagens de erro
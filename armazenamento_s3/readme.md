# Implantação de Armazenamento S3 com Portainer

## Armazenamentos S3 atualmente configurados

- MinIO (versão da licensa antiga)

## Pré-requisitos

- Portainer instalado e em execução
- Traefik instalar e em execução
- Ambiente Docker configurado
- Acesso à interface web do Portainer

## Passos para Implantação

### Configurações

Dentro do arquivo `.env`, defina os valores corretos para as variáveis de configuração refetente ao armazenamento s3 que está configurando

### Método 1: Usando Stacks do Portainer

1. Faça login na sua instância do Portainer
2. Navegue para **Stacks** na barra lateral esquerda
3. Clique em **Add stack**
4. Forneça um nome para seu stack (ex: "minio")
5. Na aba **Web editor**, cole o conteúdo de um dos arquivos dentro de `/armazenamento_s3`
6. Configure qualquer variável de ambiente necessária na seção **Environment variables**
7. Clique em **Deploy the stack**

### Método 2: Usando Upload do Docker Compose

1. Acesse **Stacks** → **Add stack**
2. Selecione a aba **Upload**
3. Escolha um dos arquivos dentro de `/armazenamento_s3` do seu sistema local
4. Defina o nome do stack e configure variáveis de ambiente se necessário
5. Implante o stack

**Obs:** Para configurar o domínio para o MinIO, primeiro crie um dns do tipo **A**, com o nome **minio**, apontando para o servidor, depois crie mais dois registros **CNAME**, com nome **miniofront** e **minioback**, ambos apontando para o registro **A** criado

## Pós-Implantação

- Verifique o status da implantação na seção Stacks
- Confira os logs dos containers para identificar problemas
- Acesse o serviço através do domínio configurado

## Solução de Problemas

- Certifique-se de que todas as variáveis de ambiente necessárias estão configuradas corretamente
- Verifique a conectividade da rede Docker
- Confirme os mounts de volume e permissões
- Revise os logs dos containers para mensagens de erro
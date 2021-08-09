# README #

Software da OPAC Ecovida.  Criado por Otávio Schwanck

### Como instalar em uma maquina local ###

git clone https://otavioschwanck@bitbucket.org/otavioschwanck/ecovida_opac.git

### Configurando ###

1 - Instale o Docker e o Docker-compose.
2 - Rode docker-compose up -d
3 - Copie o database.yml com `cp config/database.sample.yml config/database.yml`
4 - bundle install
5 - rake db:create db:migrate

### Troubleshoot ###

Se você tiver o postgresql no seu sistema rodando, desative com `sudo systemctl stop postgresql`

### Dependências ###

- Ruby 2.6.5
- Rails 4.2.0



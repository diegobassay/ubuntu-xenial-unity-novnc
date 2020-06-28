# ubuntu-xenial-unity-novnc
Imagem Docker para Ubuntu 16.04 com TigerVNC instalado e integrado noVNC.

## Pré-requisitos

* Docker version 19.03.8
* Docker-Compose version 1.25.0

## Para executar o projeto
Para construir o projeto executar o seguinte comando na raiz do projeto:
```
docker-compose up
```

## Para executar
1 - Acessar a url abaixo no navegador (Firefox/Chrome/IE/Opera):
```
http://localhost:5000
```
Digitar credencial: budi

2 - Abrir um cliente de VNC:
```
VNC Host: vnc://0.0.0.0:5001
VNC Pass: budi
```
## Demonstração
![vnc](https://github.com/diegobassay/ubuntu-xenial-unity-novnc/blob/master/screenshot.png)
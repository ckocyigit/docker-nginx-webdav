# docker-nginx-webdav
WebDAV (SabreDAV) Docker Image with authentication running on nginx.

## About

Forked from fjudith/docker-nginx-webdav: Changed debian base image to ubuntu, now using PHP8-FPM and SabreDav 4.1.5

This is probably the first one working WebDAV image for docker.
It uses nginx as webserver and SabreDAV as WebDAV backend. This way this image is compatible with windows mounting.
Also, it features a digest authentication.

## Getting started

You can run this container the following way:

````
docker run -d \
           -e WEBDAV_USERNAME=admin \
           -e WEBDAV_PASSWORD=admin \
           -p 8080:80 \
           -v /path/to/your/files:/var/webdav/public \
           xama/nginx-webdav
````

This will start a new webdav instance on `http://localhost:8080` with the given username and password for authentication.

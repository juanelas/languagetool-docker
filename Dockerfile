FROM openjdk:14-alpine

LABEL maintainer="Juan Hernández Serrano <j.hernandez@upc.edu>"

RUN apk add --no-cache libgomp gcompat libstdc++ && \
    wget https://www.languagetool.org/download/LanguageTool-stable.zip && \
    mkdir tmplt && \
    unzip LanguageTool-stable.zip -d tmplt && \
    mv tmplt/* LanguageTool && \
    rm -rf LanguageTool-stable.zip tmplt

WORKDIR /LanguageTool

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 8081

USER nobody 

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
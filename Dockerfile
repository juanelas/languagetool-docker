FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y unzip wget && \
    wget https://languagetool.org/download/LanguageTool-stable.zip && \
    mkdir tmplt && \
    unzip LanguageTool-stable.zip -d tmplt && \
    mv tmplt/* LanguageTool && \
    rm -rf LanguageTool-stable.zip tmplt

FROM ibmjava:8-sfj
LABEL maintainer="Juan Hernández Serrano <j.hernandez@upc.edu>"
COPY --from=0 /LanguageTool /LanguageTool
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
WORKDIR /LanguageTool
USER nobody
EXPOSE 8081
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
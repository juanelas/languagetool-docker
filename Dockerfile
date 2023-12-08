FROM ibmjava:8-sfj
ARG VERSION
LABEL org.languagetool.docker.author="Juan Hernández Serrano <j.hernandez@upc.edu>"
LABEL org.languagetool.version="$VERSION"
RUN  : "${VERSION:?Build argument needs to be set and non-empty.}"
COPY LanguageTool /LanguageTool
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN groupadd -r languagetool && \
    useradd --no-log-init -r -g languagetool languagetool && \
    touch /LanguageTool/empty_config.properties && \
    chown -R languagetool:languagetool /LanguageTool
WORKDIR /LanguageTool
USER languagetool
EXPOSE 8081
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
FROM ibmjava:8-sdk
COPY HealthCheck.java .
RUN javac HealthCheck.java
RUN ls -l

FROM ibmjava:8-sfj
ARG VERSION
LABEL org.languagetool.docker.author="Juan Hernández Serrano <j.hernandez@upc.edu>"
LABEL org.languagetool.version="$VERSION"
RUN  : "${VERSION:?Build argument needs to be set and non-empty.}"
COPY LanguageTool /LanguageTool
COPY --from=0 HealthCheck.class /LanguageTool/HealthCheck.class
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN \
    groupadd -r languagetool && \
    useradd --no-log-init -r -g languagetool languagetool && \
    touch /LanguageTool/empty_config.properties && \
    chown -R languagetool:languagetool /LanguageTool
WORKDIR /LanguageTool
USER languagetool
EXPOSE 8081
HEALTHCHECK \
    --interval=30s \
    --timeout=5s \
    --start-period=30s \
    --retries=3 \
    CMD java HealthCheck || bash -c 'kill -s 15 -1 && (sleep 15; kill -s 9 -1)'
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
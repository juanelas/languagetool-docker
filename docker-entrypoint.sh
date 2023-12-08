#!/bin/sh

COMMAND="java -cp languagetool-server.jar org.languagetool.server.HTTPServer"

if [ " $@" = " --help" ]; then
    COMMAND="${COMMAND} --help"
else
    if [ -f "/config.properties" ]; then
        COMMAND="${COMMAND} --config /config.properties"
    else
        # Just loading an empty config file prevents NullPointerExceptions in LT 6.3
        COMMAND="${COMMAND} --config empty_config.properties"
    fi
    COMMAND="${COMMAND} --port 8081 $@ --allow-origin '*'"
    [ -d "/word2vec" ] && COMMAND="${COMMAND} --word2vecModel /word2vec"
    [ -d "/ngrams" ] && COMMAND="${COMMAND} --languageModel /ngrams"
fi
echo $COMMAND
eval $COMMAND
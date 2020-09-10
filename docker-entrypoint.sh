#!/bin/sh

COMMAND="java -cp languagetool-server.jar org.languagetool.server.HTTPServer"

if [ " $@" = " --help" ]; then
    COMMAND="${COMMAND} --help"
else
    [ -f "/config.properties" ] && COMMAND="${COMMAND} --config /config.properties"
    COMMAND="${COMMAND} --port 8081 $@ --allow-origin '*'"
    [ -d "/word2vec" ] && COMMAND="${COMMAND} --word2vecModel /word2vec"
    [ -d "/ngrams" ] && COMMAND="${COMMAND} --languageModel /ngrams"
fi
echo $COMMAND
eval $COMMAND
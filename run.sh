#!/bin/bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

FLAG_COPIAR_PLUGINS=${PVC_PLUGINS_FOLDER}/FIRST_TIME_RUN
if [ -f "$FLAG_COPIAR_PLUGINS" ]; then
    echo "[ORIGINAL_PLUGINS][$FLAG_COPIAR_PLUGINS] nao fazer nada pois ja foi copiado os plugins para Volume Persistente..."
else
	echo "[ORIGINAL_PLUGINS] PVC_PLUGINS_FOLDER=[${PVC_PLUGINS_FOLDER}]"
	echo "[ORIGINAL_PLUGINS] ORIGINAL_PLUGINS_FOLDER=[${ORIGINAL_PLUGINS_FOLDER}]"
	if  [ "${ORIGINAL_PLUGINS_FOLDER}x" == "x" ] || [ "${PVC_PLUGINS_FOLDER}x" == "x" ]; then
		echo "[ORIGINAL_PLUGINS] para copiar os plugins originais informar as variaveis de ambiente: ORIGINAL_PLUGINS_FOLDER e PVC_PLUGINS_FOLDER"
	else
		echo "[ORIGINAL_PLUGINS] garantir existencia da estrutura [PVC_PLUGINS_FOLDER]"
		mkdir -p ${PVC_PLUGINS_FOLDER}
		echo "[ORIGINAL_PLUGINS] listando conteudo [PVC_PLUGINS_FOLDER]"
		ls -lah ${PVC_PLUGINS_FOLDER}
		echo "[ORIGINAL_PLUGINS] copying the plugins folder to the volume for the first time"
		cp --backup -v ${ORIGINAL_PLUGINS_FOLDER}/* ${PVC_PLUGINS_FOLDER}/
		echo "[ORIGINAL_PLUGINS] cria flag para nao copiar novamente caso seja feito restart do Pod"
		touch $FLAG_COPIAR_PLUGINS
		echo "[ORIGINAL_PLUGINS] listando conteudo [PVC_PLUGINS_FOLDER]"
		ls -lah ${PVC_PLUGINS_FOLDER}
	fi
fi

exec tail -F ./logs/es.log & # this tail on the elasticsearch logs is a temporary workaround, see https://github.com/docker-library/official-images/pull/6361#issuecomment-516184762
exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"

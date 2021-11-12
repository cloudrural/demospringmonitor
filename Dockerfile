FROM bharathpantala/springboot-runner:v2021.11

ENV APP_HOME /opt/app

COPY target/*.jar ${APP_HOME}/app.jar

EXPOSE 8080

WORKDIR ${APP_HOME}

CMD exec java -javaagent:/opt/jmx/jmx_prometheus_javaagent-0.16.1.jar=9100:/opt/jmx/config.yml -jar app.jar

# java -javaagent:/opt/jmx/jmx_prometheus_javaagent-0.16.1.jar=9100:/opt/jmx/config.yml -jar app.jar
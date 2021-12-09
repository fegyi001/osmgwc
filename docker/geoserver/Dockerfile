FROM kartoza/geoserver

RUN wget -O /tmp/css-ext.zip https://build.geoserver.org/geoserver/2.20.x/ext-latest/geoserver-2.20-SNAPSHOT-css-plugin.zip &&\
    mkdir /tmp/x &&\
    unzip /tmp/css-ext.zip -d /tmp/x &&\
    mv /tmp/x/*.jar /usr/local/tomcat/webapps/geoserver/WEB-INF/lib &&\
    rm -rf /tmp/x /tmp/css-ext.zip
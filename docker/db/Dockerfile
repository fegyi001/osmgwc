ARG POSTGIS_VERSION

FROM postgis/postgis:${POSTGIS_VERSION}

ARG TIMEZONE

RUN mkdir -p /opt/apps

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  wget osm2pgsql bzip2 libproj-dev \
  gdal-bin \
  && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo ${TIMEZONE} > /etc/timezone

WORKDIR /opt/downloads

RUN wget http://download.geofabrik.de/europe/hungary-latest.osm.bz2 \
  && bzip2 -d hungary-latest.osm.bz2

# add init script
RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh

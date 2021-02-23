ARG POSTGRES_VERSION

FROM postgres:${POSTGRES_VERSION}

ARG TIMEZONE 
ARG POSTGIS_VERSION

RUN mkdir -p /opt/apps

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  wget osm2pgsql bzip2 libproj-dev \
  gdal-bin \
  postgresql-$PG_MAJOR-postgis-${POSTGIS_VERSION} \
  postgresql-$PG_MAJOR-postgis-${POSTGIS_VERSION}-scripts \
  postgresql-server-dev-$PG_MAJOR \
  postgresql-$PG_MAJOR-ogr-fdw \
  && apt-get purge -y --auto-remove postgresql-server-dev-$PG_MAJOR \ 
  && ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo ${TIMEZONE} > /etc/timezone

WORKDIR /opt/downloads

RUN wget http://download.geofabrik.de/europe/hungary-latest.osm.bz2 \ 
  && bzip2 -d hungary-latest.osm.bz2

# add init script
RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh
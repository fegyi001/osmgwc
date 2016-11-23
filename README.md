# osmgwc
> A step-by-step tutorial to create a geowebcache layer from OSM data which will look just like Google Maps

## What is osmgwc?
With osmgwc you will be able to create a fast cached wms layer which will hopefully look like Google Maps. The main difference is that it will be based on the free and open source OpenStreetMap (OSM) data, stored in a PostGIS database and served with GeoServer. Another difference is that it will be stored in the spatial reference system (SRS) of your choice.

If you follow the steps below, you will download OSM data, create an empty database, populate it with geodata in the desired SRS, then split the data into different tables (settlements, rivers etc.), add them as layers in GeoServer, style them with CSS styles, create a combined layergroup, define a grid for your SRS, then finally publish a cached layer.

In this tutorial the data for Hungary will be used. The size of this country's OSM data requires reasonable time to process. 

## Prerequisites
1. PostgreSQL with PostGIS

    In this tutorial I used PostgreSQL v.9.6.1 with PostGIS v.2.3.0
2. GeoServer with the CSS plugin

    In this tutorial I used GeoServer v.2.10.0
3. osm2pgsql

    osm2pgsql is an open source tool to populate a PostGIS database with osm data. For Windows download from [here](https://ci.appveyor.com/project/openstreetmap/osm2pgsql/build/artifacts), for Linux run this command: ```apt-get install -y osm2pgsql```

4. bzip2

    bzip2 is an unzipper tool that can be used to extract data from .bz2 files. For Windows download from [here](http://www.bzip.org/downloads.html), for Linux run this command: ```apt-get install -y bzip2```

5. proj

    To be able to store OSM data in an SRS of your choice the proj library is needed. If you use Windows, the usage of OSGeo4W is recommended. With advanced install you should select the proj package. 

## Download OSM data
The data is freely available on GeoFabrik's site. For Hungary download the latest dataset in bz2 format from [here](http://download.geofabrik.de/europe/hungary-latest.osm.bz2). After download, extract it to a folder of your choice. Its extension is .osm and its size is about 2.5 GB.


## Create a new PostGIS database
Create a new database (in this tutorial this will be called 'osm', then run for the newly created database: 
```sql
create extension postgis;
```

## Populate the database with OSM data
Navigate to the folder of the extracted .osm file, and run osm2pgsql (here with Windows syntax):
```bat
osm2pgsql -s -H localhost -P 5432 -U postgres -W -d osm hungary-latest.osm --cache-strategy sparse --cache 100 -E 23700 -S C:\Programok\osm2pgsql\default.style
```
Parameters are:
* H: host (in this case: localhost)
* P: port (the default port is 5432 for PostgreSQL)
* U: PostgreSQL user (default user is postgres)
* d: database name (in this case: osm)
* cache-stratey and cache: if your machine is not very strong use these parameters, otherwise you can omit this two
* E: coordinate reference system (in this case: 23700)

http://trac.osgeo.org/osgeo4w/

...TO BE CONTINUED!
# osmgwc
> A step-by-step tutorial to create a geowebcache layer from OSM data which will look just like Google Maps

## What is osmgwc?
With osmgwc you will be able to create a fast cached wms layer which will hopefully look like Google Maps. The main difference is that it will be based on the free and open source OpenStreetMap (OSM) data, stored in a PostGIS database and served with GeoServer. Another difference is that it will be stored in the spatial reference system (SRS) of your choice.

If you follow the steps below, you will download OSM data, create an empty database, populate it with geodata in the desired SRS, then split the data into different tables (settlements, rivers etc.), add them as layers in GeoServer, style them with CSS styles, create a combined layergroup, define a grid for your SRS, then finally publish a cached layer.

## Prerequisites
1. PostgreSQL with PostGIS

    In this tutorial I used PostgreSQL v.9.6.1 with PostGIS v.2.3.0
2. GeoServer with the CSS plugin

    In this tutorial I used GeoServer v.2.10.0
3. osm2pgsql
    
    https://ci.appveyor.com/project/openstreetmap/osm2pgsql/build/artifacts

http://download.geofabrik.de/europe/hungary-latest.osm.bz2

http://trac.osgeo.org/osgeo4w/

...TO BE CONTINUED!
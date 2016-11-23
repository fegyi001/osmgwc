create schema if not exists osm;

drop table if exists osm.country;
create table osm.country(
  id serial not null primary key,
  osm_id integer,
  name text,
  uppername text,
  geom geometry(multipolygon, 23700)
);
create index gix_country on osm.country using gist(geom);
delete from osm.country;
insert into osm.country(osm_id, name, uppername, geom) 
    SELECT planet_osm_polygon.osm_id,
      planet_osm_polygon.name as name,
      upper(planet_osm_polygon.name) AS uppername,
      st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
    FROM planet_osm_polygon
    WHERE planet_osm_polygon.admin_level = '2'::text AND planet_osm_polygon.boundary = 'administrative'::text;

drop table if exists osm.amenity;
create table osm.amenity(
	id serial not null primary key,
	osm_id integer,
	geom geometry(multipolygon, 23700)
);
create index gix_amenity on osm.amenity using gist(geom);
delete from osm.amenity;
insert into osm.amenity(osm_id, geom) 
	SELECT planet_osm_polygon.osm_id,
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
   FROM planet_osm_polygon
  WHERE planet_osm_polygon.amenity IS NOT NULL AND (planet_osm_polygon.amenity = ANY (ARRAY['college'::text, 'community_centre'::text, 'courthouse'::text, 'doctors'::text, 'embassy'::text, 'grave_yard'::text, 'hospital'::text, 'library'::text, 'marketplace'::text, 'prison'::text, 'public_building'::text, 'school'::text, 'simming_pool'::text, 'theatre'::text, 'townhall'::text, 'university'::text]));
--delete from osm.amenity where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.boundary;
create table osm.boundary(
	id serial not null primary key,
	osm_id integer,
	name text,
	uppername text,
	geom geometry(multipolygon, 23700)
);
create index gix_boundary on osm.boundary using gist(geom);
delete from osm.boundary;
insert into osm.boundary(osm_id, name, uppername, geom) 
	SELECT planet_osm_polygon.osm_id,
    planet_osm_polygon.name as name,
    upper(planet_osm_polygon.name) AS uppername,
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
  FROM planet_osm_polygon
  WHERE planet_osm_polygon.admin_level = '2'::text AND planet_osm_polygon.boundary = 'administrative'::text;

drop table if exists osm.buildings;
create table osm.buildings(
  id serial not null primary key,
  osm_id integer,
  name text,
  housename text,
  housenumber text,
  geom geometry(multipolygon, 23700)
);
create index gix_buildings on osm.buildings using gist(geom);
delete from osm.buildings;
insert into osm.buildings(osm_id, name, housename, housenumber, geom) 
    SELECT planet_osm_polygon.osm_id, 
      planet_osm_polygon.name,  
      planet_osm_polygon."addr:housename",
       planet_osm_polygon."addr:housenumber",
      st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
    FROM planet_osm_polygon
    WHERE planet_osm_polygon.building IS NOT NULL AND st_area(planet_osm_polygon.way) < 100000::double precision;
--delete from osm.buildings where not st_intersects(geom, (select geom from osm.country));

drop table if exists osm.county;
create table osm.county(
	id serial not null primary key,
	osm_id integer,
	name text,
	uppername text,
	geom geometry(multipolygon, 23700)
);
create index gix_county on osm.county using gist(geom);
delete from osm.county;
insert into osm.county(osm_id, name, uppername, geom) 
	SELECT planet_osm_polygon.osm_id, 
    	planet_osm_polygon.name as name,  
    	upper(planet_osm_polygon.name) AS uppername,
    	st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
   	FROM planet_osm_polygon
  	WHERE (planet_osm_polygon.place = 'county'::text OR planet_osm_polygon.admin_level = '6'::text AND planet_osm_polygon.name = 'Budapest'::text) AND planet_osm_polygon.boundary = 'administrative'::text;
delete from osm.county where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.district;
create table osm.district(
  id serial not null primary key,
  osm_id integer,
  name text,
  uppername text,
  geom geometry(multipolygon, 23700)
);
create index gix_district on osm.district using gist(geom);
delete from osm.district;
insert into osm.district(osm_id, name, uppername, geom) 
  SELECT planet_osm_polygon.osm_id, 
    planet_osm_polygon.name, 
    upper(planet_osm_polygon.name) AS uppername,
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
  FROM planet_osm_polygon
  WHERE planet_osm_polygon.admin_level = '9'::text AND planet_osm_polygon.boundary = 'administrative'::text;
delete from osm.district where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.forestpark;
create table osm.forestpark(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multipolygon, 23700)
);
create index gix_forestpark on osm.forestpark using gist(geom);
delete from osm.forestpark;
insert into osm.forestpark(osm_id, name, geom) 
  SELECT planet_osm_polygon.osm_id, 
    planet_osm_polygon.name, 
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
  FROM planet_osm_polygon
  WHERE (planet_osm_polygon.landuse = ANY (ARRAY['forest'::text, 'orchard'::text, 'park'::text, 'plant_nursery'::text, 'grass'::text, 'greenfield'::text, 'meadow'::text, 'recreation_ground'::text, 'village_green'::text, 'vineyard'::text])) OR (planet_osm_polygon.leisure = ANY (ARRAY['nature_reserve'::text, 'park'::text, 'dog_park'::text, 'garden'::text, 'golf_course'::text, 'horse_riding'::text, 'recreation_ground'::text, 'stadium'::text]));
delete from osm.forestpark where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.lakes;
create table osm.lakes(
  id serial not null primary key,
  osm_id integer,
  name text,
  way_area real,
  geom geometry(multipolygon, 23700)
);
create index gix_lakes on osm.lakes using gist(geom);
delete from osm.lakes;
insert into osm.lakes(osm_id, name, way_area, geom) 
  SELECT planet_osm_polygon.osm_id, 
    planet_osm_polygon.name,  
    planet_osm_polygon.way_area,
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
  FROM planet_osm_polygon
  WHERE planet_osm_polygon."natural" = 'water'::text AND (planet_osm_polygon.water IS NULL OR planet_osm_polygon.water IS NOT NULL AND planet_osm_polygon.water <> 'river'::text);
delete from osm.lakes where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.minor_roads;
create table osm.minor_roads(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multilinestring, 23700)
);
create index gix_minor_roads on osm.minor_roads using gist(geom);
delete from osm.minor_roads;
insert into osm.minor_roads(osm_id, name, geom) 
  SELECT planet_osm_line.osm_id, 
    planet_osm_line.name,  
    st_multi(planet_osm_line.way)::geometry(MultiLineString, 23700) as way
  FROM planet_osm_line
  WHERE planet_osm_line.highway IS NOT NULL AND (planet_osm_line.highway <> ALL (ARRAY['motorway'::text, 'motorway_link'::text, 'trunk'::text, 'primary'::text, 'trunk_link'::text, 'primary_link'::text, 'secondary'::text, 'secondary_link'::text, 'road'::text, 'tertiary'::text, 'tertiary_link'::text, 'steps'::text, 'footway'::text, 'path'::text, 'pedestrian'::text, 'walkway'::text, 'service'::text, 'track'::text])) AND planet_osm_line.railway IS NULL OR planet_osm_line.railway = 'no'::text;
--delete from osm.minor_roads where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.motorway;
create table osm.motorway(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multilinestring, 23700)
);
create index gix_motorway on osm.motorway using gist(geom);
delete from osm.motorway;
insert into osm.motorway(osm_id, name, geom) 
  SELECT planet_osm_line.osm_id, 
 	  planet_osm_line.name,  
    st_multi(planet_osm_line.way)::geometry(MultiLineString, 23700) as way
  FROM planet_osm_line
  WHERE planet_osm_line.highway = 'motorway'::text;
delete from osm.motorway where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.pedestrian;
create table osm.pedestrian(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multilinestring, 23700)
);
create index gix_pedestrian on osm.pedestrian using gist(geom);
delete from osm.pedestrian;
insert into osm.pedestrian(osm_id, name, geom) 
  SELECT planet_osm_line.osm_id, 
   	planet_osm_line.name, 
    st_multi(planet_osm_line.way)::geometry(MultiLineString, 23700) as way
  FROM planet_osm_line
  WHERE planet_osm_line.highway = ANY (ARRAY['steps'::text, 'footway'::text, 'path'::text, 'pedestrian'::text, 'walkway'::text, 'service'::text, 'track'::text]);
--delete from osm.pedestrian where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.rails;
create table osm.rails(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multilinestring, 23700)
);
create index gix_rails on osm.rails using gist(geom);
delete from osm.rails;
insert into osm.rails(osm_id, name, geom) 
  SELECT planet_osm_line.osm_id, 
    planet_osm_line.name,  
    st_multi(planet_osm_line.way)::geometry(MultiLineString, 23700) as way
  FROM planet_osm_line
  WHERE planet_osm_line.railway IS NOT NULL AND (planet_osm_line.railway = ANY (ARRAY['light rail'::text, 'rail'::text, 'rail;construction'::text, 'tram'::text, 'yes'::text, 'traverser'::text])) OR planet_osm_line.railway ~~ '%rail%'::text;
--delete from osm.rails where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.roads;
create table osm.roads(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multilinestring, 23700)
);
create index gix_roads on osm.roads using gist(geom);
delete from osm.roads;
insert into osm.roads(osm_id, name, geom) 
 SELECT planet_osm_line.osm_id, 
    planet_osm_line.name,  
    st_multi(planet_osm_line.way)::geometry(MultiLineString, 23700) as way
   FROM planet_osm_line
  WHERE planet_osm_line.highway = ANY (ARRAY['trunk_link'::text, 'primary_link'::text, 'secondary'::text, 'secondary_link'::text, 'road'::text, 'tertiary'::text, 'tertiary_link'::text]);
--delete from osm.roads where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.settlements;
create table osm.settlements(
  id serial not null primary key,
  osm_id integer,
  name text,
  uppername text,
  way_area real,
  geom geometry(multipolygon, 23700)
);
create index gix_settlements on osm.settlements using gist(geom);
delete from osm.settlements;
insert into osm.settlements(osm_id, name, uppername, way_area, geom) 
  SELECT planet_osm_polygon.osm_id, 
    planet_osm_polygon.name, 
    upper(planet_osm_polygon.name) AS uppername,
    planet_osm_polygon.way_area,
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
  FROM planet_osm_polygon
  WHERE planet_osm_polygon.admin_level = '8'::text AND planet_osm_polygon.boundary = 'administrative'::text;
delete from osm.settlements where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.subdistrict;
create table osm.subdistrict(
  id serial not null primary key,
  osm_id integer,
  name text,
  uppername text,
  geom geometry(multipolygon, 23700)
);
create index gix_subdistrict on osm.subdistrict using gist(geom);
delete from osm.subdistrict;
insert into osm.subdistrict(osm_id, name, uppername, geom) 
  SELECT planet_osm_polygon.osm_id, 
    planet_osm_polygon.name,  
    upper(planet_osm_polygon.name) AS uppername,
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
  FROM planet_osm_polygon
  WHERE planet_osm_polygon.admin_level = '10'::text AND planet_osm_polygon.boundary = 'administrative'::text;
delete from osm.subdistrict where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.trunk_primary;
create table osm.trunk_primary(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multilinestring, 23700)
);
create index gix_trunk_primary on osm.trunk_primary using gist(geom);
delete from osm.trunk_primary;
insert into osm.trunk_primary(osm_id, name, geom) 
  SELECT planet_osm_line.osm_id, 
    planet_osm_line.name, 
    st_multi(planet_osm_line.way)::geometry(MultiLineString, 23700) as way
  FROM planet_osm_line
  WHERE planet_osm_line.highway = ANY (ARRAY['motorway_link'::text, 'trunk'::text, 'primary'::text]);
--delete from osm.trunk_primary where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.water;
create table osm.water(
  id serial not null primary key,
  osm_id integer,
  name text,
  geom geometry(multipolygon, 23700)
);
create index gix_water on osm.water using gist(geom);
delete from osm.water;
insert into osm.water(osm_id, name, geom) 
  SELECT planet_osm_polygon.osm_id, 
    planet_osm_polygon.name,  
    st_multi(planet_osm_polygon.way)::geometry(MultiPolygon, 23700) as way
  FROM planet_osm_polygon
  WHERE planet_osm_polygon."natural" = 'water'::text OR planet_osm_polygon.water IS NOT NULL OR planet_osm_polygon.waterway ~~ '%riverbank%'::text;
--delete from osm.water where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));

drop table if exists osm.waterway;
create table osm.waterway(
  id serial not null primary key,
  osm_id integer,
  name text,
  waterway text,
  geom geometry(multilinestring, 23700)
);
create index gix_waterway on osm.waterway using gist(geom);
delete from osm.waterway;
insert into osm.waterway(osm_id, name, waterway, geom) 
  SELECT planet_osm_line.osm_id, 
    planet_osm_line.name,  
    planet_osm_line.waterway,
    st_multi(planet_osm_line.way)::geometry(MultiLineString, 23700) as way
  FROM planet_osm_line
  WHERE planet_osm_line.waterway = ANY (ARRAY['drain'::text, 'canal'::text, 'waterfall'::text, 'river'::text, 'stream'::text, 'yes'::text]);
--delete from osm.waterway where not st_intersects(st_centroid(geom), (select geom from osm.country limit 1));




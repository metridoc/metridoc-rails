#!/bin/bash


for counter in {0..999}
do 
  mv /var/hold/books_mods_$counter.xml /var/hold/books_mods.xml
  docker cp /var/hold/books_mods.xml 9ee9f679aeaa:/var/local/.
  docker exec -it e493406e54ea bundle exec rake import -c marc_xml
done

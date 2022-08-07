#!/bin/bash
# downloads imdb data and loads it into a database
set -ex

rm -f db.sqlite3

#wget -c https://datasets.imdbws.com/title.episode.tsv.gz
#wget -c https://datasets.imdbws.com/title.basics.tsv.gz

basics='create table if not exists basic (tconst varchar(9) primary key, titleType text, primaryTitle text, originalTitle text, isAdult boolean, startYear text, endYear text, runtimeMinutes integer, genres text)'

episodes='create table if not exists episode (tconst varchar(9) primary key, parentTconst varchar(9), seasonNumber integer, episodeNumber integer)'

sqlite3 -line db.sqlite3 "$basics;$episodes"

zcat title.basics.tsv.gz | sed 's/"/\\"/g;' | sqlite3 -tabs db.sqlite3  ".import '|cat -' basic"
#sqlite3 -line db.sqlite3 "update basic set runtimeMinutes = null WHERE runtimeMinutes = '\N'";

zcat title.episode.tsv.gz | sed 's/"/\\"/g;' | sqlite3 -tabs db.sqlite3  ".import '|cat -' episode"

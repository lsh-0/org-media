#!/bin/bash
set -e
sqlite3 db.sqlite3 <<EOL
select b.tconst, e.seasonNumber, e. episodeNumber, b.primaryTitle, b.startYear
from 
    episode e, basic b
    
where 
    e.tconst = b.tconst
and
    parentTconst = (
        select tconst from basic where primaryTitle = 'Futurama' and startYear = '1999' and titleType = 'tvSeries'
    )
order by
    e.seasonNumber ASC,
    e.episodeNumber ASC
EOL

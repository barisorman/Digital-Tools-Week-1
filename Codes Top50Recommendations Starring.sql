-- Codes for recommendation system based on Starring
test=> ALTER TABLE movies ADD lexemesStarring tsvector;

test=> UPDATE movies SET lexemesStarring = to_tsvector(Starring);
UPDATE 5229
test=> SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('DiCaprio');
           url            
--------------------------
 the-basketball-diaries
 body-of-lies
 the-departed
 shutter-island
 django-unchained
 the-wolf-of-wall-street
 catch-me-if-you-can
 gangs-of-new-york
 inception
 the-man-in-the-iron-mask
 the-11th-hour
 the-revenant-2015
 romeo-and-juliet
 titanic
 total-eclipse
 the-aviator
 the-great-gatsby
(17 rows)

test=> ALTER TABLE movies ADD rank float4;

test=> UPDATE movies SET rank = ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies WHERE url='the-wolf-of-wall-street')));
UPDATE 5229

test=> CREATE TABLE recommendationsBasedOnStarringField1 AS SELECT url, rank FROM movies WHERE rank > 0.01 ORDER BY rank DESC LIMIT 50;
SELECT 50

test=> \copy (SELECT * FROM recommendationsBasedOnStarringField1) to '/home/pi/RSL/top50recommendationsbasedonstarring.csv'WITH csv;
COPY 50

-- These codes are conducted in order to get the best recommendations based on the Director
test=> SELECT * FROM movies where url='the-wolf-of-wall-street'

test=> ALTER TABLE movies ADD lexemesDirector tsvector;
ALTER TABLE

test=> UPDATE movies SET lexemesDirector = to_tsvector(Director);
UPDATE 5229

test=> SELECT url FROM movies WHERE lexemesDirector @@ to_tsquery('Scorsese');
              url              
-------------------------------
 cape-fear
 after-hours
 the-color-of-money
 casino
 shutter-island
 the-wolf-of-wall-street
 gangs-of-new-york
 the-age-of-innocence
 hugo
 goodfellas
 the-last-temptation-of-christ
 my-voyage-to-italy
 shine-a-light
 bringing-out-the-dead
 the-departed
 raging-bull
 the-aviator
(17 rows)

test=> UPDATE movies SET rank = ts_rank(lexemesDirector,plainto_tsquery((SELECT Director FROM movies WHERE url='the-wolf-of-wall-street')));
UPDATE 5229

test=> CREATE TABLE recommendationsBasedOnDirectorField AS SELECT url,rank FROM movies WHERE rank>0.01 ORDER BY rank DESC LIMIT 50;
SELECT 17
test=> \copy (SELECT * FROM recommendationsBasedOnDirectorField) to '/home/pi/RSL/top50recommendationsWithDirector.csv' WITH csv;
COPY 17

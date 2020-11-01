-- These codes are used to build a recommender system and a Top 50 recommendations list based on Summary for the Movie The Wolf of Wall Street
\copy moviesa FROM '~/RSL/data.csv' delimiter ';' csv header;

test=> SELECT * FROM movies where url='the-wolf-of-wall-street'

test=> UPDATE movies SET lexemesSummary = to_tsvector(Summary);
UPDATE 5229

test=> SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('business');

test=> UPDATE movies SET rank = ts_rank(lexemesSummary,plainto_tsquery((SELECT Summary FROM movies WHERE url='the-wolf-of-wall-street')));
UPDATE 5229

test=> CREATE TABLE recommendationsBasedOnSummaryField1 AS SELECT url,rank FROM movies WHERE rank>0.5 ORDER BY rank DESC LIMIT 50;
SELECT 1

test=> \copy (SELECT * FROM recommendationsBasedOnSummaryField1) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 1

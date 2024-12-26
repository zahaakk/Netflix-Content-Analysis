-- 1. Count the Number of Movies vs TV Shows
select 
	type,
	count(*) as Count
from netflix 
group by type ;
-- 2. Find the Most Common Rating for Movies and TV Shows.
select 
	rating,
	count(*) as Count
from netflix 
group by rating 
order by count desc ; # TV-MA
-- 3. List All Movies Released in a Specific Year (e.g., 2020)
select * from netflix ;
select 
	release_year,
	count(*) from netflix as Count
where type = 'Movie'
group by release_year 
order by release_year desc ;
-- 4. Find the Top 5 Countries with the Most Content on Netflix
select 
	country,
    count(*) as count
from netflix 
where country is not null 
group by country 
order by count desc 
limit 5 
;
-- 5. Identify the Longest Movie
select * from netflix ;
select title,duration
from netflix 
where type='Movie'
order by duration desc ;
-- 6. Find Content Added in the Last 5 Years
				------------- #NEED TO COMPLETE -----------------
SELECT * 
FROM netflix where str_to_date(date_added,'%M,%d,%Y') > year(current_date())-5 ;

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select * from netflix 
where director = 'Rajiv Chilaka';
-- 8. List All TV Shows with More Than 5 Seasons
select *  from netflix 
where duration like '%season%'
and left(duration,2) > 5
;
-- 9. Count the Number of Content Items in Each Genre

SELECT genre, COUNT(*) AS total_content
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
    FROM netflix
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 
        UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 
        UNION ALL SELECT 10) n 
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
    WHERE listed_in IS NOT NULL
) AS genres
GROUP BY genre 
order by total_content desc ;
-- 10.Find each year and the average numbers of content release in India on netflix.
select 
	country,
    release_year,
    count(show_id) as total_release,
    round(count(show_id) / (select count(show_id) from netflix where country = 'india') *100,2) as average_content
from netflix
where country = 'india'
group by release_year 
order by average_content desc
limit 5 ;
-- 11. List All Movies that are Documentaries
select * from netflix
where type = 'Movie' and listed_in like '%Documentaries%';
-- 12. Find All Content Without a Director	
select * from netflix 
where director is null ;
-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select * from netflix 
where release_year > year(current_date())- 10
and cast like '%Salman Khan%' ;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', n.n), ',', -1)) AS actor,
    COUNT(*) AS total_appearances
FROM netflix
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
      UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 
      UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 
      UNION ALL SELECT 10) n 
    ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= n.n - 1
WHERE country = 'India'
GROUP BY actor
ORDER BY total_appearances DESC
LIMIT 10;
select * from netflix ;
-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
with new_table as (
select *,
case
	when description like '%Kill%' or description like '%Violence%' then 'Mature_Content'
    else 'Normal Content'
end as Category
from netflix ) 

select Category, count(Category) as count
from new_table 
group by Category
;
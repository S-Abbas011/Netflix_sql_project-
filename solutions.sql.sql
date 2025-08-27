drop table if exists netflix

create table netflix( 
	show_id varchar(7),
	type varchar(10),
	title varchar(120),
	director varchar(220),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(20),
	duration varchar(30),
	listed_in varchar(100),
	description varchar(270)


);

select * from netflix 

select count(*) from netflix
select distinct(type) from netflix

--15 Business Problem
1. Count the number of Movies vs TV Shows

Select 
	type,
	count(*) as total_content
from netflix
group by type


2. Find the most common rating for movies and TV shows

select 
	type,
	rating
from
(
select
	type,
	rating,
	count(*),
	RANK() OVER(partition by netflix.type order by count(*) desc) as Ranking
from netflix
group by 1,2
) as t1
where ranking = 1



3. List all movies released in a specific year (e.g., 2020)

select *from netflix 
where 
	type = 'Movie' 
	and 
	release_year = 2020

4. Find the top 5 countries with the most content on Netflix

select * from netflix

select
	unnest(STRING_TO_ARRAY(country, ',')) as new_country,
	count(show_id) as total_content
from netflix 
group by 1
order by 2 desc
limit 5


5. Identify the longest movie

select * from netflix
where 
	type = 'Movie'
	and 
	duration = (select max(duration) from netflix)


6. Find content added in the last 5 years

Select *
from netflix
where 
	TO_DATE(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select *
from netflix 
where 
	director ILIKE '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons

Select *,
	SPLIT_PART(duration, ' ', 1) as sessions
from netflix 
Where 
	SPLIT_PART(duration, ' ', 1):: numeric > 5
AND 
	type = 'TV Show'

9. Count the number of content items in each genre

Select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id)
from netflix
group by 1
order by 2


10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

Select 
	EXTRACT(YEAR from TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	count(*),
	round(count(*)::numeric/(select count(*) 
						from netflix
								where 
								country = 'India')::numeric * 100,2) as avg_content_per_year
from netflix 
where country = 'India'
group by 1

11. List all movies that are documentaries

Select * from netflix
where 
	listed_in ILIKE '%Documentaries%'
	and 
	type = 'Movie'



12. Find all content without a director

Select *
from 
netflix 
where
	director is Null

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

Select *
from netflix 
where 
	casts ilike '%Salman Khan%'
	AND 
	release_year > EXTRACT(year from current_date) - 10

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

Select  
	unnest(STRING_TO_ARRAY(casts, ',')) as actors,
	count(*) as Total_content
from netflix
where 
	country ilike '%india'
group by 1 
order by 2 desc

from netflix 

15.  Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

with new_table as( 

Select *,
	case when description ilike '%kill%' OR
	description ilike '%violence%' Then 'Bad Content'
	else 'Good Content'
	End category
	from netflix
	)
select 
	category,
	count(*) as total_content
	from new_table
group by 1 
	


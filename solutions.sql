create table netflix
(
	show_id varchar(10),
	type 	varchar(10),
	title 	varchar(150),
	director varchar(208),
	casts 	varchar(1000)/.;['',]
	country varchar(150),
	date_added	varchar(50),
	release_year int,  
	rating varchar(10),
	duration  	varchar(15),
	listed_in 	varchar(100),
	description	varchar(250)
);

drop table if exists netflix;

-- 15 Business problems & solutions --

--1. Count the number of Movies vs Tv shows

		SELECT TYPE,COUNT(TYPE) AS TOTAL_NO
		FROM NETFLIX
		GROUP BY TYPE ;

--2. FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS 7R6UHJN ]R;=
		SELECT
		TYPE, 
		RATING
		FROM
		(SELECT TYPE,
		RATING,
		COUNT(*),
		RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
		from NETFLIX 
		GROUP BY 1,2 ) AS T1
		WHERE RANKING = 1;
		-- ORDER BY 3 DESC

--3. LIST ALL MOVIES RELEASED IN A SPECIFIC YEAR (E.G.,2020)
		
		SELECT * FROM NETFLIX 
		WHERE
		TYPE = 'Movie'
		AND
		RELEASE_YEAR = 2020;

--4. Find the top 5 countries with the most content on Netflix

		select 
		unnest(string_to_array(country, ',')) as new_country, 
		count(*) Total_country
		from Netflix 
		group by 1
		order by 2 desc
		limit 5;

--5. Identift te longest movie

		select * from netflix
		where type = 'Movie' 
		and duration is not null
		order by duration desc ;

	--alternate query 
	select * FROM netflix 
	where 
	type ='Movie'
	and 
	duration = (select max(duration)from netflix);

	--6.Find content added in the last 5 years

		SELECT *
		FROM NETFLIX
		WHERE 
		To_date(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

	--7. Find all the movies/tv shows by director 'Rajiv chilaka'

		select * from netflix 
		where director Ilike '%Rajiv Chilaka%';

	--8. List all tv shows with more than 5 seasons

		select * from netflix
		where type = 'TV Show'
		and duration > '5 Seasons';

		--Alternate query 

		select * from netflix 
		where 
		type = 'TV Show'
		and 
		SPLIT_PART(duration, ' ',1)::numeric >5;

	--9. COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE 

			SELECT  
			UNNEST(STRING_TO_ARRAY(listed_in, ',')),
			COUNT(SHOW_ID)
			from netflix
			GROUP BY 1;

	--10. Find each year and the average numbers of contents release by india on netflix top 5 year with highest ag content release 

			select 
			EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as YEAR,
			COUNT(*),
			Round(COUNT(*)::numeric/(select count(*) from netflix where country = 'India'),2)::numeric * 100 as avg_content
			from netflix
			where country = 'India'
			GROUP BY 1;

	-- 11. List all movies that are documentaries 

			select * from netflix
			where listed_in like '%Documentaries%' And 
			type = 'Movie';

		--12.Find all content without a director

			select * from netflix 
			where director is null;

		--13. Find how many movies actor 'Salman Khan' appeared in last 10 years:

			select * from netflix
			where casts Ilike '%Salman Khan%' and
			release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


	--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

			select 
			-- show_id, 
			-- casts, 
			UNNEST(STRING_TO_ARRAY(casts, ',')),
			count(*) as total_content
			from netflix
			where country Ilike '%India%'
			group by 1
			order by total_content desc
			limit 10;


	--15. Categorize the content based on the present of the keywords 'Kill' and 'violence' in the description field, Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category,

			with new_table 
			as (
			Select *,
			case 
			when description Ilike '%kill%' or 
				 description Ilike  '%violence%' then 'Bad_content'
				 else 'Good content'
				 end category
			from netflix
			)
			select 
			category, 
			count(*) as total_count
			from new_table 
			group by 1;
			
	
		
		
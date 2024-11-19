select '2023-02-19'

select '2023-02-19'::DATE
-----------------------------
--CONVERTIR FORMATOS
SELECT
	'2023-02-19'::DATE,
	'123'::INTEGER,
	'true'::BOOLEAN,
	'3.14'::REAL;
-----------------------------
SELECT 
	job_title_short as title,
	job_location as Location,
	job_posted_date::DATE as date
FROM job_postings_fact
-----------------------------
SELECT 
	job_title_short as title,
	job_location as Location,
	job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
	EXTRACT(MONTH FROM job_posted_date) AS date_month,
	EXTRACT(YEAR FROM job_posted_date) AS date_year,
	EXTRACT(DAY FROM job_posted_date) AS date_day
FROM job_postings_fact
LIMIT 10;


-----------------------------
--FUNCIONES MANIPULAR CADENAS DE TEXTO
SELECT 
	job_id,
	EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
LIMIT 10;
-----------------------------
SELECT *
FROM job_postings_fact
limit 10
-----------------------------
SELECT 
	COUNT(job_id) as job_posted_count,
	EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY job_posted_count DESC 

-----------------------------
--CREACION DE TABLAS CON EXTRACT ENERO/FEBRERO/MARZO
CREATE TABLE january_jobs AS
    (SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 1);

CREATE TABLE february_jobs AS
    (SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 2);

CREATE TABLE march_jobs AS
    (SELECT * FROM job_postings_fact WHERE EXTRACT(MONTH FROM job_posted_date) = 3);

select *
from job_postings_fact
limit 10
-----------------------------
--CASE
select 
count(job_id) as number_of_jobs,
case
when job_location ='Anywhere' then 'Remote'
when job_location ='New York, NY' then 'Local'
else 'On site'
end as location_category
from job_postings_fact
where job_title_short = 'Data Analyst'
group by location_category
order by number_of_jobs desc

-----------------------------
--SUBCONSULTAS (SELECT/FROM/WHERE)
select 
	name as company_name
from
	company_dim
where company_id in(
	select
		company_id
	from
		job_postings_fact
	where
		job_no_degree_mention = 'true'
	order by
		company_id);
-----------------------------
--CTE (COMMON TABLE EXPRESSIONS)
with company_job_count as(
	select 
		company_id,
		count(*) as total_jobs
	from 
		job_postings_fact
	group by 
		company_id
)
select 
	cd.name as company_name,
	cjd.total_jobs
from company_dim as cd
left join company_job_count as cjd
on cd.company_id = cjd.company_id
order by total_jobs desc
-----------------------------
with remote_job_skills as(
	select 
		stj.skill_id,
		count(*) as skill_count
	from 
		skills_job_dim as stj
	inner join 
		job_postings_fact as jpf
	on jpf.job_id = stj.job_id
	where 
		jpf.job_work_from_home = 'true' and
		jpf.job_title_short = 'Data Analyst'
	
	group by stj.skill_id)
-----------------------------
--UNIONES (INNER JOIN)
select 
	rjs.skill_id,
	sd.skills,
	rjs.skill_count
from remote_job_skills as rjs
inner join skills_dim as sd
on sd.skill_id = rjs.skill_id
order by rjs.skill_count desc
limit 5
-----------------------------
--UNION (UNION/UNION ALL)
SELECT 
	job_title_short,
	company_id,
	job_location
FROM january_jobs
UNION
SELECT 
	job_title_short,
	company_id,
	job_location
FROM february_jobs
UNION
SELECT 
	job_title_short,
	company_id,
	job_location
FROM march_jobs
-----------------------------
SELECT 
	job_title_short,
	company_id,
	job_location
FROM january_jobs
UNION ALL
SELECT 
	job_title_short,
	company_id,
	job_location
FROM february_jobs
UNION ALL
SELECT 
	job_title_short,
	company_id,
	job_location
FROM march_jobs
-----------------------------
SELECT 
	quarter1_job_postings.job_location,
	quarter1_job_postings.job_via,
	quarter1_job_postings.job_posted_date::DATE,
	quarter1_job_postings.salary_year_avg
FROM (
	SELECT 
		*
	FROM january_jobs
	UNION ALL
	SELECT 
		*
	FROM february_jobs
	UNION ALL
	SELECT 
		*
	FROM march_jobs
) AS quarter1_job_postings
WHERE 
	quarter1_job_postings.salary_year_avg > 70000 AND
	quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
	quarter1_job_postings.salary_year_avg DESC
-----------------------------







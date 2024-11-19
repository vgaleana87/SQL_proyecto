--1_trabajos_mejor_remunerados
select
	jpf.job_id,
	jpf.job_title,
	jpf.job_schedule_type,
	jpf.salary_year_avg,
	jpf.job_posted_date,
	cd.name as company_name
from
	job_postings_fact as jpf
left join 
	company_dim as cd
	on cd.company_id = jpf.company_id
where
	jpf.job_title_short = 'Data Analyst' AND
	jpf.job_location = 'Anywhere' AND
	jpf.salary_year_avg IS NOT NULL
ORDER BY
	jpf.salary_year_avg desc
limit 10

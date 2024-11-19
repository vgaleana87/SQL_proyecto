--4_habilidades_mejor_pagadas

select
	sd.skills,
	ROUND(avg(jpf.salary_year_avg),2) AS average_salary
from 
	job_postings_fact as jpf
inner join
	skills_job_dim as sjd on sjd.job_id = jpf.job_id
inner join
	skills_dim as sd on sd.skill_id = sjd.skill_id
where 
	jpf.job_title_short = 'Data Analyst' AND
	jpf.salary_year_avg IS NOT NULL
	AND jpf.job_work_from_home = 'True'
	
group by sd.skills
order by average_salary desc
limit 25
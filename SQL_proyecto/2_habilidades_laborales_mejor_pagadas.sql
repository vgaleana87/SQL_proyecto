--2_habilidades_mejor_pagadas

with top_paying_jobs as (
	select
		jpf.job_id,
		jpf.job_title,
		jpf.salary_year_avg,
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
)
select
	tpj.*,
	sd.skills
from 
	top_paying_jobs as tpj
inner join
	skills_job_dim as sjd on sjd.job_id = tpj.job_id
inner join
	skills_dim as sd on sd.skill_id = sjd.skill_id
order by
	tpj.salary_year_avg desc
	 






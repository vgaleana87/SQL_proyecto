--3_habilidades_mas_demandadas

select
	sd.skills,
	count(sjd.job_id) as demand_count
from 
	job_postings_fact as jpf
inner join
	skills_job_dim as sjd on sjd.job_id = jpf.job_id
inner join
	skills_dim as sd on sd.skill_id = sjd.skill_id
where 
	jpf.job_title_short = 'Data Analyst' AND
	jpf.job_work_from_home = 'True'
	
group by sd.skills
order by demand_count desc
limit 10
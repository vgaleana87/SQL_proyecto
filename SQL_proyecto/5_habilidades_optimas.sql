--5_habilidades_optimas
with skills_demand as(
	select
		sd.skills,
		sd.skill_id,
		count(sjd.job_id) as demand_count
	from 
		job_postings_fact as jpf
	inner join
		skills_job_dim as sjd on sjd.job_id = jpf.job_id
	inner join
		skills_dim as sd on sd.skill_id = sjd.skill_id
	where 
		jpf.job_title_short = 'Data Analyst' AND
		jpf.salary_year_avg IS NOT NULL AND
		jpf.job_work_from_home = 'True'
	group by sd.skill_id
),

average_salary as(
	select
		sd.skills,
		sd.skill_id,
		ROUND(avg(jpf.salary_year_avg),2) AS average_salary
	from 
		job_postings_fact as jpf
	inner join
		skills_job_dim as sjd on sjd.job_id = jpf.job_id
	inner join
		skills_dim as sd on sd.skill_id = sjd.skill_id
	where 
		jpf.job_title_short = 'Data Analyst' AND
		jpf.salary_year_avg IS NOT NULL AND
		jpf.job_work_from_home = 'True'
	group by sd.skill_id
)

select
	sd.skills,
	sd.skill_id,
	sd.demand_count,
	avs.average_salary
from 
	skills_demand as sd
inner join
	average_salary as avs
	on avs.skill_id = sd.skill_id
order by 
	avs.average_salary desc
limit 10
	


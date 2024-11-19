Introducción
📊 ¡Sumérgete en el mercado laboral de los datos! Este proyecto, centrado en los puestos de analista de datos, explora 💰 los empleos mejor pagados, 🔥 las habilidades más demandadas y 📈 dónde la alta demanda se combina con los altos salarios en el análisis de datos.

🔍 ¿Consultas SQL? Échales un vistazo aquí: [carpeta proyecto_sql](SQL_proyecto)

# Antecedentes
Este proyecto, impulsado por la búsqueda de explorar el mercado laboral de los analistas de datos de manera más eficaz, nació del deseo de identificar las habilidades mejor pagadas y más demandadas, agilizando el trabajo de otros para encontrar los empleos óptimos.

Los datos provienen del Analista de Datos/Youtuber 
Thanks to Mr.Luke Barousse  [Curso de SQL](https://lukebarousse.com/sql)  [Web Page](https://datanerd.tech/).
Está repleto de información sobre puestos de trabajo, salarios, ubicaciones y habilidades esenciales.

### Las preguntas que quería responder a través de mis consultas SQL eran:

1. ¿Cuáles son los trabajos de analista de datos mejor pagados?
2. ¿Qué habilidades se requieren para estos trabajos mejor pagados?
3. ¿Qué habilidades son las más demandadas por los analistas de datos?
4. ¿Qué habilidades están asociadas con salarios más altos?
5. ¿Cuáles son las habilidades más óptimas para aprender?

# Herramientas que utilicé
Para mi inmersión profunda en el mercado laboral de analista de datos, aproveché el poder de varias herramientas clave:

- **SQL:** La columna vertebral de mi análisis, que me permite consultar la base de datos y descubrir información crítica.
- **PostgreSQL:** El sistema de gestión de bases de datos elegido, ideal para manejar los datos de publicación de empleos.
- **Visual Studio Code:** Mi opción para la gestión de bases de datos y la ejecución de consultas SQL.
- **Git y GitHub:** Esencial para el control de versiones y para compartir mis scripts y análisis SQL, lo que garantiza la colaboración y el seguimiento del proyecto.

# El análisis
Cada consulta para este proyecto tenía como objetivo investigar aspectos específicos del mercado laboral de analista de datos. Así es como abordé cada pregunta:

### 1. Los puestos de analista de datos mejor remunerados
Para identificar los puestos mejor remunerados, filtré los puestos de analista de datos por salario anual promedio y ubicación, centrándome en los trabajos remotos. Esta consulta destaca las oportunidades mejor remuneradas en el campo.

```sql
SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

Aquí se muestra el desglose de los mejores trabajos de analista de datos en 2023:
- **Amplia gama salarial:** Los 10 puestos de analista de datos mejor pagados van desde $184,000 a $650,000, lo que indica un potencial salarial significativo en el campo.
- **Empleadores diversos:** Empresas como SmartAsset, Meta y AT&T se encuentran entre las que ofrecen salarios altos, lo que demuestra un amplio interés en diferentes industrias.
- **Variedad de puestos de trabajo:** Existe una gran diversidad de puestos de trabajo, desde analista de datos hasta director de análisis, lo que refleja diversos roles y especializaciones dentro del análisis de datos.

![Puestos mejor pagados](assets/1_top_paying_roles.png)
*Gráfico de barras que visualiza el salario de los 10 mejores salarios para analistas de datos; ChatGPT generó este gráfico a partir de los resultados de mi consulta SQL*

### 2. Habilidades para los trabajos mejor remunerados
Para entender qué habilidades se requieren para los trabajos mejor remunerados, uní las publicaciones de empleo con los datos de habilidades, lo que brinda información sobre lo que los empleadores valoran para los puestos de alta remuneración.

```sql
WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

Aquí se muestra el desglose de las habilidades más demandadas para los 10 trabajos de analista de datos mejor pagados en 2023:
- **SQL** lidera con un recuento en negrita de 8.
- **Python** le sigue de cerca con un recuento en negrita de 7.
- **Tableau** también es muy buscado, con un recuento en negrita de 6.
Otras habilidades como **R**, **Snowflake**, **Pandas** y **Excel** muestran distintos grados de demanda.

![Habilidades mejor pagadas](assets/2_top_paying_roles_skills.png)
*Gráfico de barras que visualiza el recuento de habilidades para los 10 trabajos mejor pagados para analistas de datos; ChatGPT generó este gráfico a partir de los resultados de mi consulta SQL*

### 3. Habilidades en demanda para analistas de datos
Esta consulta ayudó a identificar las habilidades solicitadas con más frecuencia en las publicaciones de trabajo, dirigiendo el enfoque a las áreas con alta demanda.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

A continuación, se muestra un desglose de las habilidades más demandadas para los analistas de datos en 2023
- **SQL** y **Excel** siguen siendo fundamentales, lo que enfatiza la necesidad de sólidas habilidades básicas en el procesamiento de datos y la manipulación de hojas de cálculo.
- **Las herramientas de programación** y **visualización** como **Python**, **Tableau** y **Power BI** son esenciales, lo que indica la creciente importancia de las habilidades técnicas en la narración de datos y el apoyo a la toma de decisiones.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Tabla de la demanda de las 5 principales habilidades en las ofertas de trabajo de analista de datos*

### 4. Habilidades basadas en el salario
Al analizar los salarios promedio asociados con diferentes habilidades, se revelaron cuáles son las habilidades que mejor pagan.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
A continuación, se muestra un desglose de los resultados de las habilidades mejor pagadas para los analistas de datos:
- **Alta demanda de habilidades de Big Data y ML:** Los mejores salarios los obtienen los analistas expertos en tecnologías de Big Data (PySpark, Couchbase), herramientas de aprendizaje automático (DataRobot, Jupyter) y bibliotecas de Python (Pandas, NumPy), lo que refleja la alta valoración que la industria hace de las capacidades de procesamiento de datos y modelado predictivo.
- **Competencia en desarrollo e implementación de software:** El conocimiento en herramientas de desarrollo e implementación (GitLab, Kubernetes, Airflow) indica una combinación lucrativa entre el análisis de datos y la ingeniería, con una prima en las habilidades que facilitan la automatización y la gestión eficiente de la canalización de datos.
- **Experiencia en computación en la nube:** La familiaridad con las herramientas de ingeniería de datos y la nube (Elasticsearch, Databricks, GCP) subraya la creciente importancia de los entornos de análisis basados ​​en la nube, lo que sugiere que la competencia en la nube aumenta significativamente el potencial de ingresos en el análisis de datos.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Tabla del salario promedio de las 10 habilidades mejor pagadas para analistas de datos*

### 5. Las habilidades más óptimas para aprender

Esta consulta, que combina información de datos de demanda y salarios, tuvo como objetivo identificar las habilidades que tienen una alta demanda y salarios altos, ofreciendo un enfoque estratégico para el desarrollo de habilidades.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 8        | go         | 27           |            115,320 |
| 234      | confluence | 11           |            114,210 |
| 97       | hadoop     | 22           |            113,193 |
| 80       | snowflake  | 37           |            112,948 |
| 74       | azure      | 34           |            111,225 |
| 77       | bigquery   | 13           |            109,654 |
| 76       | aws        | 32           |            108,317 |
| 4        | java       | 17           |            106,906 |
| 194      | ssis       | 12           |            106,683 |
| 233      | jira       | 20           |            104,918 |

*Tabla de las habilidades más óptimas para analista de datos ordenadas por salario*

A continuación, se muestra un desglose de las habilidades más óptimas para analistas de datos en 2023:
- **Lenguajes de programación de alta demanda:** Python y R se destacan por su alta demanda, con un recuento de demanda de 236 y 148 respectivamente. A pesar de su alta demanda, sus salarios promedio rondan los $101,397 para Python y los $100,499 para R, lo que indica que el dominio de estos lenguajes es muy valorado pero también está ampliamente disponible.
- **Herramientas y tecnologías en la nube:** Las habilidades en tecnologías especializadas como Snowflake, Azure, AWS y BigQuery muestran una demanda significativa con salarios promedio relativamente altos, lo que apunta a la creciente importancia de las plataformas en la nube y las tecnologías de big data en el análisis de datos.
- **Herramientas de visualización e inteligencia empresarial:** Tableau y Looker, con una demanda de 230 y 49 respectivamente, y salarios promedio de alrededor de $99,288 y $103,795, destacan el papel fundamental de la visualización de datos y la inteligencia empresarial para obtener información útil a partir de los datos.
- **Tecnologías de bases de datos:** La demanda de habilidades en bases de datos tradicionales y NoSQL (Oracle, SQL Server, NoSQL) con salarios promedio que van desde $97,786 a $104,534, refleja la necesidad permanente de experiencia en almacenamiento, recuperación y administración de datos.

# Lo que aprendí

A lo largo de esta aventura, he potenciado mi kit de herramientas SQL con una gran potencia:

- **🧩 Creación de consultas complejas:** Dominé el arte del SQL avanzado, fusionando tablas como un profesional y utilizando cláusulas WITH para maniobras de tablas temporales de nivel ninja.
- **📊 Agregación de datos:** Me familiaricé con GROUP BY y convertí las funciones de agregación como COUNT() y AVG() en mis compañeras para resumir datos.
- **💡 Magia analítica:** Mejoré mis habilidades para resolver problemas del mundo real, convirtiendo las preguntas en consultas SQL prácticas y perspicaces.
# Conclusiones

### Insights
Del análisis surgieron varias conclusiones generales:

1. **Puestos de analista de datos mejor remunerados**: Los puestos de trabajo mejor remunerados para analistas de datos que permiten el trabajo remoto ofrecen una amplia gama de salarios, ¡el más alto es de $650,000!
2. **Habilidades para los puestos de trabajo mejor remunerados**: Los puestos de trabajo de analista de datos bien remunerados requieren un dominio avanzado de SQL, lo que sugiere que es una habilidad fundamental para ganar un salario alto.
3. **Habilidades más demandadas**: SQL también es la habilidad más demandada en el mercado laboral de analistas de datos, por lo que es esencial para quienes buscan empleo.
4. **Habilidades con salarios más altos**: Las habilidades especializadas, como SVN y Solidity, están asociadas con los salarios promedio más altos, lo que indica una prima en la experiencia de nicho.
5. **Habilidades óptimas para el valor del mercado laboral**: SQL es una de las habilidades más demandadas y ofrece un salario promedio alto, lo que la posiciona como una de las habilidades más óptimas que los analistas de datos deben aprender para maximizar su valor de mercado.

### Reflexiones finales

Este proyecto mejoró mis habilidades en SQL y me brindó información valiosa sobre el mercado laboral de los analistas de datos. Los hallazgos del análisis sirven como guía para priorizar el desarrollo de habilidades y los esfuerzos de búsqueda de empleo. Los aspirantes a analistas de datos pueden posicionarse mejor en un mercado laboral competitivo si se concentran en habilidades de alta demanda y altos salarios. Esta exploración destaca la importancia del aprendizaje continuo y la adaptación a las tendencias emergentes en el campo del análisis de datos.

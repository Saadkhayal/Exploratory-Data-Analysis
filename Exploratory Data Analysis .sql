-- Exploraroty Data Analysis--
-- EDA

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

-- normally when you start the EDA process you have some idea of what you're looking for

-- with this info we are just going to look around and see what we find!

select *
from layoffs_staging;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging;

select *
from layoffs_staging
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging
group by company
order by 2 desc;

select min('date'),max('date')
from layoffs_staging;

select country, sum(total_laid_off)
from layoffs_staging
group by country
order by 2 desc;

select year('date'), sum(total_laid_off)
from layoffs_staging
group by year('date')
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging
group by stage
order by 1 desc;

select substring('date',1,7) as 'Month', sum(total_laid_off)
from layoffs_staging
where  substring('date',1,7) is not null
group by 'Month'
order by 1 asc;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(date)
ORDER BY 1 ASC;
-- TOUGHER QUERIES------------------------------------------------------------------------------------------------------------------------------------

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.
-- I want to look at --
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;


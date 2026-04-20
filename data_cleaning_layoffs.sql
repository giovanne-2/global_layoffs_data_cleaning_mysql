-- DATA CLEANING PROJECT - LAYOFFS DATASET (MySQL)
-- Author: Giovanne Alves
-- Description: Cleaning and preparing layoffs dataset

-- 1. CREATE STAGING TABLE
-- Create a working copy to avoid modifying raw data

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;


-- 2. REMOVE DUPLICATES
-- Create a new table with row numbers to identify duplicates

CREATE TABLE layoffs_staging2 (
company TEXT,
location TEXT,
industry TEXT,
total_laid_off INT DEFAULT NULL,
percentage_laid_off TEXT,
`date` TEXT,
stage TEXT,
country TEXT,
funds_raised_millions INT DEFAULT NULL,
row_num INT
);

-- Insert data and assign row numbers

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- Remove duplicates (keep first occurrence)

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Drop helper column

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- 3. STANDARDIZE DATA
-- Remove leading/trailing spaces

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry values

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Clean country formatting

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 4. FORMAT DATE COLUMN
-- Convert text to DATE format

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Change column datatype

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 5. HANDLE NULL & BLANK VALUES
-- Convert blank industry values to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate missing industry values using same company

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- 6. REMOVE IRRELEVANT ROWS
-- Remove rows without layoff information

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- FINAL CHECK

SELECT *
FROM layoffs_staging2
LIMIT 10;

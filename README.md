# 🧹 Layoffs Data Cleaning Project (MySQL)

![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Focus](https://img.shields.io/badge/Focus-Data%20Cleaning-orange)

---

## 📖 About the Project

This project focuses on cleaning and preparing a layoffs dataset for further analysis.

The goal was to transform raw data into a structured, consistent, and reliable dataset that can be confidently used for exploration, visualization, or modeling.

---

## 🎯 Objective

Prepare the dataset by:

* Removing duplicate records
* Standardizing values across columns
* Handling missing or blank data
* Converting data types where needed
* Filtering out irrelevant entries

---

## 🛠️ Tools & Technologies

* MySQL
* SQL (Window Functions, CTEs, Joins)

---

## 📂 Project Structure
layoffs-data-cleaning/
├── README.md
├── data_cleaning_layoffs.sql
└── layoffs.csv

---

## 🔄 Data Cleaning Process

### 1. Creating a Staging Table

```sql id="a1s9df"
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;
```

This ensures the original dataset remains unchanged while all transformations are applied to a working copy.

---

### 2. Removing Duplicates

Duplicates were identified using a window function:

```sql id="s9d8f7"
ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, 
                 total_laid_off, percentage_laid_off, date,
                 stage, country, funds_raised_millions
)
```

Only the first occurrence of each group was kept.

---

### 3. Standardizing Data

Several adjustments were made to improve consistency:

* Trimming extra spaces from text fields
* Standardizing category values (e.g., variations of "Crypto")
* Cleaning formatting inconsistencies in country names

---

### 4. Handling Dates

Dates were converted from text format into proper `DATE` format:

```sql id="j3k2l1"
STR_TO_DATE(date, '%m/%d/%Y')
```

---

### 5. Handling Missing Values

* Blank values were converted to `NULL`
* Missing industry values were filled using existing data from the same company

---

### 6. Removing Irrelevant Records

Rows without meaningful layoff information were removed:

```sql id="l2k3j4"
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```

---

## 📊 Final Result

The cleaned dataset is:

* Consistent and standardized
* Free of duplicates
* Structured with proper data types
* Ready for analysis and visualization

---

## 🧠 Key Takeaways

* Window functions are powerful for identifying duplicates
* Staging tables help keep transformations safe and organized
* Data consistency is essential for reliable analysis

---

## 👨‍💻 Author

Giovanne Alves

---

## ⭐ If you found this project useful

Feel free to give it a star or share it.

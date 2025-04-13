Select * From Loan_default

--Step 1: Verify the Imported Data (Before diving into analysis, ensure the dataset is properly imported and structured.)
SELECT TOP 10 * FROM Loan_default

--Step 2: Start with Basic Data Exploration (Run a query to check how many loans in the dataset are defaulted versus repaid (based on the  column):
--Understand the distribution of  (e.g.,  for defaulted,  for paid) to establish a baseline for analysis.

SELECT Status, COUNT(*) AS Total_Count
FROM loan_default
GROUP BY Status;

--Step 3: Analyze Defaults by Loan Attributes (The next logical step is to determine which attributes might influence loan defaults. Let's start by analyzing Loan Type and how it relates to the default rate.)
-- Identify which loan types (e.g., type1, type2) have the highest default rates.
-- Pinpoint high-risk loan types for further investigation.
SELECT Loan_Type, 
       COUNT(*) AS Total_Loans, 
       SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
       ROUND((SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Default_Rate
FROM loan_default
GROUP BY Loan_Type
ORDER BY Default_Rate DESC;

-- Step 4: Analyze Defaults by Loan Purpose (Now, let's drill down further by investigating the Loan Purpose () field to see if certain purposes correlate with higher defaults.)
-- Reveal which loan purposes (e.g., , , ) are most prone to default.
-- Help identify high-risk purposes that require targeted policies.

SELECT Loan_Purpose, 
       COUNT(*) AS Total_Loans, 
       SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
       ROUND((SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Default_Rate
FROM loan_default
GROUP BY Loan_Purpose
ORDER BY Default_Rate DESC;

--Step 5: Analyze Defaults by Region (Regions often play a critical role in loan performance. Let’s now investigate the default rates across different geographic regions () to identify high-risk locations.)
-- Examine which regions have the highest default rates.
-- Identify geographic areas requiring focused interventions and policy changes.
SELECT Region, 
       COUNT(*) AS Total_Loans, 
       SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
       ROUND((SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Default_Rate
FROM loan_default
GROUP BY Region
ORDER BY Default_Rate DESC

--Step 6: Analyze Defaults by Credit Score 
-- (Next, let's investigate whether credit scores () have a strong correlation with loan defaults. We'll group loans into credit score ranges (e.g., 300–500, 501–700) to uncover trends.)
-- Group loans by credit score ranges.
-- Show how default rates vary for borrowers with different creditworthiness.
-- Help identify high-risk score ranges requiring stricter approval policies.

SELECT 
    CASE 
        WHEN Credit_Score < 500 THEN '300-499'
        WHEN Credit_Score BETWEEN 500 AND 700 THEN '500-700'
        WHEN Credit_Score > 700 THEN '701-850'
        ELSE 'Unknown'
    END AS Credit_Score_Range,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
    ROUND((SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Default_Rate
FROM loan_default
GROUP BY 
    CASE 
        WHEN Credit_Score < 500 THEN '300-499'
        WHEN Credit_Score BETWEEN 500 AND 700 THEN '500-700'
        WHEN Credit_Score > 700 THEN '701-850'
        ELSE 'Unknown'
    END
ORDER BY Default_Rate DESC;

-- Step 7: Analyze Loan-to-Value (LTV) Ratio and Defaults
-- Let’s explore whether the LTV (Loan-to-Value ratio) is a significant risk factor. 
-- This will help determine if borrowers taking loans with higher LTV ratios (closer to property value) tend to default more often.
-- Analyze LTV ranges (e.g., , , ) and their impact on default rates.
-- Determine if high LTV loans are riskier and demand stricter approval policies.

SELECT 
    CASE 
        WHEN LTV <= 50 THEN '0-50%'
        WHEN LTV BETWEEN 51 AND 80 THEN '51-80%'
        WHEN LTV > 80 THEN '81%+'
        ELSE 'Unknown'
    END AS LTV_Range,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) AS Defaulted_Loans,
    ROUND((SUM(CASE WHEN Status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS Default_Rate
FROM loan_default
GROUP BY 
    CASE 
        WHEN LTV <= 50 THEN '0-50%'
        WHEN LTV BETWEEN 51 AND 80 THEN '51-80%'
        WHEN LTV > 80 THEN '81%+'
        ELSE 'Unknown'
    END
ORDER BY Default_Rate DESC;

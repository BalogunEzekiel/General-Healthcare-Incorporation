# GENERAL HEALTHCARE ANALYSIS

#1. Average Billing Amount by Medical Condition
SELECT `Medical Condition`, ROUND(AVG(`Billing Amount`), 2) AS Average_Billing
FROM healthdata
GROUP BY `Medical Condition`
ORDER BY Average_Billing DESC;

#2. Gender Distribution Across Medical Conditions
SELECT `Medical Condition`, `Gender`, COUNT(*) AS Patient_Count
FROM healthdata
GROUP BY `Medical Condition`, `Gender`
ORDER BY `Medical Condition` ASC, Patient_Count DESC;

#3. Patients Gender Distribution
SELECT `Gender`, COUNT(*) AS Total_Count
FROM healthdata
GROUP BY `Gender`
ORDER BY Total_Count DESC;

# Create 'Length of Stay' Column
ALTER TABLE healthdata
ADD COLUMN `Length of Stay` INT;

# Disable Safe Update Mode Temporarily
SET SQL_SAFE_UPDATES = 0;

# Calculate and Populate 'Length of Stay' Column
UPDATE healthdata
SET `Length of Stay` = DATEDIFF(`Discharge Date`, `Date of Admission`);

# Enable Safe Update Mode
SET SQL_SAFE_UPDATES = 1;

#4. Average Length of Stay by Admission Type
SELECT `Admission Type`, ROUND(AVG(`Length of Stay`), 2) AS Average_Stay_Days
FROM healthdata
GROUP BY `Admission Type`
ORDER BY Average_Stay_Days DESC;

#5. Average Length of Stay by Medical Condition
SELECT `Medical Condition`, ROUND(AVG(`Length of Stay`), 2) AS Average_Stay_Days
FROM healthdata
GROUP BY `Medical Condition`
ORDER BY Average_Stay_Days DESC;

#6. Top Ten Hospital by Total Billing Amount
SELECT `Hospital`, ROUND(SUM(`Billing Amount`), 2) AS Total_Billing
FROM healthdata
GROUP BY `Hospital`
ORDER BY Total_Billing DESC
LIMIT 10;

#7. Most Common Medication for Each Medical Condition
WITH RankedMedications AS (
SELECT `Medical Condition`, `Medication`, COUNT(*) AS Prescription_Count, ROW_NUMBER()
OVER (PARTITION BY `Medical Condition`
ORDER BY COUNT(*) DESC) AS rn
FROM healthdata
GROUP BY `Medical Condition`, `Medication`)
SELECT `Medical Condition`, `Medication`, Prescription_Count
FROM RankedMedications
WHERE rn = 1;

#8. Test Result Distribution by Medication
SELECT `Medication`, `Test Results`, COUNT(*) AS Result_Count
FROM healthdata
GROUP BY `Medication`, `Test Results`
ORDER BY `Medication` ASC, Result_Count DESC;

#9. Top Five Doctors With Highest Average Billing
SELECT `Doctor`, ROUND(AVG(`Billing Amount`), 2) AS Average_Billing
FROM healthdata
GROUP BY `Doctor`
ORDER BY Average_Billing DESC
LIMIT 5;

#10. Monthly Admission Trend in Last Tewlve Months
SELECT DATE_FORMAT(`Date of Admission`, '%Y-%m') AS Month, Count(*) AS Admissions
FROM healthdata
WHERE `Date of Admission` >= DATE_SUB((SELECT MAX(`Date of Admission`) FROM healthdata), INTERVAL 12 MONTH)
GROUP BY Month
ORDER BY Month DESC
LIMIT 12;

#11. Insurance Providers With Highest Total Billing
SELECT `Insurance Provider`, ROUND(SUM(`Billing Amount`), 2) AS Total_Billing
FROM healthdata
GROUP BY `Insurance Provider`
ORDER BY Total_Billing DESC;

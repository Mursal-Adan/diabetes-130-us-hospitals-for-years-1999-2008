CREATE DATABASE hospital_diabetes;
USE hospital_diabetes;

CREATE TABLE diabetic_data (
    encounter_id TEXT,
    patient_nbr TEXT,
    race TEXT,
    gender TEXT,
    age TEXT,
    weight TEXT,
    admission_type_id TEXT,
    discharge_disposition_id TEXT,
    admission_source_id TEXT,
    time_in_hospital TEXT,
    payer_code TEXT,
    medical_specialty TEXT,
    num_lab_procedures TEXT,
    num_procedures TEXT,
    num_medications TEXT,
    number_outpatient TEXT,
    number_emergency TEXT,
    number_inpatient TEXT,
    diag_1 TEXT,
    diag_2 TEXT,
    diag_3 TEXT,
    number_diagnoses TEXT,
    max_glu_serum TEXT,
    A1Cresult TEXT,
    metformin TEXT,
    repaglinide TEXT,
    nateglinide TEXT,
    chlorpropamide TEXT,
    glimepiride TEXT,
    acetohexamide TEXT,
    glipizide TEXT,
    glyburide TEXT,
    tolbutamide TEXT,
    pioglitazone TEXT,
    rosiglitazone TEXT,
    acarbose TEXT,
    miglitol TEXT,
    troglitazone TEXT,
    tolazamide TEXT,
    examide TEXT,
    citoglipton TEXT,
    insulin TEXT,
    `glyburide-metformin` TEXT,
    `glipizide-metformin` TEXT,
    `glimepiride-pioglitazone` TEXT,
    `metformin-rosiglitazone` TEXT,
    `metformin-pioglitazone` TEXT,
    `change` TEXT,
    diabetesMed TEXT,
    readmitted TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/diabetic_data.csv'
INTO TABLE diabetic_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM diabetic_data;

CREATE TABLE admission_type (
    admission_type_id INT,
    description TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/admission_type.csv'
INTO TABLE admission_type
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM admission_type;


CREATE TABLE discharge_disposition (
    discharge_disposition_id INT,
    description TEXT
);

TRUNCATE TABLE discharge_disposition;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/discharge_disposition.csv'
INTO TABLE discharge_disposition
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM discharge_disposition;
SELECT * FROM discharge_disposition ORDER BY discharge_disposition_id;
SELECT * FROM discharge_disposition WHERE discharge_disposition_id = 18;


CREATE TABLE admission_source (
    admission_source_id INT,
    description TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/admission_source.csv'
INTO TABLE admission_source
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM admission_source;
SELECT * FROM admission_source;

-- Investigation

SHOW TABLES;

DESCRIBE admission_source;
DESCRIBE discharge_disposition;
DESCRIBE admission_type;
DESCRIBE diabetic_data;

SELECT COUNT(*) FROM diabetic_data WHERE race = '?';
SELECT COUNT(*) FROM diabetic_data WHERE weight = '?';
SELECT COUNT(*) FROM diabetic_data WHERE payer_code = '?';
SELECT COUNT(*) FROM diabetic_data WHERE medical_specialty = '?';
SELECT COUNT(*) FROM diabetic_data WHERE diag_1 = '?';
SELECT COUNT(*) FROM diabetic_data WHERE diag_2 = '?';
SELECT COUNT(*) FROM diabetic_data WHERE diag_3 = '?';

SELECT encounter_id, COUNT(*) FROM diabetic_data GROUP BY encounter_id HAVING COUNT(*) > 1;

SELECT patient_nbr, COUNT(*) AS visits FROM diabetic_data GROUP BY patient_nbr ORDER BY visits DESC LIMIT 10;

SELECT DISTINCT gender FROM diabetic_data;
SELECT DISTINCT race FROM diabetic_data;
SELECT DISTINCT age FROM diabetic_data;
SELECT DISTINCT readmitted FROM diabetic_data;
SELECT DISTINCT max_glu_serum FROM diabetic_data;
SELECT DISTINCT A1Cresult FROM diabetic_data;

SELECT DISTINCT admission_type_id FROM diabetic_data
WHERE admission_type_id NOT IN (SELECT admission_type_id FROM admission_type);

SELECT DISTINCT admission_type_id FROM diabetic_data
WHERE admission_type_id NOT IN (SELECT discharge_disposition_id FROM discharge_disposition);

SELECT DISTINCT admission_type_id FROM diabetic_data
WHERE admission_type_id NOT IN (SELECT admission_source_id FROM admission_source);

SELECT MIN(CAST(time_in_hospital AS UNSIGNED)), MAX(CAST(time_in_hospital AS UNSIGNED)) FROM diabetic_data;
SELECT MIN(CAST(num_lab_procedures AS UNSIGNED)), MAX(CAST(num_lab_procedures AS UNSIGNED)) FROM diabetic_data;
SELECT MIN(CAST(num_medications AS UNSIGNED)), MAX(CAST(num_medications AS UNSIGNED)) FROM diabetic_data;
SELECT MIN(CAST(number_diagnoses AS UNSIGNED)), MAX(CAST(number_diagnoses AS UNSIGNED)) FROM diabetic_data;

SELECT MIN(CAST(number_outpatient AS UNSIGNED)), MAX(CAST(number_outpatient AS UNSIGNED)) FROM diabetic_data;
SELECT MIN(CAST(number_emergency AS UNSIGNED)), MAX(CAST(number_emergency AS UNSIGNED)) FROM diabetic_data;
SELECT MIN(CAST(number_inpatient AS UNSIGNED)), MAX(CAST(number_inpatient AS UNSIGNED)) FROM diabetic_data;
SELECT MIN(CAST(number_diagnoses AS UNSIGNED)), MAX(CAST(number_diagnoses AS UNSIGNED)) FROM diabetic_data;


SELECT readmitted,
CASE WHEN readmitted = '<30' THEN 'Readmitted_30d' ELSE 'Not_Readmitted_30d' END,
 COUNT(*) FROM diabetic_data GROUP BY readmitted;

-- Cleaning

UPDATE diabetic_data
SET payer_code = 'Unknown'
WHERE payer_code = '?';

UPDATE diabetic_data
SET race = 'Unknown'
WHERE race = '?';

UPDATE diabetic_data
SET medical_specialty = 'Unknown'
WHERE medical_specialty = '?';

UPDATE diabetic_data
SET diag_1 = 'Unknown'
WHERE diag_1 = '?';

UPDATE diabetic_data
SET diag_2 = 'Unknown'
WHERE diag_2 = '?';

UPDATE diabetic_data
SET diag_3 = 'Unknown'
WHERE diag_3 = '?';
, , -, , , 
ALTER TABLE diabetic_data MODIFY time_in_hospital INT;
ALTER TABLE diabetic_data MODIFY num_procedures INT;
ALTER TABLE diabetic_data MODIFY num_medications INT;
ALTER TABLE diabetic_data MODIFY num_medications INT;
ALTER TABLE diabetic_data MODIFY number_emergency INT;
ALTER TABLE diabetic_data MODIFY number_inpatient INT;
ALTER TABLE diabetic_data MODIFY number_diagnoses INT;
ALTER TABLE diabetic_data MODIFY num_lab_procedures INT;
ALTER TABLE diabetic_data MODIFY number_outpatient INT;
ALTER TABLE diabetic_data MODIFY admission_type_id INT;
ALTER TABLE diabetic_data MODIFY discharge_disposition_id INT;
ALTER TABLE diabetic_data MODIFY admission_source_id INT;

ALTER TABLE diabetic_data ADD COLUMN readmitted_30d TEXT;

UPDATE diabetic_data
SET readmitted_30d = CASE 
    WHEN readmitted = '<30' THEN 'Readmitted_30d'
    ELSE 'Not_Readmitted_30d'
END;

SELECT readmitted_30d, COUNT(*) FROM diabetic_data GROUP BY readmitted_30d;

SELECT DISTINCT readmitted, LENGTH(readmitted) FROM diabetic_data;

UPDATE diabetic_data
SET readmitted_30d = CASE 
    WHEN TRIM(readmitted) = '<30' THEN 'Readmitted_30d'
    ELSE 'Not_Readmitted_30d'
END;

SELECT readmitted, HEX(readmitted) FROM diabetic_data WHERE readmitted LIKE '%30%' LIMIT 5;

UPDATE diabetic_data
SET readmitted_30d = CASE 
    WHEN TRIM(REPLACE(readmitted, CHAR(13), '')) = '<30' THEN 'Readmitted_30d'
    ELSE 'Not_Readmitted_30d'
END;
SELECT readmitted_30d, COUNT(*) FROM diabetic_data GROUP BY readmitted_30d;

select * from diabetic_data limit 5;


-- Analyses

CREATE VIEW readmit_by_admission_type AS
SELECT a.description,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN d.readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) AS readmitted_count,
       ROUND(SUM(CASE WHEN d.readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS readmit_rate_pct
FROM diabetic_data d
JOIN admission_type a ON d.admission_type_id = a.admission_type_id
GROUP BY a.description
ORDER BY readmit_rate_pct DESC;

CREATE VIEW readmit_by_discharge_disposition AS
SELECT disc.description,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN d.readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) AS readmitted_count,
       ROUND(SUM(CASE WHEN d.readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS readmit_rate_pct
FROM diabetic_data d
JOIN discharge_disposition disc ON d.discharge_disposition_id = disc.discharge_disposition_id
GROUP BY disc.description
ORDER BY readmit_rate_pct DESC;

CREATE VIEW readmit_by_length_of_stay AS
SELECT readmitted_30d, AVG(time_in_hospital) as avg_time_in_hospital
FROM diabetic_data
GROUP BY readmitted_30d
Order BY avg_time_in_hospital DESC;

CREATE VIEW readmit_by_treatment_intensity AS
SELECT readmitted_30d, AVG(num_medications) as avg_num_medications, AVG(num_lab_procedures) as avg_num_lab_procedures,
AVG(number_diagnoses) as avg_number_diagnoses
FROM diabetic_data
GROUP BY readmitted_30d;

CREATE VIEW readmit_by_prior_utilization AS
SELECT readmitted_30d, AVG(number_emergency ) as avg_number_emergency , AVG(number_inpatient) as avg_number_inpatient
FROM diabetic_data
GROUP BY readmitted_30d;

CREATE VIEW readmit_by_a1c AS
SELECT A1Cresult,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) AS readmitted_count,
       ROUND(SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS readmit_rate_pct
FROM diabetic_data
GROUP BY A1Cresult
ORDER BY readmit_rate_pct DESC;

CREATE VIEW readmit_by_med_change AS
SELECT `change`,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) AS readmitted_count,
       ROUND(SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS readmit_rate_pct
FROM diabetic_data
GROUP BY `change`
ORDER BY readmit_rate_pct DESC;

CREATE VIEW readmit_by_med_change AS
SELECT insulin,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) AS readmitted_count,
       ROUND(SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS readmit_rate_pct
FROM diabetic_data
GROUP BY insulin
ORDER BY readmit_rate_pct DESC;

CREATE VIEW readmit_by_age AS
SELECT age,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) AS readmitted_count,
       ROUND(SUM(CASE WHEN readmitted_30d = 'Readmitted_30d' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS readmit_rate_pct
FROM diabetic_data
GROUP BY age
ORDER BY age;

SHOW FULL TABLES WHERE table_type = 'VIEW';

GRANT ALL PRIVILEGES ON hospital_diabetes.* TO 'powerbi_user'@'localhost';
FLUSH PRIVILEGES;
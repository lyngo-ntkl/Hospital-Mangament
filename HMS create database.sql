DROP DATABASE IF EXISTS HospitalManagement;
CREATE DATABASE HospitalManagement
GO

USE HospitalManagement
GO

DROP TABLE IF EXISTS Hospital;
CREATE TABLE Hospital(
	hospitalID INT,
	hospitalName NVARCHAR(50),
	hospitalAddress NVARCHAR(200),
	CONSTRAINT PK_HOSPITAL PRIMARY KEY(hospitalID)
)

--DROP TABLE IF EXISTS HospitalContact;
--CREATE TABLE HospitalContact(
--	contactID INT,
	--hospitalID INT,

--)

DROP TABLE IF EXISTS Doctor;
CREATE TABLE Doctor(
	doctorID VARCHAR(10),
	firstName NVARCHAR(50),
	middleName NVARCHAR(50),
	lastName NVARCHAR(50),
	birthDate Date,
	address NVARCHAR(210),
	gender CHAR,
	
	CONSTRAINT PK_DOCTOR PRIMARY KEY(doctorID),
	CONSTRAINT CHK_DOCTOR_GENDER CHECK(GENDER='M' OR GENDER='F'),
	CONSTRAINT CHK_DOCTOR_ID CHECK(doctorID LIKE 'D[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	DepartmentID int,
	DepartmentName nvarchar(120),
	ManagerID varchar(20),
	StartDate Date,
	CONSTRAINT PK_DEPARTMENT PRIMARY KEY(DepartmentID),
	CONSTRAINT UQ_DEPARTMENT UNIQUE(ManagerID)
)

DROP TABLE IF EXISTS Patient;
CREATE TABLE Patient(
	patientID INT,
	firstName NVARCHAR(50),
	middleName NVARCHAR(50),
	lastName NVARCHAR(50),
	nationality VARCHAR(50),
	gender CHAR,
	address NVARCHAR(200),
	birthDate DATE,
	phoneNumber VARCHAR(20),
	CONSTRAINT PK_PATIENT PRIMARY KEY(patientID),
	CONSTRAINT CHK_PATIENT_GENDER CHECK(gender='M' OR gender='F'),
	CONSTRAINT CHK_PATIENT_PHONE CHECK(phoneNumber NOT LIKE '%[^0-9]%')
)
GO

DROP TABLE IF EXISTS MedicalHistory;
CREATE TABLE MedicalHistory
(
	medicalHistoryID INT,
	patientID INT,
	disease VARCHAR(50),
	medication VARCHAR(50),
	allergy VARCHAR(50),
	surgery VARCHAR(50),
	socialHistory VARCHAR(50),
	familyHistory VARCHAR(50)
	CONSTRAINT PK_MEDICALHISTORY PRIMARY KEY(medicalHistoryID),
	CONSTRAINT FK_MEDICALHISTORY FOREIGN KEY(patientID) REFERENCES Patient(patientID),
	CONSTRAINT UNQ_MEDICALHISTORY UNIQUE(patientID)
)
GO

DROP TABLE IF EXISTS Test;
CREATE TABLE Test
(
	testID INT,
	testType VARCHAR(50),
	description VARCHAR(50),
	CONSTRAINT PK_TEST PRIMARY KEY(testID)
)

DROP TABLE IF EXISTS PatientTest;
CREATE TABLE PatientTest
(
	patientTestID INT,
	patientID INT,
	doctorID VARCHAR(10),
	medicalHistoryID INT,
	testID INT,
	testResult VARCHAR(50), 
	dianosis VARCHAR(50),
	CONSTRAINT PK_PATIENTTEST PRIMARY KEY(patientTestID),
	CONSTRAINT FK_PATIENTTEST_PATIENT FOREIGN KEY(patientID) REFERENCES Patient(patientID),
	CONSTRAINT FK_PATIENTTEST_DOCTOR FOREIGN KEY(doctorID) REFERENCES Doctor(doctorID),
	CONSTRAINT FK_PATIENTTEST_MEDICALHISTORY FOREIGN KEY(medicalHistoryID) REFERENCES MedicalHistory(medicalHistoryID),
	CONSTRAINT FK_PATIENTTEST_TEST FOREIGN KEY(testID) REFERENCES Test(testID),
	CONSTRAINT CHK_PATIENTTEST_DOCTOR CHECK(doctorID LIKE 'D[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

DROP TABLE IF EXISTS Medicine;
CREATE TABLE Medicine
(
	medicineID INT,
	medicineName VARCHAR(50),
	medicineType VARCHAR(50),
	medicineCost INT,
	description VARCHAR(200),
	CONSTRAINT PK_MEDICINE PRIMARY KEY(medicineID)
)

DROP TABLE IF EXISTS Treatment ;
CREATE TABLE Treatment 
(
	treatmentID INT,
	patientTestID INT,
	treatmentDescription VARCHAR(200),
	doctorID VARCHAR(10),
	caringID INT,
	surgery VARCHAR(50),
	cost INT,
	CONSTRAINT PK_TREATMENT PRIMARY KEY(treatmentID),
	CONSTRAINT FK_TREATMENT_PATIENT FOREIGN KEY(patientTestID) REFERENCES PatientTest(patientTestID),
	CONSTRAINT FK_TREATMENT_DOCTOR FOREIGN KEY(doctorID) REFERENCES Doctor(doctorID),
	CONSTRAINT FK_TREATMENT_CARING FOREIGN KEY(caringID) REFERENCES Caring(caringID),
	CONSTRAINT CHK_PATIENTTEST_DOCTOR CHECK(doctorID LIKE 'D[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
)

DROP TABLE IF EXISTS Prescription;
CREATE TABLE Prescription 
(
	prescriptionID INT,
	medicalHistoryID INT,
	treatmentID INT,
	description VARCHAR(200),
	totalAmount INT,
	CONSTRAINT PK_PRESCRIPTION PRIMARY KEY(prescriptionID)
)

DROP TABLE IF EXISTS PrescriptionMedicine;
CREATE TABLE PrescriptionMedicine 
(
	prescriptionID INT,
	medicineID INT,
	description VARCHAR(200)
	CONSTRAINT PK_PRESCRIPTIONMEDICINE PRIMARY KEY(prescriptionID, medicineID)
)



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

DROP TABLE IF EXISTS HospitalContact;
CREATE TABLE HospitalContact(
	contactID INT,
	hospitalID INT,

)

DROP TABLE IF EXISTS Doctor;
CREATE TABLE Doctor(
	doctorID VARCHAR(20),
	firstName NVARCHAR(50),
	middleName NVARCHAR(50),
	lastName NVARCHAR(50),
	birthDate Date,
	address NVARCHAR(210),
	gender CHAR,
	
	CONSTRAINT PK_DOCTOR PRIMARY KEY(doctorID),
	CONSTRAINT CHK_DOCTOR_GENDER CHECK(GENDER='M' OR GENDER='F')
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
	CONSTRAINT PK
)

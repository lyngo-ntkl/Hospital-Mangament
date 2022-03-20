
Use master
Go
DROP DATABASE IF EXISTS HospitalManagement;
CREATE DATABASE HospitalManagement
GO

USE HospitalManagement
GO

DROP TABLE IF EXISTS Hospital;
CREATE TABLE Hospital(
	hospitalID      INT,
	hospitalName    NVARCHAR(50),
	Address         NVARCHAR(200),
	CONSTRAINT PK_HOSPITAL PRIMARY KEY(hospitalID)
)
GO

DROP TABLE IF EXISTS Contact;
CREATE TABLE Contact(
	contactID       INT,
	hospitalID      INT,
	phone           INT UNIQUE,
	CONSTRAINT PK_Contact PRIMARY KEY(contactID),
	CONSTRAINT FK_Contact FOREIGN KEY(hospitalID) REFERENCES Hospital(hospitalID),
)
GO

DROP TABLE IF EXISTS Device;
CREATE TABLE Device(
	deviceID      INT,
	hospitalID    INT,
	Name          NVARCHAR(50),
	Type          NVARCHAR(50),
	Quantity      INT,
	Available     INT,
	CONSTRAINT PK_Device PRIMARY KEY(deviceID),
	CONSTRAINT FK_Device FOREIGN KEY(hospitalID) REFERENCES Hospital(hospitalID),
)
go

DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	DepartmentID      INT,
	DepartmentName    NVARCHAR(50),
	ManagerID         VARCHAR(10),
	StartDate         Date,
	CONSTRAINT PK_DEPARTMENT PRIMARY KEY(DepartmentID)
)
go
DROP TABLE IF EXISTS Doctor;
CREATE TABLE Doctor(
	doctorID         VARCHAR(10),
	departmentID     INT,
	bdate            DATE,
	Name             NVARCHAR(50),
	address          NVARCHAR(255),
	gender           CHAR,
	phone            INT,
	CONSTRAINT PK_DOCTOR PRIMARY KEY(doctorID),
	CONSTRAINT FK_DOCTOR FOREIGN KEY(departmentID) REFERENCES DEPARTMENT(departmentID),
	CONSTRAINT CHK_DOCTOR_GENDER CHECK(gender='M' OR gender='F'),
	CONSTRAINT CHK_DOCTOR_ID CHECK(doctorID LIKE 'D%[^0-9]%')
)
go
Alter table Department
add constraint FK_DEPART foreign key(ManagerID) references Doctor(doctorID);
go

DROP TABLE IF EXISTS Room;
CREATE TABLE Room(
	roomID         INT,
	ManagerID      VARCHAR(10),
	DepartmentID   INT,
	rtype          NVARCHAR(50),
	Status         NVARCHAR(50),
	room_cost      INT
	CONSTRAINT PK_ROOM PRIMARY KEY(roomID),
	CONSTRAINT FK_ROOM FOREIGN KEY(DepartmentID) references Department(DepartmentID)
)
GO
DROP TABLE IF EXISTS Nurse;
CREATE TABLE Nurse(
	nurseID          VARCHAR(10),
	roomID           INT,
	bdate            DATE,
	Name             NVARCHAR(50),
	address          NVARCHAR(255),
	gender           CHAR,
	phone            INT,
	CONSTRAINT PK_NURSE PRIMARY KEY(nurseID),
	CONSTRAINT FK_NURSE FOREIGN KEY(roomID) REFERENCES Room(roomID),
	CONSTRAINT CHK_NURSE_GENDER CHECK(gender='M' OR gender='F'),
	CONSTRAINT CHK_NURSE_ID CHECK(nurseID LIKE 'N%[^0-9]%')
)
GO

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
	CONSTRAINT CHK_PATIENT_PHONE CHECK(phoneNumber LIKE '%[^0-9]%')
)
GO

go
ALTER TABLE Room
ADD CONSTRAINT FK_Room foreign key(ManagerID) references Nurse(nurseID);
go


DROP TABLE IF EXISTS Appointment;
CREATE TABLE Appointment(
	AppointmentID     INT,
	patientID         INT,
	doctorID          VARCHAR(10),
	number            INT,
	type              NVARCHAR(50),
	date              DateTime,
	description       NVARCHAR(255),
	CONSTRAINT PK_Appointment PRIMARY KEY(AppointmentID),
	CONSTRAINT FK_Appointment_01 FOREIGN KEY(patientID) REFERENCES Patient(patientID),
	CONSTRAINT FK_Appointment_02 FOREIGN KEY(doctorID) REFERENCES Doctor(doctorID)
);

GO

DROP TABLE IF EXISTS Insurance;
CREATE TABLE Insurance(
	insuranceID     INT,
	patientID       INT,
	policy_no       NVARCHAR(50),
	publish_date    DATE,
	expire_date     DATE,
	CONSTRAINT PK_Insurance PRIMARY KEY(insuranceID),
	CONSTRAINT FK_Insurance FOREIGN KEY(patientID) REFERENCES Patient(patientID),
	CONSTRAINT CY_Insurance CHECK(YEAR(publish_date)<= YEAR(GETDATE()))
);

GO
DROP TABLE IF EXISTS DiscountFee;
CREATE TABLE DiscountFee(
	discountID   INT,
	insuranceID  INT,
	discount     INT,
	CONSTRAINT PK_Discount PRIMARY KEY(discountID),
	CONSTRAINT FK_Discount FOREIGN KEY(insuranceID) REFERENCES Insurance(insuranceID)
);

GO

DROP TABLE IF EXISTS Caring;
CREATE TABLE Caring(
	caringID      INT,
	nurseID       VARCHAR(10),
	roomID        INT,
	number_of_day INT,
	caring_cost   INT,
	CONSTRAINT PK_CARING PRIMARY KEY(caringID),
	CONSTRAINT FK_CARING_01 FOREIGN KEY(nurseID) REFERENCES Nurse(nurseID),
	CONSTRAINT FK_CARING_02 FOREIGN KEY(roomID) REFERENCES Room(roomID)
);

Go

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

GO

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
GO

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

Go
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
GO
DROP TABLE IF EXISTS Prescription;
CREATE TABLE Prescription 
(
	prescriptionID INT,
	medicalHistoryID INT,
	treatmentID INT,
	description VARCHAR(200),
	totalAmount INT,
	CONSTRAINT PK_PRESCRIPTION PRIMARY KEY(prescriptionID),
	CONSTRAINT FK_PRESCRIPTION_MEDICALHISTORY FOREIGN KEY(medicalHistoryID) REFERENCES MedicalHistory(medicalHistoryID),
	CONSTRAINT FK_PRESCRIPTION_TREATMENT FOREIGN KEY(treatmentID) REFERENCES Treatment(treatmentID)
)

GO

DROP TABLE IF EXISTS PrescriptionMedicine;
CREATE TABLE PrescriptionMedicine 
(
	prescriptionID INT,
	medicineID INT,
	description VARCHAR(200)
	CONSTRAINT PK_PRESCRIPTIONMEDICINE PRIMARY KEY(prescriptionID, medicineID),
	CONSTRAINT FK_PRESCRIPTIONMEDICINE_PRESCRIPTION FOREIGN KEY(prescriptionID) REFERENCES Prescription(prescriptionID),
	CONSTRAINT FK_PRESCRIPTIONMEDICINE_MEDICINE FOREIGN KEY(medicineID) REFERENCES Medicine(medicineID)
)



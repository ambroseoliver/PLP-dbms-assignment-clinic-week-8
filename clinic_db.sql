-- ============================================================
-- Clinic Management Database (MySQL)
-- Question 1: Complete Database Management System
-- ============================================================

-- Create database
CREATE DATABASE IF NOT EXISTS clinic_mgmt
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE clinic_mgmt;

-- Make sure we're using InnoDB for FK support
SET default_storage_engine=INNODB;

-- ------------------------------------------------------------
-- Table: patients
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(100) NOT NULL,
  email      VARCHAR(255) NOT NULL UNIQUE,
  phone      VARCHAR(30)  NOT NULL UNIQUE,
  gender     ENUM('male','female','other') NOT NULL,
  date_of_birth DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: specialties
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS specialties (
  specialty_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: doctors
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS doctors (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(100) NOT NULL,
  email      VARCHAR(255) NOT NULL UNIQUE,
  phone      VARCHAR(30)  NOT NULL UNIQUE,
  gender     ENUM('male','female','other') NOT NULL,
  date_hired DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: doctor_specialties (M:N between doctors and specialties)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS doctor_specialties (
  doctor_id    INT NOT NULL,
  specialty_id INT NOT NULL,
  PRIMARY KEY (doctor_id, specialty_id),
  CONSTRAINT fk_ds_doctor
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ds_specialty
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: rooms (optional resource tracking)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rooms (
  room_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: appointments
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  doctor_id  INT NOT NULL,
  room_id    INT NULL,
  scheduled_at DATETIME NOT NULL,
  status ENUM('scheduled','completed','cancelled','no_show') NOT NULL DEFAULT 'scheduled',
  reason VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_appt_patient
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_appt_doctor
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_appt_room
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX idx_appt_patient (patient_id),
  INDEX idx_appt_doctor (doctor_id),
  INDEX idx_appt_scheduled (scheduled_at)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: medications
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS medications (
  medication_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE,
  description TEXT NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: prescriptions
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS prescriptions (
  prescription_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes VARCHAR(500) NULL,
  CONSTRAINT fk_rx_appt
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rx_patient
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rx_doctor
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_rx_appt (appointment_id),
  INDEX idx_rx_patient (patient_id),
  INDEX idx_rx_doctor (doctor_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: prescription_items (M:N prescriptions <-> medications)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS prescription_items (
  prescription_id INT NOT NULL,
  medication_id INT NOT NULL,
  dosage VARCHAR(100) NOT NULL,
  frequency VARCHAR(100) NOT NULL,
  duration_days INT NOT NULL CHECK (duration_days > 0),
  PRIMARY KEY (prescription_id, medication_id),
  CONSTRAINT fk_rxi_rx
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rxi_med
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table: payments (1:1 with appointment)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL UNIQUE,
  amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  method ENUM('cash','card','mpesa') NOT NULL,
  status ENUM('pending','paid','failed') NOT NULL DEFAULT 'pending',
  paid_at DATETIME NULL,
  CONSTRAINT fk_pay_appt
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Optional sample seed data (commented out)
-- ------------------------------------------------------------
-- INSERT INTO specialties (name) VALUES ('General Practice'), ('Pediatrics'), ('Dermatology');
-- INSERT INTO rooms (name) VALUES ('Room A'), ('Room B');
-- INSERT INTO doctors (first_name, last_name, email, phone, gender, date_hired)
-- VALUES ('Alice','Karimi','alice.karimi@clinic.test','0712345678','female','2020-01-10'),
--        ('Brian','Otieno','brian.otieno@clinic.test','0723456789','male','2019-09-05');
-- INSERT INTO patients (first_name, last_name, email, phone, gender, date_of_birth)
-- VALUES ('John','Doe','john.doe@test.com','0700000001','male','1990-06-15'),
--        ('Jane','Smith','jane.smith@test.com','0700000002','female','1988-02-20');
-- INSERT INTO doctor_specialties (doctor_id, specialty_id) VALUES (1,1),(2,2);
-- INSERT INTO appointments (patient_id, doctor_id, room_id, scheduled_at, status, reason)
-- VALUES (1,1,1,'2025-09-05 10:00:00','scheduled','Routine check-up');
-- INSERT INTO medications (name, description) VALUES ('Amoxicillin','Antibiotic'),('Ibuprofen','Pain reliever');
-- INSERT INTO prescriptions (appointment_id, patient_id, doctor_id, notes) VALUES (1,1,1,'Take with food');
-- INSERT INTO prescription_items (prescription_id, medication_id, dosage, frequency, duration_days)
-- VALUES (1,1,'500mg','3x daily',7);

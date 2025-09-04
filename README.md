# 🏥 Clinic Management System  

A **full-featured relational database** and **CRUD API** for managing patients, doctors, and appointments in a clinic.  

This project was built as part of a **Database Design and Normalization Assignment**, demonstrating skills in **MySQL schema design**, **normalization (1NF, 2NF, 3NF)**, and **API development with FastAPI**.  

---

## 📚 Features
- ✅ **Normalized Database Design** (1NF → 3NF)  
- ✅ **Well-structured Tables** with constraints (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK`)  
- ✅ **Relationships**: One-to-One, One-to-Many, and Many-to-Many  
- ✅ **CRUD Operations** for Patients and Appointments via FastAPI  
- ✅ **Interactive API Docs** powered by Swagger (FastAPI)  

---

## 📂 Project Structure

clinic-management-system/
│── 📄 clinic_db.sql # Database schema (MySQL)
│── 📂 crud_app/ # FastAPI CRUD project
│ ├── 📄 main.py # FastAPI entrypoint
│ ├── 📄 database.py # SQLAlchemy engine/session
│ ├── 📄 models.py # ORM models
│ ├── 📄 schemas.py # Pydantic schemas
│ ├── 📄 .env.example # Example DB connection settings
│ └── 📄 README.md # CRUD app usage
│── 📄 README.md # Main repo documentation




---

## 🔗 API Endpoints

### Patients
- `POST /patients/` → Create a new patient  
- `GET /patients/` → Retrieve all patients  
- `GET /patients/{id}` → Retrieve a single patient by ID  
- `PUT /patients/{id}` → Update patient details  
- `DELETE /patients/{id}` → Delete a patient  

### 📅 Appointments

- `POST /appointments` → Schedule a new appointment  
- `GET /appointments` → Retrieve all appointments  
- `GET /appointments/{id}` → Retrieve single appointment  
- `PUT /appointments/{id}` → Update appointment details  
- `DELETE /appointments/{id}` → Cancel an appointment  



## ⚙️ Setup Instructions  

### 1️⃣ Database (MySQL)
```bash
# Log into MySQL and create the database
mysql -u your_user -p < clinic_db.sql

# Navigate into the CRUD app folder
cd crud_app

# Create a virtual environment
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt


---

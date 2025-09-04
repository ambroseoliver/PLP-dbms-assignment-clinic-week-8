# Clinic CRUD API (FastAPI + SQLAlchemy + MySQL)

This is a minimal CRUD example for **Patients** and **Appointments**, connected to the MySQL schema from Question 1.

## Prerequisites
- Python 3.10+
- MySQL 8+ (database from `clinic_db.sql` already created and migrated)

## Setup
```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install fastapi uvicorn sqlalchemy pymysql python-dotenv
```

Create a `.env` file in the project root with your DB URL:
```
DATABASE_URL=mysql+pymysql://username:password@localhost:3306/clinic_mgmt
```

## Run
```bash
uvicorn main:app --reload
```

## Endpoints (core examples)
- `POST /patients` — create patient
- `GET /patients` — list patients
- `GET /patients/{patient_id}` — get one
- `PUT /patients/{patient_id}` — update
- `DELETE /patients/{patient_id}` — delete

- `POST /appointments` — create appointment
- `GET /appointments` — list appointments
- `GET /appointments/{appointment_id}` — get one
- `PUT /appointments/{appointment_id}` — update
- `DELETE /appointments/{appointment_id}` — delete

Visit `http://127.0.0.1:8000/docs` for interactive Swagger UI.

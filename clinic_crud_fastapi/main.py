from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from database import Base, engine, get_db
from models import Patient, Appointment, ApptStatusEnum
from schemas import PatientCreate, PatientUpdate, PatientOut, AppointmentCreate, AppointmentUpdate, AppointmentOut

app = FastAPI(title="Clinic CRUD API", version="1.0.0")

# Create tables if not present (only for demo; in prod use migrations)
Base.metadata.create_all(bind=engine)

# ---------------- Patients ----------------
@app.post("/patients", response_model=PatientOut, status_code=status.HTTP_201_CREATED)
def create_patient(payload: PatientCreate, db: Session = Depends(get_db)):
    # Unique checks (email/phone)
    if db.query(Patient).filter(Patient.email == payload.email).first():
        raise HTTPException(status_code=400, detail="Email already in use")
    if db.query(Patient).filter(Patient.phone == payload.phone).first():
        raise HTTPException(status_code=400, detail="Phone already in use")
    obj = Patient(**payload.model_dict())
    db.add(obj)
    db.commit()
    db.refresh(obj)
    return obj

@app.get("/patients", response_model=List[PatientOut])
def list_patients(db: Session = Depends(get_db)):
    return db.query(Patient).order_by(Patient.patient_id).all()

@app.get("/patients/{patient_id}", response_model=PatientOut)
def get_patient(patient_id: int, db: Session = Depends(get_db)):
    obj = db.get(Patient, patient_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Patient not found")
    return obj

@app.put("/patients/{patient_id}", response_model=PatientOut)
def update_patient(patient_id: int, payload: PatientUpdate, db: Session = Depends(get_db)):
    obj = db.get(Patient, patient_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Patient not found")
    data = payload.model_dump(exclude_unset=True)
    # Handle potential unique updates
    if "email" in data and db.query(Patient).filter(Patient.email == data["email"], Patient.patient_id != patient_id).first():
        raise HTTPException(status_code=400, detail="Email already in use")
    if "phone" in data and db.query(Patient).filter(Patient.phone == data["phone"], Patient.patient_id != patient_id).first():
        raise HTTPException(status_code=400, detail="Phone already in use")
    for k, v in data.items():
        setattr(obj, k, v)
    db.commit()
    db.refresh(obj)
    return obj

@app.delete("/patients/{patient_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_patient(patient_id: int, db: Session = Depends(get_db)):
    obj = db.get(Patient, patient_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Patient not found")
    db.delete(obj)
    db.commit()
    return None

# ---------------- Appointments ----------------
@app.post("/appointments", response_model=AppointmentOut, status_code=status.HTTP_201_CREATED)
def create_appointment(payload: AppointmentCreate, db: Session = Depends(get_db)):
    # Ensure patient exists (FK enforced in DB, but we do a friendly check)
    patient = db.get(Patient, payload.patient_id)
    if not patient:
        raise HTTPException(status_code=400, detail="Patient does not exist")
    obj = Appointment(**payload.model_dump())
    db.add(obj)
    db.commit()
    db.refresh(obj)
    return obj

@app.get("/appointments", response_model=List[AppointmentOut])
def list_appointments(db: Session = Depends(get_db)):
    return db.query(Appointment).order_by(Appointment.scheduled_at.desc()).all()

@app.get("/appointments/{appointment_id}", response_model=AppointmentOut)
def get_appointment(appointment_id: int, db: Session = Depends(get_db)):
    obj = db.get(Appointment, appointment_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return obj

@app.put("/appointments/{appointment_id}", response_model=AppointmentOut)
def update_appointment(appointment_id: int, payload: AppointmentUpdate, db: Session = Depends(get_db)):
    obj = db.get(Appointment, appointment_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Appointment not found")
    data = payload.model_dump(exclude_unset=True)
    if "patient_id" in data:
        if not db.get(Patient, data["patient_id"]):
            raise HTTPException(status_code=400, detail="Patient does not exist")
    for k, v in data.items():
        setattr(obj, k, v)
    db.commit()
    db.refresh(obj)
    return obj

@app.delete("/appointments/{appointment_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_appointment(appointment_id: int, db: Session = Depends(get_db)):
    obj = db.get(Appointment, appointment_id)
    if not obj:
        raise HTTPException(status_code=404, detail="Appointment not found")
    db.delete(obj)
    db.commit()
    return None

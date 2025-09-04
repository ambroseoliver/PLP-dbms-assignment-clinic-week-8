from pydantic import BaseModel, EmailStr, constr
from datetime import date, datetime
from typing import Optional
from enum import Enum

class GenderEnum(str, Enum):
    male = "male"
    female = "female"
    other = "other"

class ApptStatusEnum(str, Enum):
    scheduled = "scheduled"
    completed = "completed"
    cancelled = "cancelled"
    no_show = "no_show"

# Patient Schemas
class PatientBase(BaseModel):
    first_name: constr(strip_whitespace=True, min_length=1, max_length=100)
    last_name: constr(strip_whitespace=True, min_length=1, max_length=100)
    email: EmailStr
    phone: constr(strip_whitespace=True, min_length=3, max_length=30)
    gender: GenderEnum
    date_of_birth: date

class PatientCreate(PatientBase):
    pass

class PatientUpdate(BaseModel):
    first_name: Optional[constr(strip_whitespace=True, min_length=1, max_length=100)] = None
    last_name: Optional[constr(strip_whitespace=True, min_length=1, max_length=100)] = None
    email: Optional[EmailStr] = None
    phone: Optional[constr(strip_whitespace=True, min_length=3, max_length=30)] = None
    gender: Optional[GenderEnum] = None
    date_of_birth: Optional[date] = None

class PatientOut(PatientBase):
    patient_id: int
    class Config:
        from_attributes = True

# Appointment Schemas
class AppointmentBase(BaseModel):
    patient_id: int
    doctor_id: int
    scheduled_at: datetime
    status: ApptStatusEnum = ApptStatusEnum.scheduled
    reason: Optional[str] = None

class AppointmentCreate(AppointmentBase):
    pass

class AppointmentUpdate(BaseModel):
    patient_id: Optional[int] = None
    doctor_id: Optional[int] = None
    scheduled_at: Optional[datetime] = None
    status: Optional[ApptStatusEnum] = None
    reason: Optional[str] = None

class AppointmentOut(AppointmentBase):
    appointment_id: int
    class Config:
        from_attributes = True

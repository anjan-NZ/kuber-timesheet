"""
Nepali Date Conversion Microservice
FastAPI service for converting between English and Nepali (Bikram Sambat) calendars
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime, timezone, timedelta
import nepali_datetime

import logging
import os
from dotenv import load_dotenv

load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Nepali Date Conversion Service",
    description="API for converting between English (Gregorian) and Nepali (Bikram Sambat) calendars",
    version="0.1.0"
)

# CORS configuration
allowed_origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:3000").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request/Response Models
class EnglishDateRequest(BaseModel):
    year: int
    month: int
    day: int

class NepaliDateRequest(BaseModel):
    year: int
    month: int
    day: int

class DateResponse(BaseModel):
    english_date: dict
    nepali_date: dict
    iso_string: str

# Routes
@app.get("/")
async def root():
    """Health check endpoint"""
    return {"status": "healthy", "service": "nepali-date-converter", "version": "0.1.0"}

@app.get("/health")
async def health():
    """Health check"""
    return {"status": "ok"}

@app.post("/convert/english-to-nepali")
async def convert_english_to_nepali(request: EnglishDateRequest):
    """
    Convert English (Gregorian) date to Nepali (Bikram Sambat) calendar
    
    Request:
        - year: int (e.g., 2026)
        - month: int (1-12)
        - day: int (1-31)
    
    Response:
        - english_date: original English date
        - nepali_date: converted Nepali date (Bikram Sambat)
        - iso_string: ISO format string
    """
    try:
        # Validate input
        if not (1 <= request.month <= 12):
            raise ValueError("Month must be between 1 and 12")
        if not (1 <= request.day <= 31):
            raise ValueError("Day must be between 1 and 31")
        
        # Create date object
        english_date = datetime(request.year, request.month, request.day)
        
        # Convert to Nepali using nepali_datetime
        nepali_date = nepali_datetime.datetime.from_datetime_datetime(english_date).date()
        
        return {
            "english_date": {
                "year": request.year,
                "month": request.month,
                "day": request.day,
                "formatted": english_date.strftime("%Y-%m-%d")
            },
            "nepali_date": {
                "year": nepali_date.year,
                "month": nepali_date.month,
                "day": nepali_date.day,
                "formatted": f"{nepali_date.year}-{nepali_date.month:02d}-{nepali_date.day:02d}"
            },
            "iso_string": english_date.isoformat()
        }
    except ValueError as e:
        logger.warning(f"Invalid input: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.error(f"Conversion error: {str(e)}")
        raise HTTPException(status_code=500, detail="Conversion failed")

@app.post("/convert/nepali-to-english")
async def convert_nepali_to_english(request: NepaliDateRequest):
    """
    Convert Nepali (Bikram Sambat) date to English (Gregorian) calendar
    
    Request:
        - year: int (Bikram Sambat year, e.g., 2082)
        - month: int (1-12)
        - day: int (1-32)
    
    Response:
        - english_date: converted English date (Gregorian)
        - nepali_date: original Nepali date
        - iso_string: ISO format string
    """
    try:
        # Validate input
        if not (1 <= request.month <= 12):
            raise ValueError("Month must be between 1 and 12")
        if not (1 <= request.day <= 32):
            raise ValueError("Day must be between 1 and 32")
        
        # Create Nepali date and convert to English (Gregorian)
        nepali_date = nepali_datetime.date(request.year, request.month, request.day)
        english_date = nepali_date.to_gregorian_datetime().date()
        
        return {
            "nepali_date": {
                "year": request.year,
                "month": request.month,
                "day": request.day,
                "formatted": f"{request.year}-{request.month:02d}-{request.day:02d}"
            },
            "english_date": {
                "year": english_date.year,
                "month": english_date.month,
                "day": english_date.day,
                "formatted": english_date.strftime("%Y-%m-%d")
            },
            "iso_string": english_date.isoformat()
        }
    except ValueError as e:
        logger.warning(f"Invalid input: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.error(f"Conversion error: {str(e)}")
        raise HTTPException(status_code=500, detail="Conversion failed")

@app.get("/date/current")
async def get_current_date():
    """
    Get current date in both English and Nepali calendars (NPT timezone)
    
    Nepal Time (NPT) is UTC+5:45
    
    Response:
        - english_date: current date in Gregorian calendar
        - nepali_date: current date in Bikram Sambat calendar
        - timezone: NPT (UTC+5:45)
    """
    try:
        # NPT timezone: UTC+5:45
        npt_offset = timezone(timedelta(hours=5, minutes=45))
        now_npt = datetime.now(npt_offset)
        
        # Get English date
        english_date = datetime(now_npt.year, now_npt.month, now_npt.day)
        
        # Convert to Nepali
        nepali_date_obj = nepali_datetime.datetime.from_datetime_datetime(english_date)
        nepali_date = nepali_date_obj.date()
        
        return {
            "english_date": {
                "year": now_npt.year,
                "month": now_npt.month,
                "day": now_npt.day,
                "formatted": now_npt.strftime("%Y-%m-%d"),
                "timestamp": now_npt.isoformat()
            },
            "nepali_date": {
                "year": nepali_date.year,
                "month": nepali_date.month,
                "day": nepali_date.day,
                "formatted": f"{nepali_date.year}-{nepali_date.month:02d}-{nepali_date.day:02d}"
            },
            "timezone": "NPT (UTC+5:45)"
        }
    except Exception as e:
        logger.error(f"Error getting current date: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to get current date")

@app.post("/validate/nepali-date")
async def validate_nepali_date(request: NepaliDateRequest):
    """
    Validate if a Nepali date is valid
    
    Request:
        - year: int (Bikram Sambat year)
        - month: int (1-12)
        - day: int (1-32)
    
    Response:
        - valid: bool
        - message: str
    """
    try:
        # Basic validation
        if not (1800 <= request.year <= 2100):
            return {"valid": False, "message": "Year must be between 1800 and 2100"}
        if not (1 <= request.month <= 12):
            return {"valid": False, "message": "Month must be between 1 and 12"}
        if not (1 <= request.day <= 32):
            return {"valid": False, "message": "Day must be between 1 and 32"}
        
        # Try to convert to validate
        try:
            nepali_date = nepali_datetime.date(request.year, request.month, request.day)
            english_date = nepali_date.to_gregorian_datetime().date()
            return {"valid": True, "message": "Valid Nepali date", "english_equivalent": english_date.isoformat()}
        except:
            return {"valid": False, "message": "Invalid Nepali date"}
    except Exception as e:
        logger.error(f"Validation error: {str(e)}")
        raise HTTPException(status_code=500, detail="Validation failed")

if __name__ == "__main__":
    import uvicorn
    
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)

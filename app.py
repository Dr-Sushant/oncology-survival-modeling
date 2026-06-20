import pickle
import pandas as pd

from fastapi import FastAPI
from pydantic import BaseModel


# ----------------------------
# Load trained Cox model
# ----------------------------
MODEL_PATH = "03_models/cox/model.pkl"

with open(MODEL_PATH, "rb") as f:
    model = pickle.load(f)


# ----------------------------
# FastAPI app
# ----------------------------
app = FastAPI(
    title="Oncology Survival Inference API",
    description="Clinical survival risk prediction using Cox PH",
    version="1.0"
)


# ----------------------------
# Input schema
# ----------------------------
class PatientData(BaseModel):
    AGE: float
    HER2: int
    HR: int

    LYMPH_NODES: int
    TUMOR_SIZE: float
    
    grade_clean: int

    chemo: int
    radiation: int
    surgery: int

    TUMSTAGE_Localized: int
    TUMSTAGE_Regional: int


# ----------------------------
# Prediction endpoint
# ----------------------------
@app.post("/predict")
def predict(data: PatientData):

    # Convert input to dataframe
    df = pd.DataFrame([data.dict()])
    df["USUBJID"] = 0
    
    # Predict risk
    risk_score = model.predict_partial_hazard(df)

    return {
        "risk_score": float(risk_score.iloc[0])
    }
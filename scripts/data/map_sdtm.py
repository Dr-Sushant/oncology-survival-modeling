import pandas as pd
import os

INPUT_DATA = "data/raw/seer_clean.csv"
OUTPUT_PATH = "data/sdtm_like/sdtm.csv"

def run():
    df = pd.read_csv(INPUT_DATA)

    print("Columns in dataset:")
    print(df.columns.tolist())

    # ---- YOUR DATA MAPPING ----
    df = df.rename(columns={
        "age": "AGE",
        "stage_clean": "TUMSTAGE",
        "time": "AVAL",
        "event": "EVENT"
    })

    # ---- CREATE ID ----
    df["USUBJID"] = range(1, len(df) + 1)

    # ---- CDISC CENSORING ----
    df["CNSR"] = df["EVENT"].apply(lambda x: 0 if x == 1 else 1)

    # ---- CHECK ----
    required = ["USUBJID", "AGE", "TUMSTAGE", "AVAL", "CNSR"]
    missing = [col for col in required if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns after mapping: {missing}")

    os.makedirs("data/sdtm_like", exist_ok=True)
    df.to_csv(OUTPUT_PATH, index=False)

    print("SDTM-like dataset created at:", OUTPUT_PATH)
    print(df.head())

if __name__ == "__main__":
    run()
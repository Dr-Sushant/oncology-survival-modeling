import pandas as pd
import os

INPUT_PATH = "data/sdtm_like/sdtm.csv"

def run():
    assert os.path.exists(INPUT_PATH), "SDTM file not found. Run Step 1 first."

    df = pd.read_csv(INPUT_PATH)

    # ---- ADSL (subject-level) ----
    adsl_cols = ["USUBJID", "AGE", "TUMSTAGE"]
    
    # include treatment variables (strong signal)
    optional_cols = ["chemo", "radiation", "surgery", "grade_clean"]
    for col in optional_cols:
        if col in df.columns:
            adsl_cols.append(col)

    adsl = df[adsl_cols].drop_duplicates()

    # ---- ADTTE (time-to-event) ----
    adtte = df[["USUBJID", "AVAL", "CNSR"]]

    # ---- SAVE ----
    os.makedirs("data/adam", exist_ok=True)

    adsl.to_csv("data/adam/ADSL.csv", index=False)
    adtte.to_csv("data/adam/ADTTE.csv", index=False)

    print("ADSL and ADTTE created.")
    print("\nADSL preview:")
    print(adsl.head())

    print("\nADTTE preview:")
    print(adtte.head())

if __name__ == "__main__":
    run()
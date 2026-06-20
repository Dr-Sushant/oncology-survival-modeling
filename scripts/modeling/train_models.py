import os
import json
import pickle
import pandas as pd

from lifelines import CoxPHFitter
from lifelines.utils import concordance_index

from sksurv.ensemble import RandomSurvivalForest
from sksurv.util import Surv
from sksurv.metrics import concordance_index_censored
from sklearn.model_selection import train_test_split

# ----------------------------
# Utility: Save model artifacts
# ----------------------------
def save_model(model, model_name, metrics=None, config=None):
    base_path = f"03_models/{model_name}"
    os.makedirs(base_path, exist_ok=True)

    with open(os.path.join(base_path, "model.pkl"), "wb") as f:
        pickle.dump(model, f)

    if metrics:
        with open(os.path.join(base_path, "metrics.json"), "w") as f:
            json.dump(metrics, f, indent=4)

    if config:
        with open(os.path.join(base_path, "config.json"), "w") as f:
            json.dump(config, f, indent=4)


# ----------------------------
# Load dataset
# ----------------------------
def load_data():
    path = "01_data/sdtm/sdtm.csv"
    df = pd.read_csv(path)

    df = df.dropna()
    df = df.drop(columns=["CNSR"], errors="ignore")
    df = pd.get_dummies(df, columns=["TUMSTAGE"], drop_first=True)

    return df

# ----------------------------
# Train-Test Split
# ----------------------------
def split_data(df, test_size=0.2, random_state=42):

    train_df, test_df = train_test_split(
        df,
        test_size=test_size,
        random_state=random_state,
        stratify=df["EVENT"]
    )

    return train_df, test_df

# ----------------------------
# Train Cox PH
# ----------------------------
def train_cox(df):
    cph = CoxPHFitter()
    cph.fit(df, duration_col="AVAL", event_col="EVENT")
    return cph


# ----------------------------
# Evaluate Cox
# ----------------------------
def evaluate_cox(model, df):
    risk_scores = model.predict_partial_hazard(df)
    c_index = concordance_index(
        df["AVAL"],
        -risk_scores,
        df["EVENT"]
    )
    return {"c_index": float(c_index)}


# ----------------------------
# Train RSF
# ----------------------------
def train_rsf(df):
    y = Surv.from_dataframe("EVENT", "AVAL", df)
    X = df.drop(columns=["EVENT", "AVAL"])

    rsf = RandomSurvivalForest(
        n_estimators=100,
        min_samples_split=10,
        min_samples_leaf=5,
        random_state=42,
        n_jobs=-1,
    )

    rsf.fit(X, y)
    return rsf


# ----------------------------
# Evaluate RSF
# ----------------------------
def evaluate_rsf(model, df):
    y = Surv.from_dataframe("EVENT", "AVAL", df)
    X = df.drop(columns=["EVENT", "AVAL"])

    risk_scores = model.predict(X)

    c_index = concordance_index_censored(
        y["EVENT"],
        y["AVAL"],
        risk_scores
    )[0]

    return {"c_index": float(c_index)}


# ----------------------------
# Main run function
# ----------------------------
def run(config=None):
    print("Loading data...")
    df = load_data()

    print("Splitting train/test data...")
    train_df, test_df = split_data(df)

    print(f"Train samples: {len(train_df)}")
    print(f"Test samples: {len(test_df)}")

    model_type = "both"
    if config and "model" in config:
        model_type = config["model"].get("type", "both")

    print(f"Model type selected: {model_type}")

    # ---- Cox ----
    if model_type in ["cox", "both"]:
        print("Training Cox PH model...")
        cox_model = train_cox(train_df)

        print("Evaluating Cox model on test data...")
        cox_metrics = evaluate_cox(cox_model, test_df)

        print(f"Cox C-index: {cox_metrics['c_index']:.4f}")

        save_model(
            cox_model,
            "cox",
            metrics=cox_metrics,
            config={"model_type": "CoxPH"}
        )

        print("Model saved to: 03_models/cox/")
        print("Metrics saved to: 03_models/cox/metrics.json")

    # ---- RSF ----
    if model_type in ["rsf", "both"]:
        print("Training RSF model...")
        rsf_model = train_rsf(train_df)

        print("Evaluating RSF model on test data...")
        rsf_metrics = evaluate_rsf(rsf_model, test_df)

        print(f"RSF C-index: {rsf_metrics['c_index']:.4f}")

        save_model(
            rsf_model,
            "rsf",
            metrics=rsf_metrics,
            config={"model_type": "RSF"}
        )

        print("Model saved to: 03_models/rsf/")
        print("Metrics saved to: 03_models/rsf/metrics.json")

    print("Done.")


# ----------------------------
# Entry point
# ----------------------------
if __name__ == "__main__":
    run()
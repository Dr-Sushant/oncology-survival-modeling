import argparse
import yaml

from scripts.modeling import train_models


def load_config(path):
    with open(path, "r") as f:
        return yaml.safe_load(f)


def main(config_path):
    config = load_config(config_path)

    print(f"Running pipeline with config: {config_path}")

    train_models.run(config=config)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", required=True)

    args = parser.parse_args()

    main(args.config)
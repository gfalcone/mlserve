#!/usr/bin/env bash

sqlite3 /app/database.db "VACUUM;"
mlflow server --backend-store-uri sqlite:///database.db --default-artifact-root file:///app/ --host 0.0.0.0 &
sleep 2
export MLFLOW_TRACKING_URI=http://localhost:5000
mlflow experiments create -n test_sklearn
python -m examples.training.sklearn
mlflow experiments create -n test_pytorch
python -m examples.training.pytorch
mlflow experiments create -n test_keras
python -m examples.training.keras
mlflow experiments create -n test_xgboost
python -m examples.training.xgboost
mlflow experiments create -n test_tensorflow
python -m examples.training.tensorflow
mlflow experiments create -n test_prophet
python -m examples.training.prophet
# python -m unittest tests.examples.serving.test_keras
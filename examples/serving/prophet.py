from mlserve.loader import load_mlflow_model
from mlserve.predictions import GenericPrediction
from mlserve.api import ApiBuilder
from pydantic import BaseModel

# load model
model = load_mlflow_model(
    # MlFlow model path
    'models:/prophet_model/1',
    # MlFlow Tracking URI
    'http://localhost:5000',
)


# Implement deserializer for input data
class PeriodPrediction(BaseModel):
    periods: int


# implement application
app = ApiBuilder(GenericPrediction(model), PeriodPrediction).build_api()
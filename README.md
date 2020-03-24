# mlserve

`mlserve` is a Python library that helps you package your Machine Learning model easily into a REST API.

The idea behind `mlserve` is to define a set of generic endpoints to make predictions easily !

## Requirements

- Python 3.6+
- [FastAPI](https://fastapi.tiangolo.com/) (for the API part)
- [MLflow](https://mlflow.org/) (for model loading)
- [Uvicorn](https://www.uvicorn.org/) (to run api)

## Documentation

You can find the full documentation here : https://gfalcone.github.io/mlserve/

## How to use ? 

### Prerequisites 

In order to run the examples we put, you'll need an MLflow server running. 

As we do not expect you to have already this in place, we set up a Dockerfile in order to speed things up.

You'll need to do the following things to set up this container and run commands into it : 

```bash
git clone https://github.com/gfalcone/mlserve
cd mlserve
docker build --tag=mlserve .
docker run -ti -p 8000:8000 mlserve bash
```

When building the container, it will train all the examples we have put in this repository

### Instructions

First of all, you need to have a model already trained and registered in MlFlow

Luckily for you, we already have a set of examples trained in our Docker container that you can already use.

Let's say you have a scikit-learn model already trained and registered in MLflow

We can then define the API this way (taken from examples/serving/sklearn.py): 

```python
from mlserve.api import ApiBuilder
from mlserve.inputs import BasicInput
from mlserve.loader import load_mlflow_model
from mlserve.predictions import GenericPrediction

# load model
model = load_mlflow_model(
    # MlFlow model path
    'models:/sklearn_model/1',
    # MlFlow Tracking URI (optional)
    'http://localhost:5000',
)


# Implement deserializer for input data
class WineComposition(BasicInput):
    alcohol: float
    chlorides: float
    citric_acid: float
    density: float
    fixed_acidity: float
    free_sulfur_dioxide: int
    pH: float
    residual_sugar: float
    sulphates: float
    total_sulfur_dioxide: int
    volatile_acidity: int


# implement application
app = ApiBuilder(GenericPrediction(model), WineComposition).build_api()
```

You can then run it with : 

```bash
uvicorn examples.serving.sklearn:app --host 0.0.0.0
```

You can now access your API's documentation, generated by [redoc](https://github.com/Redocly/redoc) on [localhost:8000/redoc]() or  access your API with Swagger on [localhost:8000/docs]() :

![API](https://github.com/gfalcone/mlserve/blob/master/docs/images/mlserve-example.gif)

Don't forget to exit the Docker container :) 
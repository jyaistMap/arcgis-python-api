# docker

Some useful docker images for utilizing the ArcGIS API for Python in your workflows

## LambdaBaseImage

#### ghcr.io/esri/arcgis-python-api-lambda:latest

To use this image, setup your dockerfile like:
```
FROM ghcr.io/esri/arcgis-python-api-lambda:latest
COPY app.py ${LAMBDA_TASK_ROOT}
```

your app.py should have a handler method:
```
import arcgis

def handler(event, context):
    """
    AWS Lambda Handler
    """
    print(f"Hello from AWS Lambda using ArcGIS API for Python {arcgis.__version__}!")
```

Push to your _private_ AWS ECR instance, and configure lambda to run from this container image.  As of this writing, public AWS ECR instances are not supported for lambda.

## AzureFunctionsBaseImage

#### ghcr.io/esri/arcgis-python-api-azure-functions:latest

[Sample](samples/AzureFunctions)

To use this image, setup your dockerfile like
```
FROM ghcr.io/esri/arcgis-python-api-azure-functions:latest
COPY . /home/site/wwwroot
```

Your copied resources will need to include:
- `host.json`, with your appsettings
- `function_app.py`, such as:

```
import arcgis
import azure.functions as func

app = func.FunctionApp()

@app.http_trigger(route='GET /', methods=['get'])
def main(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse(f"Hello from Azure Functions using ArcGIS API for Python {arcgis.__version__}!")
```

Push to the container registry of your choice.

For futher information, see:

- https://learn.microsoft.com/en-us/azure/azure-functions/functions-reference-python?tabs=asgi%2Capplication-level&pivots=python-mode-decorators#programming-model
- https://learn.microsoft.com/en-us/azure/azure-functions/functions-deploy-container-apps?tabs=acr%2Cbash&pivots=programming-language-python#create-and-test-the-local-functions-project
- https://github.com/Azure/azure-functions-python-worker
- https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-custom-container
# templated from `func init --worker-runtime python --docker`
# see https://learn.microsoft.com/en-us/azure/azure-functions/functions-deploy-container-apps?tabs=acr%2Cbash&pivots=programming-language-python#create-and-test-the-local-functions-project
# and https://learn.microsoft.com/en-us/azure/azure-functions/functions-reference-python?tabs=asgi%2Capplication-level&pivots=python-mode-decorators#programming-model
import arcgis
import azure.functions as func

# NOTE: this is anonymous for sample/testing only,
# configure your authentication properly for production
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.function_name('HttpTrigger1')
@app.route(route='hello')
def main(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse(f"Hello from Azure Functions using ArcGIS API for Python {arcgis.__version__}!")
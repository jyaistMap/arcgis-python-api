ARG python_version=3.11
# azure-functions python image, defaults to python 3.11
FROM mcr.microsoft.com/azure-functions/python:4-python${python_version}

# set metadata
LABEL org.opencontainers.image.authors="jroebuck@esri.com"
LABEL org.opencontainers.image.description="Azure Functions image with arcgis Python API and its Linux dependencies preinstalled"
LABEL org.opencontainers.image.licenses=Apache
LABEL org.opencontainers.image.source=https://github.com/esri/arcgis-python-api

# install dependencies, then clean yum cache
RUN apt-get update && apt-get install -y gcc libkrb5-dev krb5-config krb5-user && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip3 install azure-functions && rm -rf /home/.cache/pip
# install arcgis
ARG arcgis_version="2.3.1"
# adding .* ensures the latest patch version is installed
RUN  pip3 install "arcgis==${arcgis_version}.*" && rm -rf /home/.cache/pip

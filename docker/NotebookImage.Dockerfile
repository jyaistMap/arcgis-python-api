ARG python_version="3.11"
FROM quay.io/jupyter/base-notebook:python-${python_version}

ARG python_version
ARG arcgis_version="2.3.1"
ARG sampleslink="https://github.com/Esri/arcgis-python-api/releases/download/v${arcgis_version}/samples.zip"
ARG githubfolder="arcgis-python-api"
ENV DOCKER_STACKS_JUPYTER_CMD="notebook"

LABEL org.opencontainers.image.authors="jroebuck@esri.com"
LABEL org.opencontainers.image.description="Jupyter Notebook with the latest version of the ArcGIS API for Python and its Linux dependencies preinstalled"
LABEL org.opencontainers.image.licenses=Apache
LABEL org.opencontainers.image.source=https://github.com/Esri/arcgis-python-api

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# Install Python API from Conda
RUN conda install -c esri arcgis=${arcgis_version} -y \
    && conda clean --all -f -y \
    && find /opt/conda -name __pycache__ -type d -exec rm -rf {} +

# Fetch and extract samples from GitHub
RUN mkdir /home/${NB_USER}/$githubfolder && \
    wget -O samples.zip $sampleslink \
    && unzip -q samples.zip -d /home/${NB_USER}/$githubfolder \
    && rm samples.zip \
    && mv /home/${NB_USER}/$githubfolder/* ./ \
    && rm -rf $githubfolder/ \
           apidoc/ \
           work/ \
           talks/ \
           environment.yml\
    && fix-permissions /home/${NB_USER}

RUN rm /opt/conda/lib/python${python_version}/site-packages/notebook/static/base/images/logo.png
COPY --chown=${NB_USER}:users jupyter_esri_logo.png /opt/conda/lib/python${python_version}/site-packages/notebook/static/base/images/logo.png
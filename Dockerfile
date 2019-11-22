FROM gcr.io/kaggle-images/python:v69
RUN pip install \
    jupyterhub==1.0.0 \
    notebook==6.0.0 \ 
    jupyterlab==1.2.1

RUN pip install oauthenticator

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs && \
    rm -rf /var/lib/apt/lists/*
ENV NODE_OPTIONS=--max-old-space-size=4096
RUN useradd -m strops

RUN npm install -g configurable-http-proxy

RUN pip install jupyterlab_sql

RUN jupyter serverextension enable jupyterlab_sql --py --sys-prefix
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build
RUN jupyter labextension install plotlywidget@1.3.0 --no-build
RUN jupyter labextension install jupyterlab-plotly@1.3.0 --no-build
RUN jupyter labextension install jupyterlab-drawio --no-build
RUN jupyter lab build


RUN useradd -m hksitorus && useradd -m arifsolomon && useradd -m fchrulk

CMD ["jupyterhub", "-f", "jupyterhub_config.py"]

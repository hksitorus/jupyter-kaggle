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

RUN conda install --quiet --yes basemap pyproj proj4
RUN wget https://raw.githubusercontent.com/matplotlib/basemap/master/lib/mpl_toolkits/basemap/data/epsg -O /opt/conda/share/proj/epsg
ENV PROJ_LIB=/opt/conda/share/proj/

RUN pip install psycopg2 cx_Oracle PyMySQL

RUN npm install -g --unsafe-perm ijavascript && ijsinstall --install=global

RUN pip install jupyterlab && jupyter labextension install @jupyter-widgets/jupyterlab-manager

CMD ["jupyterhub", "-f", "jupyterhub_config.py"]

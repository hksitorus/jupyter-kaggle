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

RUN conda install --quiet --yes -c bokeh jupyter_bokeh && jupyter labextension install @bokeh/jupyter_bokeh --no-build
RUN jupyter labextension install @mflevine/jupyterlab_html --no-build
RUN pip install jupyterlab_latex && jupyter labextension install @jupyterlab/latex --no-build
RUN conda install --quiet --yes -c pyviz holoviews bokeh && jupyter labextension install @pyviz/jupyterlab_pyviz --no-build
RUN conda install --quiet --yes -c conda-forge ipyleaflet && jupyter labextension install jupyter-leaflet --no-build
RUN conda install --quiet --yes -c conda-forge ipysheet && jupyter labextension install ipysheet --no-build


RUN jupyter lab build

RUN pip install intel-tensorflow
RUN pip install pyspark

ENV APACHE_SPARK_VERSION 2.4.4
ENV HADOOP_VERSION 2.7

RUN cd /tmp && \
    wget -q http://mirrors.ukfast.co.uk/sites/ftp.apache.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    echo "2E3A5C853B9F28C7D4525C0ADCB0D971B73AD47D5CCE138C85335B9F53A6519540D3923CB0B5CEE41E386E49AE8A409A51AB7194BA11A254E037A848D0C4A9E5 *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local --owner root --group root --no-same-owner && \
    rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

COPY mesos.key /tmp/
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y gnupg && \
    apt-key add /tmp/mesos.key && \
    echo "deb http://repos.mesosphere.io/ubuntu xenial main" > /etc/apt/sources.list.d/mesosphere.list && \
    apt-get -y update && \
    apt-get --no-install-recommends -y install mesos=1.2\* && \
    apt-get purge --auto-remove -y gnupg && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip
ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so
ENV SPARK_OPTS --driver-java-options=-Xms4096M --driver-java-options=-Xmx32768M --driver-java-options=-Dlog4j.logLevel=info

CMD ["jupyterhub", "-f", "jupyterhub_config.py"]

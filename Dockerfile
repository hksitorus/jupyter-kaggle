FROM gcr.io/kaggle-images/python:v69
RUN pip install \
    jupyterhub==1.0.0 \
    notebook==6.0.0 \ 
    jupyterlab==1.2.1

RUN useradd -m jovyan
ENV HOME=/home/jovyan
WORKDIR $HOME
USER jovyan

CMD ["jupyterhub-singleuser"]

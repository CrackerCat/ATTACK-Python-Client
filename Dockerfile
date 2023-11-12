# ATTACK Python Client script: Jupyter Environment Dockerfile

ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/base-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update --yes && \
    apt-get install gcc build-essential --yes --no-install-recommends

RUN python3 -m pip install --upgrade six==1.15.0 attackcti==0.3.8 pandas==1.3.5 altair vega

COPY docs/intro.ipynb ${HOME}/docs/
COPY docs/playground ${HOME}/docs/playground
COPY docs/presentations ${HOME}/docs/presentations

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

WORKDIR ${HOME}

# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=daskdev/dask-notebook
FROM $BASE_CONTAINER

LABEL maintainer="paustin@eoas.ubc.ca"

USER $ROOT

RUN apt-get update --fix-missing \
    && apt-get install -y  graphviz


# Copy over build files. Unfortunately we can't use $NB_UID/$NB_GID
# in the `--chown` statement, so we need to hardcode these values.
COPY --chown=1000:100 requirements_linux.txt environment_linux.txt postBuild $HOME/
RUN mkdir -p /usr/local/share/jupyter \
    && chmod a+r,a+w,a+x /usr/local/share/jupyter 

USER $NB_UID

WORKDIR $HOME

# Install Python 3 packages
RUN  conda install --quiet --yes \
    --file environment_linux.txt \
    && \
    conda install -c bokeh jupyter_bokeh \
    && \
    conda clean --all -f -y \
    && \
    pip install -r requirements_linux.txt

RUN echo "Checking for 'postBuild'..." \
    && export PATH=${NB_PYTHON_PREFIX}/bin:${PATH} \
    && chmod +x postBuild \
    && echo "running postBuild" \
    && ./postBuild \
    && rm -rf /tmp/* \
    && rm -rf ${HOME}/.cache ${HOME}/.npm ${HOME}/.yarn \
    && rm -rf ${NB_PYTHON_PREFIX}/share/jupyter/lab/staging \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete 



USER $NB_UID


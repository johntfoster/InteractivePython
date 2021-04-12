FROM mambaorg/micromamba:latest


ENV NB_USER default
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

RUN chown -R ${NB_USER} ${HOME}
WORKDIR ${HOME}

RUN micromamba install -y -n base -c conda-forge \ 
    ipywidgets=7.5.1 \
    matplotlib=3.2.1 \
    notebook=6.1.4 \
    numba=0.51.2 \
    numpy=1.18.4 \
    pandas=1.0.3 \
    pip=20.1.1 \
    python=3.7.8 \
    scikit-learn=0.23.1 \
    scipy=1.4.1 \
    seaborn=0.10.1 && \
    rm /opt/conda/pkgs/cache/*

RUN pip install geostatspy==0.0.19

RUN mkdir ${HOME}/notebooks
COPY *.ipynb ${HOME}/notebooks/
RUN chown -R ${NB_USER} ${HOME}/notebooks
WORKDIR ${HOME}/notebooks
USER ${NB_USER}
RUN jupyter trust ${HOME}/notebooks/*.ipynb

ENTRYPOINT ["jupyter", "notebook", "--ip", "0.0.0.0"]

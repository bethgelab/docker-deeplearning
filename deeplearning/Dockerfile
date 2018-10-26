FROM jupyter/scipy-notebook

USER root

RUN conda install --quiet --yes \
    'tensorflow-gpu' \
    'mypy' \
    'keras' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $UID

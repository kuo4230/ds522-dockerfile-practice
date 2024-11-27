# Use the Jupyter team's minimal-notebook image as the base
# This image includes Jupyter Notebook and minimal dependencies
FROM quay.io/jupyter/minimal-notebook:afe30f0c9ad8

# Copy the conda lock file into the container
# The lock file ensures exact versions of dependencies are installed
COPY conda-linux-64.lock /tmp/conda-linux-64.lock

# Install dependencies specified in the conda lock file using mamba
# 1. Use `mamba update` to install packages from the lock file
# 2. Clean up unnecessary files with `mamba clean` to reduce image size
# 3. Fix permissions for Conda directory and home directory of the Jupyter user
RUN mamba update --quiet --file /tmp/conda-linux-64.lock \
    && mamba clean --all -y -f \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"
#!/bin/bash

CONDA_ENV_NAME="rapids${RAPIDS_VER}_cuda${CUDA_VER}_py${PYTHON_VER}"

echo "Creating CONDA environment $CONDA_ENV_NAME"
conda create -y --name=$CONDA_ENV_NAME python=$PYTHON_VER
source activate $CONDA_ENV_NAME

echo "Installing conda packages"
conda install -y -c $CONDA_USERNAME -c nvidia -c conda-forge \
    "rapids=$RAPIDS_VER" \
    "cudatoolkit=$CUDA_VER" \
    "gcc_linux-64==9.*" \
    "sysroot_linux-64==2.17" \
    "conda-pack" \
    "ipykernel" \
    "cuda-python=11.7.0"

echo "Packing conda environment"
conda-pack --quiet --ignore-missing-files -n $CONDA_ENV_NAME -o ${CONDA_ENV_NAME}.tar.gz

export AWS_DEFAULT_REGION="us-east-2"
echo "Upload packed conda"
aws s3 cp --quiet --acl public-read ${CONDA_ENV_NAME}.tar.gz s3://rapidsai-data/conda-pack/${CONDA_USERNAME}/${CONDA_ENV_NAME}.tar.gz

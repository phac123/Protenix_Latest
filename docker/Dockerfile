# syntax=docker/dockerfile:1.4
FROM nvidia/cuda:12.6.1-cudnn-devel-ubuntu22.04

# Set default RUN shell to /bin/bash
SHELL ["/bin/bash", "-cu"]


# Set environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install basic packages for compiling and building
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
    build-essential \
    cmake \
    g++-12 \
    git \
    git-lfs \
    curl \
    wget \
    ca-certificates \
    libjpeg-dev \
    libpng-dev \
    librdmacm1 \
    libibverbs1 \
    ibverbs-providers \
    tzdata \
    libgl1-mesa-glx \
    libglib2.0-0 \
    fontconfig \
    gcc \
    libc6-dev \
    make \
    postgresql \
    && rm -rf /var/lib/apt/lists/*


# Install Miniconda & use Python 3.11
ARG python=3.11
ENV PYTHON_VERSION=${python}
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/install-conda.sh \
    && chmod +x /tmp/install-conda.sh \
    && bash /tmp/install-conda.sh -b -f -p /usr/local \
    && rm -f /tmp/install-conda.sh \
    && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
    && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r \
    && conda install -y python=${PYTHON_VERSION} \
    && conda clean -y --all

# Install Pytorch 2.2
# you can find other versions and installation commands from:
# https://pytorch.org/get-started/previous-versions/
# https://github.com/pytorch/pytorch/wiki/PyTorch-Versions
# RUN pip install --no-cache-dir \
#     torch==2.2.1 \
#     --extra-index-url https://download.pytorch.org/whl/cu118
ENV TORCH_CUDA_ARCH_LIST="8.0;9.0"
# Setup TUNA mirror (optional)
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN cat <<EOT >> ~/.condarc
channels:
  - defaults
show_channel_urls: true
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  nvidia: https://mirrors.sustech.edu.cn/anaconda-extra/cloud
EOT
RUN /usr/local/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
    && /usr/local/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r \
    && /usr/local/bin/conda tos accept --override-channels --channel https://conda.anaconda.org/pytorch \
    && /usr/local/bin/conda tos accept --override-channels --channel https://conda.anaconda.org/conda-forge
RUN pip install --no-cache-dir \
    torch==2.7.1 --index-url https://download.pytorch.org/whl/cu126 \
    torchvision==0.22.1 \
    torchaudio==2.7.1
RUN pip3 install --no-cache-dir \
    cuequivariance-ops-torch-cu12==0.6.1 \
    cuequivariance-torch==0.6.1
RUN pip3 --no-cache-dir install \
    scipy==1.16.1 \
    ml_collections==1.1.0 \
    tqdm==4.67.1 \
    pandas==2.3.1 \
    dm-tree==0.1.9 \
    PyYAML==6.0.2 \
    matplotlib==3.10.5 \
    ipywidgets==8.1.7 \
    py3Dmol==2.5.2 \
    rdkit==2023.9.6 \
    biopython==1.85 \
    biotite==1.4.0 \
    modelcif==1.4 \
    gemmi==0.6.7 \
    pdbeccdutils==0.8.6 \
    fair-esm==2.0.0 \
    scikit-learn==1.7.1 \
    scikit-learn-extra==0.3.0 \
    deepspeed==0.17.4 \
    triton==3.3.1 \
    optree==0.17.0 \
    protobuf==6.31.1 \
    icecream==2.1.7 \
    ipdb==0.13.13 \
    wandb==0.21.1 \
    posix_ipc==1.3.0 \
    numpy==1.26.4

RUN git clone -b v3.5.1 https://github.com/NVIDIA/cutlass.git /opt/cutlass
ENV CUTLASS_PATH=/opt/cutlass

# for additional dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

RUN mkdir -p /usr/local/lib/python3.11/site-packages/release_data && chmod 777 $_
RUN mkdir -p /usr/local/lib/python3.11/site-packages/protenix/model/tri_attention/TriAttentionCache \
 && chmod -R 777 /usr/local/lib/python3.11/site-packages/protenix/model/tri_attention/TriAttentionCache

COPY . /workspace
WORKDIR /workspace

RUN pip3 install --no-cache-dir -e .
RUN pip3 install --no-cache-dir .

CMD ["bash"]

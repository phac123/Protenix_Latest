# Protenix official Dockerfile
FROM vemlp-cn-beijing.cr.volces.com/preset-images/pytorch:2.7.1-cu12.6.3-py3.11-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN sed -i.bak 's#http://mirrors.volces.com#https://mirrors.tuna.tsinghua.edu.cn#g' /etc/apt/sources.list && \
    sed -i 's#http://archive.ubuntu.com#https://mirrors.tuna.tsinghua.edu.cn#g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make \
        postgresql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

RUN pip3 install --no-cache-dir \
    torch==2.7.1 \
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
COPY ../requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt


COPY . /workspace
WORKDIR /workspace
RUN pip3 install --no-cache-dir -e .
CMD ["bash"]


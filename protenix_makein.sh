#!/bin/bash
docker run -it --rm \
  --gpus all \
  --shm-size=16g \
  -v $(pwd):/workspace \
  -w /workspace \
  pre_airdd_protenix:latest \
  bash

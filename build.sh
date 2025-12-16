docker build -t liquan_pre_airdd_protenix:latest -f ./docker/Dockerfile $(pwd) \
    --build-arg "http_proxy=http://10.0.0.12:8001" \
    --build-arg "https_proxy=http://10.0.0.12:8001"

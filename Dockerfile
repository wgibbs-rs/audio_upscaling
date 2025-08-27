
# Use official Julia image as base
FROM julia:1.9-bullseye

WORKDIR /app

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

COPY . /app

# Install Julia packages
RUN julia setup.jl

RUN pip3 install julia 

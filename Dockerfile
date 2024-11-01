# Stage 1: Base image with common dependencies
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04 as base

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive
# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1
# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1 

# Install Python, git and other necessary tools
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget

# Clean up to reduce image size
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*


WORKDIR /

# Clone ComfyUI repository
RUN git clone https://github.com/minkhant1996/ComfyUI-Min.git /comfyui

# Change working directory to ComfyUI
WORKDIR /comfyui

# Update models_folder path in the configuration file
RUN sed -i 's|models_folder:.*|models_folder: /runpod-volume/models|' min-comfyui-config.yaml
RUN sed -i 's|output_folder:.*|output_folder: /runpod-volume/output|' min-comfyui-config.yaml

# Install ComfyUI dependencies
RUN pip3 install --upgrade --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 \
    && pip3 install --upgrade -r requirements.txt

# Install runpod
RUN pip3 install runpod requests ultralytics xformers

RUN cd custom_nodes && git clone https://github.com/XLabs-AI/x-flux-comfyui.git \
    && git clone https://github.com/alexopus/ComfyUI-Image-Saver.git \
    && git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git

# Install Nodes
RUN cd custom_nodes/x-flux-comfyui && pip3 install -r requirements.txt
RUN cd custom_nodes/ComfyUI-Image-Saver && pip3 install -r requirements.txt
RUN cd custom_nodes/ComfyUI-Impact-Pack && pip3 install -r requirements.txt && python3 install.py



# Go back to the root
WORKDIR /



# WORKDIR /comfyui

CMD ["python3", "comfyui/main.py", "--listen", "0.0.0.0", "--port", "8188"]

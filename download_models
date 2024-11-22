#!/bin/bash

# Check if a folder argument is provided, default to "models" if not
MODEL_FOLDER=${1:-models}

# Load environment variables from .env file, ignoring comments and blank lines
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# Check if HUGGINGFACE_FLUX_TOKEN is set
if [ -z "$HUGGINGFACE_FLUX_TOKEN" ]; then
  echo "HUGGINGFACE_FLUX_TOKEN is not set in .env file"
  exit 1
fi

# Login to Hugging Face using the access token
echo "$HUGGINGFACE_FLUX_TOKEN" | huggingface-cli login --token $HUGGINGFACE_FLUX_TOKEN

# Create model subdirectories
mkdir -p "$MODEL_FOLDER/unet" "$MODEL_FOLDER/clip" "$MODEL_FOLDER/vae" "$MODEL_FOLDER/ultralytics/bbox" "$MODEL_FOLDER/loras/flux/Turbo"

# Download the necessary models if they don't already exist
if [ ! -f "$MODEL_FOLDER/unet/flux_dev.safetensors" ]; then
  wget --header="Authorization: Bearer ${HUGGINGFACE_FLUX_TOKEN}" -O "$MODEL_FOLDER/unet/flux_dev.safetensors" https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors
else
  echo "flux_dev.safetensors already exists in $MODEL_FOLDER/unet, skipping download."
fi

if [ ! -f "$MODEL_FOLDER/clip/clip_l.safetensors" ]; then
  wget -O "$MODEL_FOLDER/clip/clip_l.safetensors" https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
else
  echo "clip_l.safetensors already exists in $MODEL_FOLDER/clip, skipping download."
fi

if [ ! -f "$MODEL_FOLDER/clip/t5xxl_fp16.safetensors" ]; then
  wget -O "$MODEL_FOLDER/clip/t5xxl_fp16.safetensors" https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors
else
  echo "t5xxl_fp16.safetensors already exists in $MODEL_FOLDER/clip, skipping download."
fi

if [ ! -f "$MODEL_FOLDER/vae/ae.safetensors" ]; then
  wget --header="Authorization: Bearer ${HUGGINGFACE_FLUX_TOKEN}" -O "$MODEL_FOLDER/vae/ae.safetensors" https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors
else
  echo "ae.safetensors already exists in $MODEL_FOLDER/vae, skipping download."
fi

if [ ! -f "$MODEL_FOLDER/ultralytics/bbox/face_yolov8m.pt" ]; then
  wget -O "$MODEL_FOLDER/ultralytics/bbox/face_yolov8m.pt" https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt
else
  echo "face_yolov8m.pt already exists in $MODEL_FOLDER/ultralytics/bbox, skipping download."
fi

# Download diffusion_pytorch_model.safetensors, rename to Flux-Turbo.safetensors, and save to models/loras/flux/Turbo
if [ ! -f "$MODEL_FOLDER/loras/flux/Turbo/Flux-Turbo.safetensors" ]; then
  wget -O "$MODEL_FOLDER/loras/flux/Turbo/Flux-Turbo.safetensors" https://huggingface.co/alimama-creative/FLUX.1-Turbo-Alpha/blob/main/diffusion_pytorch_model.safetensors
else
  echo "Flux-Turbo.safetensors already exists in $MODEL_FOLDER/loras/flux/Turbo, skipping download."
fi

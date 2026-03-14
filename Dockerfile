FROM runpod/worker-comfyui:5.7.1-base

# Registry-managed custom nodes pinned to published package versions.
RUN comfy node install --exit-on-fail controlaltai-nodes --mode remote
RUN comfy node install --exit-on-fail RES4LYF --mode remote
RUN comfy node install --exit-on-fail rgthree-comfy
RUN comfy node install --exit-on-fail comfyui-easy-use

# Vendored GitHub custom node pinned by commit in vendor/custom_nodes.lock.
COPY vendor/custom_nodes/comfyui-vrgamedevgirl/ /comfyui/custom_nodes/comfyui-vrgamedevgirl/
RUN python -m pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui-vrgamedevgirl/requirements.txt

# Model assets.
COPY vendor/models/upscale_models/4xPurePhoto-RealPLSKR.pth /comfyui/models/upscale_models/4xPurePhoto-RealPLSKR.pth
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors?download=true \
  --relative-path models/text_encoders \
  --filename qwen_3_4b.safetensors
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/vae/ae.safetensors?download=true \
  --relative-path models/vae \
  --filename ae.safetensors \
  && ln -sf /comfyui/models/vae/ae.safetensors /comfyui/models/vae/zimagebase_ae.safetensors
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/diffusion_models/z_image_bf16.safetensors?download=true \
  --relative-path models/diffusion_models \
  --filename z_image_bf16.safetensors
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors?download=true \
  --relative-path models/diffusion_models \
  --filename z_image_turbo_bf16.safetensors
COPY vendor/models/VAE-approx/model.pt /comfyui/models/VAE-approx/model.pt

# Local LoRAs.
COPY loras/ /comfyui/models/loras/

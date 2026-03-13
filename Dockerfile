# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
RUN comfy node install --exit-on-fail controlaltai-nodes@1.1.4 --mode remote
RUN comfy node install --exit-on-fail RES4LYF
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053
RUN comfy node install --exit-on-fail comfyui-easy-use@1.3.6
# unknown-registry custom nodes (direct GitHub clones)
RUN git clone https://github.com/vrgamegirl19/comfyui-vrgamedevgirl /comfyui/custom_nodes/comfyui-vrgamedevgirl
# Could not resolve unknown_registry node 'Note' (no aux_id provided) - skipping

# download models into comfyui
RUN comfy model download --url https://github.com/starinspace/StarinspaceUpscale/releases/download/Models/4xPurePhoto-RealPLSKR.pth --relative-path models/upscale_models --filename 4xPurePhoto-RealPLSKR.pth
# RUN # Could not find URL for qwen_3_4b.safetensors
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors?download=true \
  --relative-path models/text_encoders \
  --filename qwen_3_4b.safetensors
# RUN # Could not find URL for z-image base\famegrid2\2026-02-15_19-33-05-save-6860-70-0.safetensors
# RUN # Could not find URL for zimagebase_ae.safetensors
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/vae/ae.safetensors?download=true \
  --relative-path models/vae \
  --filename ae.safetensors \
  && ln -sf /comfyui/models/vae/ae.safetensors /comfyui/models/vae/zimagebase_ae.safetensors
# RUN # Could not find URL for z_image_bf16.safetensors
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/diffusion_models/z_image_bf16.safetensors?download=true \
  --relative-path models/diffusion_models \
  --filename z_image_bf16.safetensors
# RUN # Could not find URL for z-image base\famegrid5\fmgrd42026-02-17_13-14-24-save-10780-20-0.safetensors
RUN mkdir -p "/comfyui/models/loras/z-image base/famegrid5" && \
    curl -L "https://civitai.com/api/download/models/2733658?type=Model&format=SafeTensor&token=2a19d3d050440ff647b0472df03aebd0" \
    -o "/comfyui/models/loras/z-image base/famegrid5/fmgrd42026-02-17_13-14-24-save-10780-20-0.safetensors"
# RUN # Could not find URL for z_image_turbo_bf16.safetensors
RUN comfy model download \
  --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors?download=true \
  --relative-path models/diffusion_models \
  --filename z_image_turbo_bf16.safetensors
# RUN # Could not find URL for VAE-approx\model.pt
RUN mkdir -p /comfyui/models/VAE-approx \
  && curl -L \
    https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/models/VAE-approx/model.pt \
    -o /comfyui/models/VAE-approx/model.pt

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

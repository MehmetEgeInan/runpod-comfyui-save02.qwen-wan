#!/bin/bash
set -e

MODE="${RUN_MODE:-ui}"

if [ "$MODE" = "serverless" ]; then
  echo "Starting ComfyUI in background..."
  /workspace/start.sh &

  # Wait for ComfyUI HTTP to be ready
  for i in $(seq 1 90); do
    if curl -s http://127.0.0.1:8188/ >/dev/null 2>&1; then
      echo "ComfyUI is ready"
      break
    fi
    sleep 2
  done

  echo "Starting Runpod handler..."
  exec python3 /workspace/handler.py
else
  echo "Starting in UI mode..."
  # Runtime'da modeller yoksa kontrol et
  echo "Checking available models..."
  
  # Qwen model kontrolü
  if [ ! -f "/workspace/ComfyUI/models/checkpoints/${QWEN_FILENAME}" ]; then
    echo "⚠️  Qwen model not found in checkpoints/"
  else
    echo "✅ Qwen Image model: $(du -h /workspace/ComfyUI/models/checkpoints/${QWEN_FILENAME} | cut -f1)"
  fi
  
  # WAN 2.2 model kontrolleri
  if [ -f "/workspace/ComfyUI/models/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors" ]; then
    echo "✅ WAN 2.2 High Noise: $(du -h /workspace/ComfyUI/models/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors | cut -f1)"
  else
    echo "⚠️  WAN 2.2 High Noise model not found"
  fi
  
  if [ -f "/workspace/ComfyUI/models/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors" ]; then
    echo "✅ WAN 2.2 Low Noise: $(du -h /workspace/ComfyUI/models/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors | cut -f1)"
  else
    echo "⚠️  WAN 2.2 Low Noise model not found"
  fi
  
  if [ -f "/workspace/ComfyUI/models/text_encoders/umt5_xxl_fp16.safetensors" ]; then
    echo "✅ UMT5 Text Encoder: $(du -h /workspace/ComfyUI/models/text_encoders/umt5_xxl_fp16.safetensors | cut -f1)"
  else
    echo "⚠️  UMT5 Text Encoder not found"
  fi
  
  if [ -f "/workspace/ComfyUI/models/vae/wan2.2_vae.safetensors" ]; then
    echo "✅ WAN 2.2 VAE: $(du -h /workspace/ComfyUI/models/vae/wan2.2_vae.safetensors | cut -f1)"
  else
    echo "⚠️  WAN 2.2 VAE not found"
  fi
  exec /workspace/start.sh
fi



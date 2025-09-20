# 🚀 Runpod Direct Build Deploy Talimatları

## Adım 1: GitHub Repository Oluşturma

1. **GitHub'da yeni repo** oluşturun: `runpod-comfyui`
2. **Bu klasördeki tüm dosyaları** GitHub'a upload edin:
   ```
   - Dockerfile
   - runpod-template.json
   - s3UploaderForLocals/
   - serverless/
   - docker-compose.yml
   - README.md
   - RUNPOD_DEPLOY.md
   ```

## Adım 2: Runpod Template Oluşturma

1. **Runpod Dashboard** → **Templates** → **New Template**

2. **Template Ayarları**:
   - **Name**: `ComfyUI RunPod S3 Integration`
   - **Image Source**: `Build from Dockerfile`
   - **GitHub Repository**: `https://github.com/SIZIN_USERNAME/runpod-comfyui`
   - **Dockerfile Path**: `Dockerfile`

3. **Build Arguments**:
   ```
   TORCH_CUDA_ARCH_LIST=8.0;8.6;8.9;9.0;10.0
   MAX_JOBS=4
   ```

4. **Environment Variables**:
   ```
   RUN_MODE=ui
   QWEN_REPO_ID=Qwen/Qwen-Image
   QWEN_FILENAME=qwen_image_distill_full_bf16.safetensors
   AWS_ACCESS_KEY_ID=AKIAYQNJS76JGOLLN5UJ
   AWS_SECRET_ACCESS_KEY=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
   S3_BUCKET_NAME=discord-bot-new
   AWS_REGION=eu-north-1
   PYTHONUNBUFFERED=1
   NVIDIA_VISIBLE_DEVICES=all
   NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics
   ```

5. **Hardware Settings**:
   - **Container Disk**: 50GB
   - **Volume**: 100GB
   - **Memory**: 16GB minimum
   - **vCPU**: 4 minimum
   - **GPU**: 1 minimum (RTX 4090/A100 önerilir)

6. **Volume Mounts**:
   ```
   /workspace/ComfyUI/models → /models
   /workspace/ComfyUI/output → /output
   ```

7. **Ports**: `8188`

## Adım 3: Model Upload

1. **Models klasörünü** pod volume'ına upload edin
2. **Qwen model** path: `/models/checkpoints/qwen_image_distill_full_bf16.safetensors`

## Adım 4: Deploy ve Test

1. **Pod Deploy** et (Build: 15-25 dakika)
2. **Access**: `https://your-pod-id.proxy.runpod.net:8188`
3. **S3 test**: Generate bir image, otomatik S3'e upload olmalı

## ⚠️ Önemli Notlar

- **Build süresi**: 15-25 dakika (26GB build)
- **Internet**: Güçlü bağlantı gerekli
- **GPU**: RTX 4090+ önerilir (6GB+ VRAM)
- **Storage**: Model için 100GB+ volume

## 🎯 Başarı Kriterleri

✅ ComfyUI web UI açılmalı
✅ Qwen model yüklenmeli  
✅ Custom nodes çalışmalı
✅ S3 upload otomatik olmalı
✅ xFormers aktif olmalı

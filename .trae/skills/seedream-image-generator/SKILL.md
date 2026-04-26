---
name: "seedream-image-generator"
description: "Generates images using Doubao Seedream 5.0 Lite via Volcano Engine Ark API. Invoke when user asks to generate AI images, create illustrations, or needs image generation with Chinese prompts."
---

# Seedream 5.0 Image Generator

## Purpose

Provide image generation capabilities through Volcano Engine's Ark platform using the Doubao Seedream 5.0 Lite model (`doubao-seedream-5-0-260128`).

## When to Use

- User wants to generate AI images or illustrations
- User needs image creation based on text prompts
- User asks about image generation models
- User provides Chinese or mixed-language image prompts
- User references Seedream, Doubao image models, or Volcano Engine image generation

## API Key Setup

### Step 1: Set Environment Variable

Set `SEEDREAM_API_KEY` as an environment variable:

```bash
export SEEDREAM_API_KEY="your-api-key-here"
```

To make it persistent, add the line above to your shell profile (e.g. `~/.zshrc` or `~/.bash_profile`).

### Step 2: Automatic Validation

The bundled script `scripts/generate_image.sh` will:
1. Read `SEEDREAM_API_KEY` from the environment.
2. If the variable is not set, prompt you to input the API Key interactively.
3. Validate the key by sending a test request to the API.
4. If the key is invalid or rejected, prompt you to input a new one.

## Guidelines

### API Endpoint

```
POST https://ark.cn-beijing.volces.com/api/v3/images/generations
```

### Authentication

The API Key is read from the `SEEDREAM_API_KEY` environment variable:

```bash
Authorization: Bearer $SEEDREAM_API_KEY
```

### Key Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | string | required | `doubao-seedream-5-0-260128` |
| `prompt` | string | required | Image description (supports Chinese) |
| `size` | string | `"2K"` | Image resolution: `"1K"` / `"2K"` / `"4K"` |
| `response_format` | string | `"url"` | `"url"` or `"b64_json"` |
| `watermark` | boolean | `true` | Whether to add watermark |
| `stream` | boolean | `false` | Stream response |
| `sequential_image_generation` | string | `"disabled"` | Sequential generation mode |

### Best Practices

1. **API Key**: Always use the environment variable. Never hard-code the key in scripts or commit it to version control.
2. **Prompts**: Seedream 5.0 excels at Chinese prompts. Include style keywords like `oc渲染`, `光线追踪`, `超现实主义` for better results.
3. **Size**: Use `"2K"` for standard quality, `"4K"` for high-resolution outputs.
4. **Response**: When `response_format` is `"url"`, the API returns a signed CDN URL. When `"b64_json"`, returns base64-encoded image data.

## Quick Example

```bash
export SEEDREAM_API_KEY="02d86425-f15e-4d87-887c-fc9e687fda92"

./scripts/generate_image.sh "一个可爱的猫咪，戴着太空头盔，漂浮在星云中，赛博朋克风格" 2K
```

## Resources

- **Detailed API docs**: `references/api-reference.md`
- **Executable script**: `scripts/generate_image.sh`

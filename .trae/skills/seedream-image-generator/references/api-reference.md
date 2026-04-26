# Seedream 5.0 Lite API Reference

## Model Info

- **Model ID**: `doubao-seedream-5-0-260128`
- **Provider**: Volcano Engine (火山引擎) Ark Platform
- **Console**: https://console.volcengine.com/ark/region:ark+cn-beijing/model/detail?Id=doubao-seedream-5-0
- **API Base**: `https://ark.cn-beijing.volces.com/api/v3/images/generations`

## Authentication

The API requires a Bearer token passed via the `Authorization` header.

**Recommended**: Store the API Key in the `SEEDREAM_API_KEY` environment variable instead of hard-coding it:

```bash
export SEEDREAM_API_KEY="02d86425-f15e-4d87-887c-fc9e687fda92"
```

Then reference it in requests:

```bash
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $SEEDREAM_API_KEY" \
  ...
```

### Environment Variable Setup (macOS / Linux)

```bash
# Temporary (current session only)
export SEEDREAM_API_KEY="your-api-key"

# Permanent (add to ~/.zshrc or ~/.bash_profile)
echo 'export SEEDREAM_API_KEY="your-api-key"' >> ~/.zshrc
source ~/.zshrc
```

## Request Body

```json
{
  "model": "doubao-seedream-5-0-260128",
  "prompt": "string",
  "size": "2K",
  "response_format": "url",
  "watermark": true,
  "stream": false,
  "sequential_image_generation": "disabled"
}
```

### Parameter Details

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `model` | string | Yes | — | Must be `doubao-seedream-5-0-260128` |
| `prompt` | string | Yes | — | Image generation prompt. Supports Chinese and English. Max 4000 characters. |
| `size` | string | No | `"2K"` | Image resolution. Options: `"1K"`, `"2K"`, `"4K"` |
| `response_format` | string | No | `"url"` | Output format. `"url"` returns a signed CDN URL; `"b64_json"` returns base64 string |
| `watermark` | boolean | No | `true` | Whether to include watermark on generated image |
| `stream` | boolean | No | `false` | Whether to use streaming response |
| `sequential_image_generation` | string | No | `"disabled"` | Sequential image generation mode |

## Response (URL format)

```json
{
  "created": 1699999999,
  "data": [
    {
      "url": "https://.../image.png",
      "revised_prompt": "优化后的提示词"
    }
  ]
}
```

## Error Responses

If the API Key is missing or invalid, the API returns:

```json
{
  "error": {
    "code": "AuthenticationError",
    "message": "the API key or AK/SK in the request is missing or invalid.",
    "type": "Unauthorized"
  }
}
```

## Complete Example

```bash
export SEEDREAM_API_KEY="02d86425-f15e-4d87-887c-fc9e687fda92"

curl -X POST "https://ark.cn-beijing.volces.com/api/v3/images/generations" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $SEEDREAM_API_KEY" \
  -d '{
    "model": "doubao-seedream-5-0-260128",
    "prompt": "星际穿越，黑洞，黑洞里冲出一辆快支离破碎的复古列车，抢视觉冲击力，电影大片，末日既视感，动感，对比色，oc渲染，光线追踪，动态模糊，景深，超现实主义，深蓝，画面通过细腻的丰富的色彩层次塑造主体与场景，质感真实，暗黑风背景的光影效果营造出氛围，整体兼具艺术幻想感，夸张的广角透视效果，耀光，反射，极致的光影，强引力，吞噬",
    "sequential_image_generation": "disabled",
    "response_format": "url",
    "size": "2K",
    "stream": false,
    "watermark": true
  }'
```

## Prompt Engineering Tips

Seedream 5.0 Lite is optimized for Chinese prompts. Recommended keywords:

- **Rendering**: `oc渲染`, `光线追踪`, `动态模糊`, `景深`, `极致的光影`
- **Style**: `超现实主义`, `赛博朋克`, `暗黑风`, `电影大片`, `油画风格`
- **Composition**: `广角透视`, `抢视觉冲击力`, `对比色`
- **Mood**: `末日既视感`, `艺术幻想感`, `氛围感`

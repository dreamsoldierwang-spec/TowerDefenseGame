#!/usr/bin/env bash
set -euo pipefail

# Seedream 5.0 Image Generation Script
# Usage: ./generate_image.sh "your prompt here" [1K|2K|4K]

API_URL="https://ark.cn-beijing.volces.com/api/v3/images/generations"
MODEL="doubao-seedream-5-0-260128"

# ------------------------------------------------------------------
# 1. Read or prompt for API Key
# ------------------------------------------------------------------
get_api_key() {
  local key=""

  # Try to read from environment variable
  if [ -n "${SEEDREAM_API_KEY:-}" ]; then
    key="$SEEDREAM_API_KEY"
  fi

  # If not set, prompt user interactively
  if [ -z "$key" ]; then
    echo "Environment variable SEEDREAM_API_KEY is not set."
    read -rp "Please enter your Seedream API Key: " key
    echo ""
  fi

  echo "$key"
}

# ------------------------------------------------------------------
# 2. Validate API Key by sending a lightweight test request
# ------------------------------------------------------------------
validate_api_key() {
  local key="$1"
  local test_response

  test_response=$(curl -s -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $key" \
    -d '{
      "model": "'$MODEL'",
      "prompt": "test",
      "size": "1K",
      "response_format": "url",
      "stream": false,
      "sequential_image_generation": "disabled"
    }')

  # Check for authentication errors
  if echo "$test_response" | grep -q '"error"'; then
    local error_msg
    error_msg=$(echo "$test_response" | grep -o '"message":"[^"]*"' | head -1 | sed 's/"message":"//;s/"$//')
    echo "API Key validation failed: ${error_msg:-Unknown error}"
    return 1
  fi

  return 0
}

# ------------------------------------------------------------------
# 3. Main flow: obtain and validate API Key
# ------------------------------------------------------------------
API_KEY=$(get_api_key)

while true; do
  if validate_api_key "$API_KEY"; then
    break
  fi

  echo ""
  read -rp "The API Key is missing or invalid. Please enter a valid API Key (or press Ctrl+C to exit): " API_KEY
  echo ""
done

echo "API Key validated successfully."
echo ""

# ------------------------------------------------------------------
# 4. Parse command-line arguments
# ------------------------------------------------------------------
PROMPT="${1:-}"
SIZE="${2:-2K}"

if [ -z "$PROMPT" ]; then
  echo "Usage: $0 \"<prompt>\" [size]"
  echo "  size: 1K | 2K (default) | 4K"
  exit 1
fi

echo "Generating image with Seedream 5.0..."
echo "Prompt: $PROMPT"
echo "Size: $SIZE"
echo ""

# ------------------------------------------------------------------
# 5. Call the image generation API
# ------------------------------------------------------------------
RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{
    \"model\": \"$MODEL\",
    \"prompt\": \"$PROMPT\",
    \"size\": \"$SIZE\",
    \"response_format\": \"url\",
    \"stream\": false,
    \"watermark\": true,
    \"sequential_image_generation\": \"disabled\"
  }")

# Check for errors in the final request
if echo "$RESPONSE" | grep -q '"error"'; then
  echo "Generation failed."
  echo "Response: $RESPONSE"
  exit 1
fi

# Extract and print URL
URL=$(echo "$RESPONSE" | grep -o '"url":"[^"]*"' | head -1 | sed 's/"url":"//;s/"$//')

if [ -n "$URL" ]; then
  echo "Image generated successfully!"
  echo "URL: $URL"
else
  echo "Unexpected response: $RESPONSE"
  exit 1
fi

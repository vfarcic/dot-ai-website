#!/bin/sh
set -e

# Smoke test script for dot-ai-website container
# Usage: ./scripts/smoke-test.sh [image-name]
# Default image: dot-ai-website:local

IMAGE="${1:-dot-ai-website:local}"
CONTAINER_NAME="dot-ai-website-smoke-test"
PORT=8080
MAX_RETRIES=10
RETRY_DELAY=2

echo "=== Smoke Test: $IMAGE ==="

# Cleanup function
cleanup() {
  echo ""
  echo "=== Cleanup ==="
  if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
    docker stop "$CONTAINER_NAME" >/dev/null 2>&1 || true
  fi
  if docker ps -aq -f name="$CONTAINER_NAME" | grep -q .; then
    docker rm "$CONTAINER_NAME" >/dev/null 2>&1 || true
  fi
  echo "Container cleaned up."
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Check if image exists
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Error: Image '$IMAGE' not found."
  echo "Build it first with: docker build -t $IMAGE ."
  exit 1
fi

# Start container
echo ""
echo "=== Starting container ==="
docker run -d --name "$CONTAINER_NAME" -p "$PORT:8080" "$IMAGE"
echo "Container started on port $PORT"

# Wait for container to be ready
echo ""
echo "=== Waiting for container to be ready ==="
retries=0
until curl -sf "http://localhost:$PORT/" >/dev/null 2>&1; do
  retries=$((retries + 1))
  if [ $retries -ge $MAX_RETRIES ]; then
    echo "Error: Container failed to become ready after $MAX_RETRIES attempts"
    echo "Container logs:"
    docker logs "$CONTAINER_NAME"
    exit 1
  fi
  echo "Waiting... (attempt $retries/$MAX_RETRIES)"
  sleep $RETRY_DELAY
done
echo "Container is ready!"

# Run smoke tests
echo ""
echo "=== Running smoke tests ==="

FAILED=0

# Test function (follows redirects with -L)
test_url() {
  url="$1"
  description="$2"

  printf "Testing: %-40s " "$description"
  if curl -sfL "$url" >/dev/null 2>&1; then
    echo "✓ PASS"
  else
    echo "✗ FAIL"
    FAILED=$((FAILED + 1))
  fi
}

# Core pages (use trailing slashes for Docusaurus routes)
test_url "http://localhost:$PORT/" "Landing page"
test_url "http://localhost:$PORT/docs/mcp/intro/" "MCP intro page"
test_url "http://localhost:$PORT/docs/mcp/quick-start/" "MCP quick start"
test_url "http://localhost:$PORT/docs/controller/intro/" "Controller intro page"

# Static assets (verify nginx is serving correctly)
test_url "http://localhost:$PORT/img/logo.jpeg" "Logo image"

# Check response contains expected content
echo ""
echo "=== Content validation ==="

printf "Testing: %-40s " "Landing page has title"
if curl -sf "http://localhost:$PORT/" | grep -q "DevOps AI Toolkit"; then
  echo "✓ PASS"
else
  echo "✗ FAIL"
  FAILED=$((FAILED + 1))
fi

printf "Testing: %-40s " "MCP docs have content"
if curl -sfL "http://localhost:$PORT/docs/mcp/intro/" | grep -qi "devops ai toolkit"; then
  echo "✓ PASS"
else
  echo "✗ FAIL"
  FAILED=$((FAILED + 1))
fi

# Summary
echo ""
echo "=== Summary ==="
if [ $FAILED -eq 0 ]; then
  echo "All smoke tests passed! ✓"
  exit 0
else
  echo "Failed tests: $FAILED"
  exit 1
fi

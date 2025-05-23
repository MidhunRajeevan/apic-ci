#!/bin/bash
set -eE  # Exit immediately and allow ERR trap

# Trap error and print message
error_handler() {
  echo "❌ Error occurred in script at line $1 while executing: $BASH_COMMAND"
  echo "Last output (if any):"
  cat /tmp/apic_last_output.log 2>/dev/null || echo "No output captured"
}
trap 'error_handler $LINENO' ERR

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  set -o allexport
  source .env
  set +o allexport
fi

echo "🔐 Logging into provider org $porg"
apic login --server "$server" --username "$user" --password "$password" --realm provider/default-idp-2 > /tmp/apic_last_output.log 2>&1

echo "📦 Publishing $prod to $catname catalog"
PUBLISH_OUTPUT=$(apic products:publish "$prod" --server "$server" --org "$porg" --catalog "$catname" --format json > /tmp/apic_last_output.log 2>&1)
URL=$(echo "$PUBLISH_OUTPUT" | jq -r '.url')
cat <<EOF > subscriber.txt
{
  "product_url": "$URL",
  "plan": "default-plan"
}
EOF
cat subscriber.txt
sleep 1

echo "📨 Subscribing $app application to product"
apic subscriptions:create --server "$server" --org "$porg" --consumer-org "$corg" --catalog "$catname" --app "$app" subscriber.txt > /tmp/apic_last_output.log 2>&1
sleep 1

echo "✅ Work done"
apic logout --server "$server" > /tmp/apic_last_output.log 2>&1

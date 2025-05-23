#!/bin/bash
set -e

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  set -o allexport
  source .env
  set +o allexport
fi

echo "Log into provider org $porg"
apic login --server "$server" --username "$user" --password "$password" --realm provider/default-idp-2

echo "Publish $prod to $catname catalog"
PUBLISH_OUTPUT=$(apic products:publish "$prod" --server "$server" --org "$porg" --catalog "$catname" --format json)
URL=$(echo "$PUBLISH_OUTPUT" | jq -r '.url')
cat <<EOF > subscriber.txt
{
  "product_url": "$URL",
  "plan": "default-plan"
}
EOF
cat subscriber.txt
sleep 1

echo "Subscribe $app application to product"
apic subscriptions:create --server "$server" --org "$porg" --consumer-org "$corg" --catalog "$catname" --app "$app" subscriber.txt
sleep 1

echo "Work done"
apic logout --server "$server"

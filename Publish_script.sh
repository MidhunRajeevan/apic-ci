#!/bin/bash
set -e

server="apic-mgmt-api-manager-tars-apic.apps.tars.ucmcswg.com"
user="dxadmin"
password="dx@283283"
porg="dx"
catname="retail-banking"
prod="accounts-product_1.0.0.yaml"
corg="fintech-one"
app="wallet"


echo "Log into provider org $porg"
apic login --server "$server" --username "$user" --password "$password" --realm provider/default-idp-2

echo "Publish $prod to $catname catalog"
ACMD="apic products:publish $prod --server $server --org $porg --catalog $catname"
URL=$($ACMD | awk '{print $4}')
echo "product_url: $URL" > subscriber.txt
echo "plan: default-plan" >> subscriber.txt
cat subscriber.txt
sleep 1

echo "Subscribe $app application to product"
apic subscriptions:create --server "$server" --org "$porg" --consumer-org "$corg" --catalog "$catname" --app "$app" subscriber.txt
sleep 1

echo "Work done"
apic logout --server "$server"

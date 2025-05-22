echo off
setlocal
set server=apic-mgmt-api-manager-tars-apic.apps.tars.ucmcswg.com
set user=dxadmin
set password=dx@283283
set porg=dx
set catname=retail-banking
set prod=accounts-product_1.0.0.yaml
set corg=fintech-one
set app=wallet


echo log into provider org %porg_name%
apic login --server %server% --username %user% --password %password% --realm provider/default-idp-2

echo  : 
echo publish %prod% to %catname% catalog
set ACMD=apic products:publish %prod% --server %server% --org %porg_name% --catalog %catname% 
echo : success

for /f "tokens=4 delims= " %%a in ('%ACMD%') do set URL=%%a
set product-url=product_url: %URL%
echo %product-url%>subscriber.txt
echo plan: default-plan>>subscriber.txt
type subscriber.txt
echo :
timeout /t 1 /nobreak > NUL


echo subscribe %app% application to product
apic subscriptions:create --server %server% --org %porg% --consumer-org %corg% --catalog %catname% --app %app%  subscriber.txt

echo :
timeout /t 1 /nobreak > NUL
::echo check subscriptions to existing prod
::apic subscriptions:list --server %server% --org %porg_name% --catalog sandbox --consumer-org sandboxtestorgantization --app mock_studentApp

echo  : 

echo work done
apic logout --server %server% 
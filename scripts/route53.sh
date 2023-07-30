aws route53 list-hosted-zones > aws/.route53zones-exports.json
cat aws/.route53zones-exports.json | jq -r '.HostedZones[]|[.Id,.Name]|join(", ")' > aws/route53-exports.md

echo -e "\n\nINCOMPLETE !!!! \n" >> aws/route53-exports.md
echo -e "\n\nName,Type,ResourceRecords.Value,AliasTarget,TTL \n" >> aws/route53-exports.md

for zone in `cat aws/.route53zones-exports.json | jq -r '.HostedZones[].Id'`; do \
    record_set=$(aws route53 list-resource-record-sets --hosted-zone-id $zone )
    echo -e "$record_set" >> aws/route53-detailed-exports.json
    records=$(echo "$record_set" | jq -r '.ResourceRecordSets[]? | "\(.Name),\(.Type),\(.ResourceRecords[]?.Value),\(.AliasTarget?.DNSNAME),\(.TTL)"' )
    { echo -e "\n# $zone"; echo "\`\`\`csv" ; echo "$records" ;  echo "\`\`\`";  } >> aws/route53-exports.md
done


echo "getting top services bill  /tmp/cloud-bill.json ..."
# https://medium.com/circuitpeople/aws-cli-with-jq-and-bash-9d54e2eabaf1
aws ce get-cost-and-usage --time-period Start=$(date "+%Y-%m-01"),End=$(date --date="$(date +'%Y-%m-01') + 1 month  - 1 second" -I) --granularity MONTHLY --metrics USAGE_QUANTITY UnblendedCost  --group-by Type=DIMENSION,Key=SERVICE --output json>  /tmp/cloud-bill.json 

cat /tmp/cloud-bill.json | jq '[ .ResultsByTime[].Groups[] | select(.Metrics.UnblendedCost.Amount > "0") | { (.Keys[0]): .Metrics.UnblendedCost } ] | sort_by(.Amount) | add' > /tmp/cloud-bill2.json 

# Sort and display in a table with left aligned
python3 -c 'import os,json; f = open("/tmp/cloud-bill2.json"); data = json.load(f); data=dict(sorted(data.items(), key=lambda item: item[1]["Amount"] , reverse=True)) ; print("\n".join(["{:<35}: {}".format(service, val["Amount"]) for service,val in data.items()]))'♑

# https://stackoverflow.com/questions/68312370/how-can-i-get-the-daily-costs-using-the-aws-cli

echo "getting monthly bill..."

aws ce get-cost-and-usage \
 --time-period Start=$(date +"%Y-%m-%d" --date="-3 months"),End=$(date +"%Y-%m-%d") \
 --granularity=MONTHLY \
 --metrics UnblendedCost \
 --query "ResultsByTime[].[TimePeriod.Start, Total.UnblendedCost.[Amount][0], Total.UnblendedCost.[Unit][0]]" \
 --no-cli-pager \
 --output table


echo "getting daily bill..."
aws ce get-cost-and-usage \
 --time-period Start=$(date +"%Y-%m-%d" --date="-240 hours"),End=$(date +"%Y-%m-%d") \
 --granularity=DAILY \
 --metrics UnblendedCost \
 --query "ResultsByTime[].[TimePeriod.Start, Total.UnblendedCost.[Amount][0], Total.UnblendedCost.[Unit][0]]" \
 --no-cli-pager \
 --output table

#!/bin/bash 

set -eo pipefail 

export FORCE_TIMES_TO_RUN=1
export BUCKET_NAME="ag-dev-af-south-1-container-benchmark-results"

python3 -m http.server > /dev/null 2>&1 &

echo "starting sysbench"
sysbench cpu --threads=4 --cpu-max-prime=1000000 run | grep "total time" | awk '{print $3} ' > "/var/lib/phoronix-test-suite/test-results/sysbench-$(date -Iseconds).out"

echo "starting phoronix"
phoronix-test-suite batch-benchmark containerbenchmark

echo "starting upload"
aws s3 cp --recursive /var/lib/phoronix-test-suite/test-results "s3://${BUCKET_NAME}/${EXECUTION_TYPE}/" --region af-south-1 --sse AES256
echo "upload complete"

exit 0
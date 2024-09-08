#!/bin/bash

# Set the GCR repository
REPO="gcr.io/moonlit-sphinx-433913-h6"

# Get the current date and time for the output file name
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Define the output file name
OUTPUT_FILE="scan_results/trivy_scan_results_$TIMESTAMP.txt"

# Get a list of images from the repository
IMAGES=$(gcloud container images list --repository=$REPO --format='value(NAME)')

# Loop through each image and scan it using Trivy, saving output to the file
for IMAGE in $IMAGES; do
    echo "Scanning $IMAGE..." | tee -a $OUTPUT_FILE
    trivy image $IMAGE | tee -a $OUTPUT_FILE
    echo "-------------------------------------" | tee -a $OUTPUT_FILE
done

echo "Scan results saved to $OUTPUT_FILE"


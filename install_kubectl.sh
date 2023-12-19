#!/bin/bash

# Fetch the latest stable version of kubectl
latest_version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
echo "The latest stable version of kubectl is $latest_version"

# Ask the user to confirm or provide a specific version
read -p "Enter the version of kubectl to install (or press Enter to use the latest version $latest_version): " version
if [ -z "$version" ]; then
    version=$latest_version
fi

# Validate version format
if [[ $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Installing kubectl version $version..."
else
    echo "Error: Version format is invalid. Expected format is 'v<major>.<minor>.<patch>'."
    exit 1
fi

# Download kubectl
curl -LO "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl"

# Verify the download
curl -LO "https://dl.k8s.io/$version/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256) kubectl" | sha256sum --check

# Make the kubectl binary executable
chmod 755 ./kubectl

# Move the binary to a directory included in the user's PATH
sudo mv ./kubectl /usr/local/bin/kubectl

echo "kubectl version $version installed successfully."

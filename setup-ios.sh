#!/bin/bash

# Setup script for iOS development environment

echo "Setting up iOS development environment..."

# Install Xcode from the App Store
echo "Please install Xcode from the App Store if you haven't already."
echo "After installation, open Xcode to accept the license agreement and install additional components."

# Install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
xcode-select --install

# Set up iOS simulator
echo "Setting up iOS simulator..."
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

echo "iOS setup complete."
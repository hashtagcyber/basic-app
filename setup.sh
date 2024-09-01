#!/bin/bash

# Setup script for basic-app Flutter project

echo "Setting up development environment for basic-app..."

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed. Updating..."
    brew update
fi

# Install Flutter
echo "Installing Flutter..."
brew install --cask flutter

# Install Dart (usually comes with Flutter, but ensuring it's installed)
echo "Installing Dart..."
brew install dart

# Install VS Code (optional, but recommended)
echo "Installing Visual Studio Code..."
brew install --cask visual-studio-code

# Install CocoaPods (required for iOS development)
echo "Installing CocoaPods..."
if ! command -v pod &> /dev/null; then
    echo "Attempting to install CocoaPods using gem..."
    sudo gem install cocoapods --verbose
    
    if [ $? -ne 0 ]; then
        echo "gem install cocoapods failed. Trying alternative method using Homebrew..."
        brew install cocoapods
        
        if [ $? -ne 0 ]; then
            echo "CocoaPods installation failed. Please try installing it manually later."
            echo "You can use 'sudo gem install cocoapods' or 'brew install cocoapods'"
        else
            echo "CocoaPods installed successfully using Homebrew."
        fi
    else
        echo "CocoaPods installed successfully using gem."
    fi
else
    echo "CocoaPods is already installed."
fi

# Run platform-specific setup scripts
echo "Running Android setup script..."
./setup-android.sh

echo "Running iOS setup script..."
./setup-ios.sh

echo "Setup complete! You're ready to start developing your Flutter app."
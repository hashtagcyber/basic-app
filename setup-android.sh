#!/bin/bash

# Setup script for Android development environment

echo "Setting up Android development environment..."

# Install Android Studio
echo "Installing Android Studio..."
brew install --cask android-studio

# Install Java Development Kit (JDK)
echo "Installing JDK..."
#brew install --cask adoptopenjdk
brew install --cask temurin
# Set up Android SDK
echo "Setting up Android SDK..."
echo "Please open Android Studio and follow the setup wizard to install the Android SDK."
echo "After installation, make sure to set the ANDROID_HOME environment variable in your ~/.zshrc or ~/.bash_profile:"
echo "export ANDROID_HOME=\$HOME/Library/Android/sdk"
echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"

echo "Android setup complete. Please restart your terminal after setting up environment variables."
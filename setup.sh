# Function to install Homebrew if it's not installed
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed."
  fi
}

# Function to check if an application exists on the system
check_app_exists() {
  app_name=$1
  # Convert the search term to a case-insensitive format and replace hyphens with spaces
  search_name=$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | tr '-' ' ')
  if mdfind "kMDItemKind == 'Application'" | grep -i "$search_name.app" &> /dev/null; then
    return 0
  else
    return 1
  fi
}

# Function to install multiple applications
install_applications() {
  APPLICATIONS=(
    notion
    slack
    discord
    google-chrome
    clickup
  )

  echo "Installing applications..."
  for app in "${APPLICATIONS[@]}"; do
    if brew list --cask "$app" &> /dev/null || check_app_exists "$app"; then
      echo "$app is already installed."
    elif check_app_exists "$app"; then
      echo "$app is already installed on the system."
    else
      echo "Installing $app..."
      brew install --cask "$app"
    fi
  done
}

# Run the functions
install_homebrew
install_applications

# Close the terminal after installation
close_terminal() {
  osascript -e 'tell application "Terminal" to close first window' & exit
}

close_terminal

# Additional configurations can go here

# Source the script to apply changes
source ~/.zshrc
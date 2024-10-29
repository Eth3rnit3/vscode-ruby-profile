#!/usr/bin/env bash

PROFILE_NAME="RubyProfile"

GEM_CONFIG_FILE="$HOME/.vscode/RubyProfile/Gemfile"
LINUX_VSCODE_FOLDER="$HOME/.config/Code"
MAC_VSCODE_FOLDER="$HOME/Library/Application Support/Code"
SHELL_NAME=$(basename "$SHELL")
CONFIG_FILE=""

# Detect the shell and set the configuration file
if [ "$SHELL_NAME" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    echo "Unsupported shell. Only bash and zsh are supported."
    exit 1
fi

# Detect the VS Code configuration folder
if [ -d "$LINUX_VSCODE_FOLDER" ]; then
    VSCODE_USER_FOLDER="$LINUX_VSCODE_FOLDER"
elif [ -d "$MAC_VSCODE_FOLDER" ]; then
    VSCODE_USER_FOLDER="$MAC_VSCODE_FOLDER"
else
    echo "Visual Studio Code folder not found."
    exit 1
fi

# Detect the OS to use the correct sed syntax
OS_TYPE=$(uname)
if [ "$OS_TYPE" = "Darwin" ]; then
    SED_COMMAND="sed -i ''"
else
    SED_COMMAND="sed -i"
fi

PROFILE_FOLDER="$VSCODE_USER_FOLDER/profiles/$PROFILE_NAME"

install() {
    mkdir -p "$PROFILE_FOLDER"

    cp settings.json "$PROFILE_FOLDER/settings.json"

    EXTENSIONS=(
        "Shopify.ruby-lsp"
        "Shopify.ruby-extensions-pack"
        "emmanuelbeziat.vscode-great-icons"
        "ms-vscode.sublime-keybindings"
        "dbaeumer.vscode-eslint"
    )

    code --profile "$PROFILE_NAME" --user-data-dir "$PROFILE_FOLDER/data"
    sleep 2
    for EXT in "${EXTENSIONS[@]}"; do
        code --install-extension "$EXT" --profile "$PROFILE_NAME" --user-data-dir "$PROFILE_FOLDER/data"
    done

    mkdir -p "$GEM_CONFIG_FILE"
    cp Gemfile "$GEM_CONFIG_FILE/Gemfile"
    current_dir=$(pwd)
    cd "$GEM_CONFIG_FILE"
    bundle install
    cd "$current_dir"
    {
        echo ""
        echo "r_code() {"
        echo "  code --user-data-dir \"$PROFILE_FOLDER/data\" --profile $PROFILE_NAME \$@"
        echo "}"
        echo ""
    } >> "$CONFIG_FILE"
    source "$CONFIG_FILE"

    echo "The profile $PROFILE_NAME has been successfully created at $PROFILE_FOLDER with the specified extensions and configurations."
    echo "You can now use the r_code function to open Visual Studio Code with the RubyProfile."
    $SHELL
}

uninstall() {
    rm -rf "$PROFILE_FOLDER"
    # Delete the r_code function from the configuration file
    $SED_COMMAND "/r_code()/,+2d" "$CONFIG_FILE"
    source "$CONFIG_FILE"
    echo "The profile $PROFILE_NAME has been successfully removed."
    $SHELL
}

if [ "$1" = "install" ]; then
    # Run zsh setup.sh install # (zsh)
    # Run setup.sh install # (bash)
    install
elif [ "$1" = "uninstall" ]; then
    # Run zsh setup.sh uninstall # (zsh)
    # Run setup.sh uninstall # (bash)
    uninstall
else
    echo "Invalid argument. Please use 'install' or 'uninstall'."
    exit 1
fi

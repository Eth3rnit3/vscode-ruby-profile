# Setting up a Ruby Development Environment with VSCode

This guide explains how to set up a clean, isolated Ruby development environment using VSCode with proper linting, formatting, and Ruby LSP support.

## Prerequisites

- Ruby installed (recommended versions: 2.7+ for legacy projects, 3.0+ for new projects)
- VSCode installed
- Bundler gem installed (`gem install bundler`)
- Git Bash (for Windows users)

## Automated Setup

```bash
# Clone the repository
git clone https://github.com/Eth3rnit3/vscode-ruby-profile

# Enter the directory
cd vscode-ruby-profile

# Make the script executable
chmod +x setup.sh

# For zsh users
zsh setup.sh install
# OR for bash users
./setup.sh install
```

## Manual Setup

### 1. Create VSCode Profile Structure

Create the following directory structure based on your OS:

**macOS**:
```bash
mkdir -p ~/Library/Application\ Support/Code/profiles/RubyProfile
```

**Linux**:
```bash
mkdir -p ~/.config/Code/profiles/RubyProfile
```

### 2. Install Required VSCode Extensions

Install the following extensions for Ruby development:
- Shopify.ruby-lsp (Ruby language server)
- Shopify.ruby-extensions-pack (Ruby tooling bundle)
- emmanuelbeziat.vscode-great-icons (File icons)
- ms-vscode.sublime-keybindings (Optional: Sublime Text keybindings)
- dbaeumer.vscode-eslint (JavaScript/TypeScript linting)

### 3. Configure Ruby Gems

Create a Gemfile in `~/.vscode/profiles/RubyProfile/` with the following content:

```ruby
source 'https://rubygems.org'

gem 'rubocop'
gem 'rubocop-packaging'
gem 'rubocop-performance'
gem 'rubocop-rspec'
gem 'rubocop-shopify'
gem 'rubocop-thread_safety'
gem 'ruby-lsp'
```

Then install the gems:
```bash
cd ~/.vscode/profiles/RubyProfile
bundle install
```

# Setting up a Ruby Development Environment with VSCode

[Previous content remains the same until the VSCode Settings section]

### 4. Configure VSCode Settings

Create a `settings.json` file in your profile directory with the following content:

```json
{
  "rubyLsp.bundleGemfile": "${userHome}/.vscode/profiles/RubyProfile/Gemfile",
  "workbench.colorTheme": "Spinel",
  "[ruby]": {
    "editor.defaultFormatter": "Shopify.ruby-lsp",
    "editor.formatOnSave": true,
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "editor.semanticHighlighting.enabled": true,
    "editor.formatOnType": false
  }
}
```

**Important Note About Theme**: 
While the settings specify "Spinel" as the default theme, you'll need to manually install and apply it. We strongly recommend using either:
- Spinel (Dark theme)
- Spinel Light (Light theme)

These themes are specifically optimized for Ruby syntax highlighting and provide better visual distinction for Ruby code elements. To install the theme:
1. Open VSCode Command Palette (Cmd/Ctrl + Shift + P)
2. Type "Install Extensions"
3. Search for "Spinel Theme"
4. Install and apply the theme variant of your choice

### 5. Create Shell Function

Add the following function to your shell configuration file (`~/.zshrc` for zsh or `~/.bashrc` for bash):

**For macOS**:
```bash
r_code() {
  code --user-data-dir "$HOME/Library/Application Support/Code/profiles/RubyProfile/data" --profile RubyProfile $@
}
```

**For Linux**:
```bash
r_code() {
  code --user-data-dir "$HOME/.config/Code/profiles/RubyProfile/data" --profile RubyProfile $@
}
```

Reload your shell configuration:
```bash
source ~/.zshrc  # or source ~/.bashrc for bash users
```

## Usage

After setup, you can open VSCode with the Ruby profile using:
```bash
r_code [path]
```

This will launch VSCode with all Ruby-specific settings and extensions loaded.

## Additional Recommendations

1. For Rails projects, consider adding these gems to your project's Gemfile:
```ruby
group :development do
  gem 'rubocop-rails'
end
```

2. Create a `.rubocop.yml` in your project root to customize Ruby style enforcement.

3. If working with different Ruby versions across projects, consider using a Ruby version manager like `rbenv` or `rvm`.

## Troubleshooting

1. If the LSP isn't working, ensure:
   - The Gemfile path in settings.json matches your system's home directory
   - All gems are properly installed via Bundler
   - The ruby-lsp extension is installed and enabled

2. If formatting isn't working on save:
   - Check that the ruby-lsp extension is set as the default formatter
   - Verify that "Format on Save" is enabled in the Ruby settings

3. For permission issues:
   - Check that the profile directory and its contents are owned by your user
   - Ensure the setup script has execute permissions

4. If the theme is not applied:
   - Verify that the Shopify.ruby-extensions-pack is installed from the VSCode marketplace
   - Manually set the theme via Command Palette: Cmd/Ctrl + Shift + P > "Preferences: Color Theme" > Select "Spinel" or "Spinel Light"
   - The theme setting in settings.json will then persist for future sessions
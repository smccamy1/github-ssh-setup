# GitHub SSH Setup for Ubuntu

A simple interactive script to set up SSH authentication for GitHub on Ubuntu/Linux systems.

## Why This Script?

When setting up a new Ubuntu server or WSL environment, you need SSH keys to authenticate with GitHub. But to clone your repositories (including this one), you need to be authenticated first. This creates a chicken-and-egg problem.

**Solution:** This repository is public, so you can download the script without authentication, run it, and then access all your other repositories.

## Quick Start

### Download and Run (Ubuntu/WSL)

```bash
# Download the script
wget https://raw.githubusercontent.com/smccamy1/github-ssh-setup/main/setup-github-ssh.sh

# Make it executable
chmod +x setup-github-ssh.sh

# Run it
./setup-github-ssh.sh
```

### Alternative Download Method

If `wget` is not available:

```bash
curl -o setup-github-ssh.sh https://raw.githubusercontent.com/smccamy1/github-ssh-setup/main/setup-github-ssh.sh
chmod +x setup-github-ssh.sh
./setup-github-ssh.sh
```

## What The Script Does

1. **Checks for existing SSH keys** - Won't overwrite if you already have them
2. **Generates a new ED25519 key** - If you don't have one (more secure than RSA)
3. **Displays your public key** - With clear instructions on copying it
4. **Guides you through GitHub setup** - Step-by-step instructions
5. **Tests the connection** - Verifies everything is working
6. **Configures Git** - Sets up your name and email for commits

## Features

- ✅ Safe - detects and preserves existing keys
- ✅ Interactive - guides you through each step
- ✅ Color-coded output - easy to follow
- ✅ Error handling - won't break your system
- ✅ Connection testing - confirms authentication works

## Requirements

- Ubuntu/Linux or WSL
- `ssh-keygen` (usually pre-installed)
- `ssh-agent` (usually pre-installed)
- Internet connection
- A GitHub account

## What You'll Need

- Your GitHub email address
- Access to https://github.com/settings/keys in a browser

## After Setup

Once authenticated, you can clone your repositories:

```bash
git clone git@github.com:username/repository.git
```

## Troubleshooting

### "Connection test failed"

- Make sure you copied the **entire** public key (including `ssh-ed25519` at the start)
- Verify you added it to GitHub at https://github.com/settings/keys
- Check your internet connection
- Wait a minute and try running the script again

### "Permission denied"

If you get permission errors when trying to clone:

```bash
# Make sure your SSH key is loaded
ssh-add ~/.ssh/id_ed25519

# Test connection
ssh -T git@github.com
```

### Script won't run

```bash
# Make sure it's executable
chmod +x setup-github-ssh.sh

# If you get "command not found", use:
bash setup-github-ssh.sh
```

## Security

- The script generates ED25519 keys (recommended by GitHub)
- Your private key never leaves your machine
- Only the public key is added to GitHub
- No passwords or sensitive data are stored

## License

MIT - Feel free to use and modify

## Author

Stephen McCamy

---

**Note:** This is a bootstrap tool. Once you've set up SSH authentication using this script, you can clone your other repositories (including private ones) normally.

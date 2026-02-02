#!/bin/bash

# GitHub SSH Authentication Setup Script for Ubuntu/Linux
# This script helps you set up SSH authentication for GitHub

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║       GitHub SSH Authentication Setup for Ubuntu          ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if SSH keys already exist
if [ -f ~/.ssh/id_ed25519 ] || [ -f ~/.ssh/id_rsa ]; then
    echo -e "${YELLOW}⚠️  SSH keys already exist!${NC}"
    echo ""
    echo "Found existing keys:"
    ls -la ~/.ssh/id_* 2>/dev/null || true
    echo ""
    read -p "Do you want to use the existing key? (y/n): " use_existing
    
    if [ "$use_existing" = "y" ] || [ "$use_existing" = "Y" ]; then
        echo -e "${GREEN}✅ Using existing SSH key${NC}"
        SKIP_GENERATION=true
    else
        echo -e "${YELLOW}Creating a new SSH key...${NC}"
        SKIP_GENERATION=false
    fi
else
    echo -e "${CYAN}No SSH keys found. Creating a new one...${NC}"
    SKIP_GENERATION=false
fi

echo ""

# Generate new SSH key if needed
if [ "$SKIP_GENERATION" != "true" ]; then
    read -p "Enter your GitHub email address: " github_email
    
    echo ""
    echo -e "${CYAN}Generating SSH key...${NC}"
    
    ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
    
    echo -e "${GREEN}✅ SSH key generated successfully!${NC}"
    echo ""
fi

# Determine which key to use
if [ -f ~/.ssh/id_ed25519 ]; then
    SSH_KEY_PATH=~/.ssh/id_ed25519
    SSH_PUB_KEY=~/.ssh/id_ed25519.pub
elif [ -f ~/.ssh/id_rsa ]; then
    SSH_KEY_PATH=~/.ssh/id_rsa
    SSH_PUB_KEY=~/.ssh/id_rsa.pub
else
    echo -e "${RED}❌ No SSH key found!${NC}"
    exit 1
fi

# Start SSH agent and add key
echo -e "${CYAN}Starting SSH agent and adding key...${NC}"
eval "$(ssh-agent -s)" > /dev/null
ssh-add "$SSH_KEY_PATH" 2>/dev/null

echo -e "${GREEN}✅ SSH key added to agent${NC}"
echo ""

# Display public key
echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║                   YOUR PUBLIC SSH KEY                      ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Copy this entire key (including ssh-ed25519 and your email):${NC}"
echo ""
echo -e "${CYAN}$(cat $SSH_PUB_KEY)${NC}"
echo ""
echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Instructions
echo -e "${CYAN}📝 Next Steps:${NC}"
echo ""
echo "1. Copy the key above (select and Ctrl+Shift+C)"
echo ""
echo "2. Go to GitHub in your browser:"
echo -e "   ${GREEN}https://github.com/settings/keys${NC}"
echo ""
echo "3. Click ${YELLOW}'New SSH key'${NC}"
echo ""
echo "4. Give it a title (e.g., 'Ubuntu Server')"
echo ""
echo "5. Paste your key and click ${YELLOW}'Add SSH key'${NC}"
echo ""

read -p "Press Enter when you've added the key to GitHub..."

echo ""
echo -e "${CYAN}Testing GitHub connection...${NC}"
echo ""

# Test connection
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo -e "${GREEN}✅ SUCCESS! You are authenticated with GitHub!${NC}"
    echo ""
    
    # Configure git if needed
    if ! git config --global user.email > /dev/null 2>&1; then
        echo -e "${CYAN}Configuring Git...${NC}"
        read -p "Enter your name for Git commits: " git_name
        read -p "Enter your email for Git commits: " git_email
        
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        
        echo -e "${GREEN}✅ Git configured${NC}"
        echo ""
    fi
    
    echo -e "${CYAN}You can now clone repositories using SSH:${NC}"
    echo ""
    echo "  git clone git@github.com:username/repository.git"
    echo ""
    echo -e "${GREEN}All set! 🎉${NC}"
    
else
    echo -e "${RED}❌ Connection test failed${NC}"
    echo ""
    echo "Please check that you:"
    echo "  1. Copied the entire SSH key correctly"
    echo "  2. Added it to GitHub (https://github.com/settings/keys)"
    echo "  3. Have internet connectivity"
    echo ""
    echo "Try running this script again after adding the key."
fi

echo ""

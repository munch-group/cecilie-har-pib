#!/usr/bin/env bash

echo ""
echo "Log into GitHub through the browser using a one-time code"
gh auth login --hostname github.com -p ssh --skip-ssh-key --web --scopes "admin:public_key,repo,read:org"

filename="$HOME/.ssh/id_ed25519"

echo "Generatig SSH key"
if [[ ! -f "$filename" ]]; then
    ssh-keygen -t ed25519 -f "$filename" -N ""
fi

echo "Starting ssh-agent"
eval "$(ssh-agent -s)"
echo "Adding key"
ssh-add "$filename"

echo "Adding key to GitHub using gh CLI"
gh ssh-key add "$filename.pub" --title "My SSH key"

echo "Testing the ssh connection"
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "Success! GitHub SSH is working"
else
    echo "Setting up GitHub SSH failed"
fi
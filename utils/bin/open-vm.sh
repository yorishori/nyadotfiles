#!/bin/bash

# Check if a VM name was provided
if [ -z "$1" ]; then
    echo "Specify the name of the vm... >.<"
    exit 1
fi

VM_NAME=$1
URI="qemu:///system"

echo "Let me check for $VM_NAME..."

STATE=$(virsh -c $URI domstate "$VM_NAME" 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Couldn't find '$VM_NAME'... >~<"
    exit 1
fi

# 2. Start the VM if it's not running
if [ "$STATE" != "running" ]; then
    echo "Found it! Let's see if it turns on... >o<"
    virsh -c $URI start "$VM_NAME"
else
    echo "It's already running, gonna start the viewer then... o_o"
fi

echo "Let's see if you left a viewer open... ^^"
pkill -f "virt-viewer.*$VM_NAME"

virt-viewer -c $URI --attach --wait -f "$VM_NAME" > /dev/null 2>&1 &
echo "Let's get it spinning... \(0 o0)/"

echo "\nPress any key to close :)"
#disown
read -r

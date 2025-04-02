#!/usr/bin/env zsh

# Helper function to print status messages
function _oh_my_sdk_print_status() {
    local type="$1"
    local message="$2"
    
    case "${type}" in
        "info")
            echo "ℹ️  ${message}"
            ;;
        "success")
            echo "✅ ${message}"
            ;;
        "warning")
            echo "⚠️  ${message}"
            ;;
        "error")
            echo "❌ ${message}"
            ;;
        *)
            echo "${message}"
            ;;
    esac
} 
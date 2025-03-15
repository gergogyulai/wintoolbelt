# 🛠 wintoolbelt

To execute **wintoolbelt**, run this in PowerShell:
```
irm https://wtb.gergo.cc | iex
```

## Overview
**wintoolbelt** is a collection of tools designed to clean up and refresh public school PCs. It helps to delete user data, browser profiles, and unnecessary files, ensuring a clean slate every time you sit down. It also provides additional features for managing the veyon service.

## 🧰 Available Tools

### 🧹 Cleanup Tool (wipe)
The cleanup tool is the main feature of **wintoolbelt**. It deletes user data, browser profiles, and unnecessary files from the system. 

#### What it cleans
- **Browser Data** 🌐
  - Google Chrome
  - Brave
  - Mozilla Firefox
  - Microsoft Edge

- **User Folders** 📁
  - Desktop
  - Documents
  - Downloads
  - Pictures
  - Music
  - Videos
  - 3D Objects
  - Also removes every folder and file in the user's profile directory that is not a system folder
  
- **Development Tools** 💻
  - VS Code profiles
  - VS Code extensions
  - Configuration files (.gitconfig, .bashrc, etc.)

### 🎮 Veyon Tool (veyon)
Take control of the Veyon service with this tool. It allows you to start, stop, enable, and disable the service.

## 🚀 Usage

### Recommended Usage
To quickly execute **wintoolbelt**, run the following command in PowerShell:
```
irm https://wtb.gergo.cc | iex
```
If the recommended URL is unavailable, you can use the following alternative:
```
irm https://raw.githubusercontent.com/gergogyulai/winwipe/refs/heads/main/public/menu.ps1 | iex
```
This will execute the latest version of the tool selector directly from the repo.

### Specific Tasks
If you need to run specific tools, use these URLs:
- **veyon only**: `irm https://wtb.gergo.cc/veyon | iex`
- **wipe only**: `irm https://wtb.gergo.cc/wipe | iex`

### Running Manually
If none of the hosted versions of the script are working, you can run it directly from your computer:
```
git clone https://github.com/gergogyulai/wintoolbelt
cd wintoolbelt/public
./menu.ps1
```

## ⚠️ Warning
- This script **permanently deletes** user files. Ensure you do not run it on a personal machine or any device where data loss is a concern.
- Running this script may require administrative privileges.

## 📜 License
This project is released under the MIT License. For more information, see the [LICENSE](LICENSE) file.
# 🧹 WinWipe

To execute **winwipe**, run this in PowerShell:
```
irm https://winwipe.gergo.cc | iex
```

## Overview
**WinWipe** is a PowerShell script designed to remove unnecessary user files from public school PCs, providing a clean slate every time you sit down. It ensures that personal data, browser profiles, and user-specific configurations are wiped, leaving only essential system files.

## ✨ Features
- 🚫 Deletes all profiles and data for:
  - Google Chrome 🌐
  - Brave 🦁
  - Mozilla Firefox 🦊
  - Microsoft Edge 🎭
- 🗑 Wipes everything from the current user's folders:
  - Desktop 🖥
  - Documents 📄
  - Downloads ⬇️
  - Pictures 🖼
  - Music 🎵
  - Videos 🎥
  - 3D Objects 🏗
- 🔥 Removes all files in the user's directory except:
  - `Desktop`
  - `Documents`
  - `Downloads`
  - `Pictures`
  - `Music`
  - `Videos`
  - `3D Objects`
  - `AppData`
- 🛠 Deletes Visual Studio Code profiles, extensions, and configuration files.

## 🚀 Usage

### Recommended usage
To quickly execute **winwipe**, run the following command in PowerShell:
```
irm https://winwipe.gergo.cc | iex
```
This will execute the latest version of the script directly from the repo.

### Backup URL
If the main URL is unavailable, you can use the following alternative:
```
irm https://raw.githubusercontent.com/gergogyulai/winwipe/refs/heads/main/public/wipe.ps1 | iex
```
### Running Manual
If none of the hosted versions of the script are working, you can run it directly from you computer
```
git clone https://github.com/gergogyulai/winwipe
cd winwipe/public
./wipe.ps1
```

## ⚠️ Warning
- This script **permanently deletes** user files. Ensure you do not run it on a personal machine or any device where data loss is a concern.
- Running this script may require administrative privileges.

## 📜 License
This project is released under the MIT License.


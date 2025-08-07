## RyzenAdj Indicator GNOME Extension


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GNOME Shell](https://img.shields.io/badge/GNOME-45%2B-blue)](https://www.gnome.org)
[![Made by feldkaresz](https://img.shields.io/badge/made%20by-feldkaresz-lightgrey)](https://github.com/feldkaresz)

A minimal GNOME Shell extension for displaying and controlling the **STAPM, fast and slow power limits** of AMD Ryzen CPUs using [`ryzenadj`](https://github.com/FlyGoat/RyzenAdj).

This extension adds a simple indicator to the top bar that shows the current power limit and allows you to toggle between predefined wattage values (e.g., low-power mode and performance mode) with a click.


Tested on Ubuntu 24.04 LTS + GNOME 46
---

## ✨ Features

- 🔋 Shows current `STAPM LIMIT` (e.g., `35 W`) directly in the top bar
- ⚡ Switch between custom profiles by clicking the indicator
- 🧠 Reads values directly from `ryzenadj` (no refresh loop — always accurate after change)
- 🔐 Passwordless use via safe `sudoers` rule
- ✅ Compatible with **GNOME 45+** and **GNOME 46** (ES module format)

---

### 💡 Use Cases

- **Laptop users** who want to easily manage power and thermals
- Quickly switch between **low-power and high-performance modes**
- Visual feedback of current CPU wattage limit at a glance

---

## 📷 Screenshot

> _Coming soon..._

---

## 📦 Installation

Clone or download this repository:

git clone https://github.com/feldkaresz/fk_dev.git

---

## I. Install ryzenadj:

sudo apt install git build-essential cmake

sudo apt install libpci-dev

git clone https://github.com/FlyGoat/RyzenAdj.git

cd RyzenAdj

mkdir build && cd build

cmake ..

make -j$(nproc)

sudo make install

---

## II: Testing (and geting default settings)

sudo ryzenadj --info

---

## III. Testing (setting new power consumption values)

e.g.: 

sudo ryzenadj --stapm-limit=21000 --fast-limit=21000 --slow-limit=21000


Check if modified:

sudo ryzenadj --info

---

## IV. Create a systemd service to apply your settings on boot

If you want ryzenadj to set your values automatically on boot.

sudo nano /etc/systemd/system/ryzenadj.service


copy&paste: 
---

[Unit]

Description=RyzenAdj power limit
After=multi-user.target

[Service]

ExecStart=/usr/local/bin/ryzenadj --stapm-limit=21000 --fast-limit=21000 --slow-limit=21000
Restart=always
User=root

[Install]

WantedBy=multi-user.target
---

sudo systemctl daemon-reload

sudo systemctl enable ryzenadj.service

sudo systemctl start ryzenadj.service


check status:

sudo systemctl status ryzenadj.service

---

## V. Setup ryzenadj-indicator GNOME extension
 
copy 'ryzenadj-indicarot@feldvebel.hu' folder to:

~/.local/share/gnome-shell/extensions


sudo chmod 777 ~/.local/share/gnome-shell/extensions/ryzenadj-indicator\@feldvebel.hu/extension.js


sudo visudo

paste to the end: username ALL=(ALL) NOPASSWD: /usr/local/bin/ryzenadj



debugging (if needed):

gnome-extensions enable ryzenadj-indicator@feldvebel.hu

journalctl -f -o cat /usr/bin/gnome-shell 

---


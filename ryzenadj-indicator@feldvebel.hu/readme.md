    Set Power Limits with ryzenadj from GNOME extension
    ---------------------------------------------------


    /**
    * Tested on Ubuntu 24.04 LTS + GNOME 46
    */
    

    I.
    ----------------
    Install ryzenadj:
    -----------------
    sudo apt install git build-essential cmake
    sudo apt install libpci-dev

    git clone https://github.com/FlyGoat/RyzenAdj.git
    cd RyzenAdj
    mkdir build && cd build
    cmake ..
    make -j$(nproc)
    sudo make install


    II:
    -------------------------------------
    Testing (and geting default settings)
    -------------------------------------
    sudo ryzenadj --info


    III.
    ----------------------------------------------
    Testing (setting new power consumption values)
    ----------------------------------------------
    e.g.: sudo ryzenadj --stapm-limit=21000 --fast-limit=21000 --slow-limit=21000
    Check if modified:
    sudo ryzenadj --info


    IV.
    -------------------------------------------------------
    Create a systemd service to apply your settings on boot
    -------------------------------------------------------
    If you want ryzenadj to set your values automatically on boot.

    sudo nano /etc/systemd/system/ryzenadj.service

    copy&paste: 
    -----
    [Unit]
    Description=RyzenAdj power limit
    After=multi-user.target

    [Service]
    ExecStart=/usr/local/bin/ryzenadj --stapm-limit=21000 --fast-limit=21000 --slow-limit=21000
    Restart=always
    User=root

    [Install]
    WantedBy=multi-user.target
    ----

    sudo systemctl daemon-reload
    sudo systemctl enable ryzenadj.service
    sudo systemctl start ryzenadj.service

    check status:
    sudo systemctl status ryzenadj.service


    V.
    ----------------------------------------
    Setup ryzenadj-indicator GNOME extension
    ---------------------------------------- 
    copy 'ryzenadj-indicarot@feldvebel.hu' folder to:
    ~/.local/share/gnome-shell/extensions
    
    sudo chmod 777 ~/.local/share/gnome-shell/extensions/ryzenadj-indicator\@feldvebel.hu/extension.js
    
    sudo visudo
    paste to the end: username ALL=(ALL) NOPASSWD: /usr/local/bin/ryzenadj
    

    debugging (if needed):
    gnome-extensions enable ryzenadj-indicator@feldvebel.hu
    journalctl -f -o cat /usr/bin/gnome-shell 



    
    copy 'ryzenadj-indicarot@feldvebel.hu' folder to:
    ~/.local/share/gnome-shell/extensions
    
    sudo chmod 777 ~/.local/share/gnome-shell/extensions/ryzenadj-indicator\@feldvebel.hu/extension.js
    
    sudo visudo
    paste to the end: username ALL=(ALL) NOPASSWD: /usr/local/bin/ryzenadj
    
    debugging:
    gnome-extensions enable ryzenadj-indicator@feldvebel.hu
    
    journalctl -f -o cat /usr/bin/gnome-shell 



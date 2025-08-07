/*
    Toggle between two power consumption modes:


    Add this code to extension.js renderMenu() function.
    This will create a new menu-item in the dropdown menu.
    -----
    
        const toggleItem = new PopupMenuItem('Toggle Power Mode');
        toggleItem.connect('activate', () => {
            GLib.spawn_command_line_async('/usr/local/bin/ryzen-toggle');
        });
        this.menu.addMenuItem(toggleItem);
    
    -----
    Modify the value of low_cmd and high_cmd accordingly in this code, below. 
    The default values works fine with a laptop using AMD Ryzen 7 5700U processor.

    Run these commands in terminal:
    sudo gcc -o ryzen-toggle ./.local/share/gnome-shell/extensions/ryzenadj-indicator@feldvebel.hu/ryzen-toggle.c 
    sudo chown root:root /usr/local/bin/ryzen-toggle
    sudo chown root:root /usr/local/bin/ryzen-toggle 
    sudo chmod 4755 /usr/local/bin/ryzen-toggle 

    Log out and log in again to restart GNOME (or use ALT + F2 then 'r')
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define STATE_FILE "/tmp/ryzenadj_state"

int main() {
    const char *low_cmd = "sudo /usr/local/bin/ryzenadj --stapm-limit=21000 --fast-limit=21000 --slow-limit=21000";
    const char *high_cmd = "sudo /usr/local/bin/ryzenadj --stapm-limit=25000 --fast-limit=40000 --slow-limit=37500";

    FILE *f = fopen(STATE_FILE, "r");
    int is_high = 0;

    if (f) {
        char buf[10];
        fgets(buf, sizeof(buf), f);
        if (strncmp(buf, "high", 4) == 0)
            is_high = 1;
        fclose(f);
    }

    const char *cmd_to_run = is_high ? low_cmd : high_cmd;
    const char *next_state = is_high ? "low" : "high";

    int result = system(cmd_to_run);
    if (result != 0) {
        fprintf(stderr, "Failed to run command: %s\n", cmd_to_run);
        return 1;
    }

    f = fopen(STATE_FILE, "w");
    if (f) {
        fputs(next_state, f);
        fclose(f);
    }

    return 0;
}

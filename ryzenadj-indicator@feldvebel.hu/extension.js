/**
 * Modifying CPU power consumption may cause damage to your computer.
 * Know what you are doing!
 * USE IT AT YOUR OWN RISK
*/

'use strict';

import GLib from 'gi://GLib';
import St from 'gi://St';
import Clutter from 'gi://Clutter';
import GObject from 'gi://GObject';

import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';

import { Button } from 'resource:///org/gnome/shell/ui/panelMenu.js';
import { PopupMenuItem } from 'resource:///org/gnome/shell/ui/popupMenu.js';
import { panel } from 'resource:///org/gnome/shell/ui/main.js';

export class RyzenAdjIndicator extends Button {

    _init() {
        super._init(0.0, 'RyzenAdj Indicator', false);

        /**
         * Change these values according to your Ryzen CPU
         * The default settings works fine with AMD Ryzen 7 5700U
         * 
         * e.g.: ["name", stapm-limit value, fast-limit value, slow-limit value]
         * 
         * this.powerVal = [
                ["low", 10000, 10000, 10000],
                ["optimal", 21000, 21000, 21000],
                ["max", 25000, 40000, 37500]
            ];
         */
        this.powerVal = [
                ["low", 10000, 10000, 10000],
                ["optimal", 21000, 21000, 21000],
                ["max", 25000, 40000, 37500]
            ];
        /* -------------------------------------------- */


        this.box = new St.BoxLayout();
        this.label = new St.Label({
            text: 'STAPM',
            y_align: Clutter.ActorAlign.CENTER,
            style: 'margin-right: 12px;',
        });
        this.box.add_child(this.label);
        this.add_child(this.box);

        this._renderMenu();
    }

    _renderMenu() {
        this.menu.removeAll();

        const stapm = this._readStapm();

        this.label.set_text("Limit: " + stapm + " W");

        /*
        const stapmItem = new PopupMenuItem(`Current: ${stapm ?? "?"} W`, {
            reactive: false,
        });
        this.menu.addMenuItem(stapmItem);
        this.menu.addMenuItem(new PopupMenuItem('────────────'));
        */

        for (const val of this.powerVal) {
            const item = new PopupMenuItem(val[0]);
            item.connect('activate', () => this._setStapm(val));
            this.menu.addMenuItem(item);
        }
    }

    _readStapm() {
        try {
            const [ok, out] = GLib.spawn_command_line_sync('sudo ryzenadj -i');
            if (ok && out) {
                const output = new TextDecoder("utf-8").decode(out);
                const match = this.parseStapmValue(output);
                if (match) {
                    return match;
                }
            }
        } catch (e) {
            console.log("read error" + e);
            console.error(`RyzenAdj read error: ${e}`);
        }
        return null;
    }

    _setStapm(value) {

        if(value == null){
            return false;
        }
        
        let limit_command = `sudo /usr/local/bin/ryzenadj 
        --stapm-limit=${value[1]} 
        --fast-limit=${value[2]} 
        --slow-limit=${value[3]}`;

        //GLib.spawn_command_line_async(`sudo ryzenadj --stapm-limit=${value}`);
        GLib.spawn_command_line_async(limit_command);

        this._renderMenu();
    }

    parseStapmValue(output) {
    const lines = output.split('\n');
    for (let line of lines) {
        if (line.includes('fast-limit')) {
            // Example line: "| STAPM LIMIT | 35.000 | stapm-limit"
            const parts = line.split('|');
            if (parts.length >= 2) {
                const valueStr = parts[2].trim().substring(0,2); // "35"
                //console.log("function value: " + valueStr);
                return valueStr;
            }
        }
    }
    return null;
}

}

GObject.registerClass({ GTypeName: 'RyzenAdjIndicator' }, RyzenAdjIndicator);

export default class RyzenAdjExtension extends Extension {
    _indicator;

    enable() {
        this._indicator = new RyzenAdjIndicator();
        panel.addToStatusArea('ryzenadj-indicator', this._indicator);
    }

    disable() {
        this._indicator?.destroy();
        this._indicator = undefined;
    }
}

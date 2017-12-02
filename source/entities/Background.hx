package entities;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class Background extends FlxGroup {

    public function new() {
        super();

        var x = 0., y = 0., y_incr = 0.;

        while (y < FlxG.height) {
            x = 0;
            while (x < FlxG.width) {
                var sprite = new FlxSprite(x, y, "assets/images/bg.png");
                sprite.x -= (Main.global_scale * sprite.width) / 4;
                sprite.y -= (Main.global_scale * sprite.height) / 4;
                sprite.scale.set(Main.global_scale, Main.global_scale);
                x += Main.global_scale * sprite.width;
                y_incr = Main.global_scale * sprite.height;
                add(sprite);
            }

            y += y_incr;
        }

    }

}

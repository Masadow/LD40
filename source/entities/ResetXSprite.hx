package entities;

import flixel.FlxSprite;
import flixel.FlxG;

class ResetXSprite extends FlxSprite {
    override public function update(elapsed : Float) {
        super.update(elapsed);

        if (x > FlxG.width) {
            x = -80;
        }
    }
}

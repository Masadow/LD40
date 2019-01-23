package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import states.PlayState;

class TouchAction extends FlxSprite {
    public static var SIZE = 150;

    private static var _idx : Int = 0;
    public static var currentColor : FlxColor = GameConst.COLORS[0];

    public function new(x : Float, y : Float)
    {
        super(x, y);
        makeSphere();
    }

    private function makeSphere()
    {
        makeGraphic(SIZE, SIZE, FlxColor.TRANSPARENT, false, "touch_" + GameConst.COLORS[_idx]);

        FlxSpriteUtil.drawCircle(this, -1, -1, 0, GameConst.COLORS[_idx]);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        for (touch in FlxG.touches.list) {
            if (touch.justReleased)
            {
                if (touch.x >= x && touch.x < x + SIZE
                && touch.y >= y && touch.y < y + SIZE)
                {
                    _idx = ++_idx == GameConst.COLORS.length ? 0 : _idx;
                    currentColor = GameConst.COLORS[_idx];
                    makeSphere();
                }
            }
        }
    }
}
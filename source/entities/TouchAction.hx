package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import states.PlayState;

class TouchAction extends FlxSprite {
    public static var SIZE = 150;

    private var _idx : Int;
    private var _color : FlxColor;
    private var _key : Int;
    public static var selected : TouchAction = null;
    private static var _colors : Array<FlxColor> = [FlxColor.RED, FlxColor.MAGENTA, FlxColor.CYAN, FlxColor.ORANGE];
    private static var _keys : Array<Int> = [PlayState.A_KEY, PlayState.S_KEY, PlayState.D_KEY, PlayState.F_KEY];

    public function new(x : Float, y : Float)
    {
        super(x, y);
        _idx = 0;
        makeSphere();
        selected = this;
    }

    private function makeSphere()
    {
        makeGraphic(SIZE, SIZE, FlxColor.TRANSPARENT, false, "touch_" + _colors[_idx]);

        FlxSpriteUtil.drawCircle(this, -1, -1, 0, _colors[_idx]);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        #if FLX_MOUSE
        if (FlxG.mouse.justReleased)
        {
                if (FlxG.mouse.x >= x && FlxG.mouse.x < x + SIZE
                && FlxG.mouse.y >= y && FlxG.mouse.y < y + SIZE)
                {
                    _idx = ++_idx > 3 ? 0 : _idx;
                    makeSphere();
                }
        }
        #end
        for (touch in FlxG.touches.list) {
            if (touch.justReleased)
            {
                if (touch.x >= x && touch.x < x + SIZE
                && touch.y >= y && touch.y < y + SIZE)
                {
                    _idx = ++_idx > 3 ? 0 : _idx;
                    makeSphere();
                }
            }
        }
    }

    public function key() : Int
    {
        return _keys[_idx];
    }
}
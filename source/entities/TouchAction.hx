package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class TouchAction extends FlxSprite {
    public static var SIZE = 150;

    private var _touched : Bool;
    private var _key : Int;

    public function new(x : Float, y : Float, color : FlxColor, keycode : Int)
    {
        super(x, y);
        makeGraphic(SIZE, SIZE, color);
        _touched = false;
        _key = keycode;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        _touched = false;
        #if FLX_MOUSE
        if (FlxG.mouse.justReleased)
        {
                if (FlxG.mouse.x >= x && FlxG.mouse.x < x + SIZE
                && FlxG.mouse.y >= y && FlxG.mouse.y < y + SIZE)
                {
                    _touched = true;
                }
        }
        #end
        for (touch in FlxG.touches.list) {
            if (touch.justReleased)
            {
                if (touch.x >= x && touch.x < x + SIZE
                && touch.y >= y && touch.y < y + SIZE)
                {
                    _touched = true;
                }
            }
        }
    }

    public function touched() : Bool
    {
        return _touched;
    }

    public function key() : Int
    {
        return _key;
    }
}
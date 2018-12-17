package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class TouchAction extends FlxSprite {
    public static var SIZE = 150;

    private var _color : FlxColor;
    private var _key : Int;
    public static var selected : TouchAction = null;

    public function new(x : Float, y : Float, color : FlxColor, keycode : Int, isSelected : Bool = false)
    {
        super(x, y);
        _color = color;
        if (isSelected)
        {
            selected = this;
        }
        makeSphere(isSelected);
        _key = keycode;
    }

    private function makeSphere(isSelected : Bool)
    {
        makeGraphic(SIZE, SIZE, FlxColor.TRANSPARENT, false, "touch_" + _color + isSelected);

        if (isSelected) {
            FlxSpriteUtil.drawCircle(this, -1, -1, 0, _color, {color: FlxColor.BLACK, thickness: 5});
        } else {
            FlxSpriteUtil.drawCircle(this, -1, -1, 0, _color);
        }
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
                    if (selected != null) {
                        selected.makeSphere(false);
                    }
                    selected = this;
                    makeSphere(true);
                }
        }
        #end
        for (touch in FlxG.touches.list) {
            if (touch.justReleased)
            {
                if (touch.x >= x && touch.x < x + SIZE
                && touch.y >= y && touch.y < y + SIZE)
                {
                   if (selected != null) {
                        selected.makeSphere(false);
                    }
                    selected = this;
                    makeSphere(true);
                }
            }
        }
    }

    public function key() : Int
    {
        return _key;
    }
}
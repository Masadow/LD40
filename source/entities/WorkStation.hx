package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

class WorkStation extends FlxSprite
{
    private static var WIDTH = 150;
    private static var HEIGHT = 150;

    private var _color : FlxColor;
    public var key : Int;

    public function new(key : Int, color: FlxColor, ?X:Float = 0)
    {
        super(X, 200);
        this.key = key;
        _color = color;
        redraw();
    }

    public function redraw(selected : Bool = false)
    {
        makeGraphic(WIDTH, HEIGHT, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawPolygon(this, [
                new FlxPoint(0, 0),
                new FlxPoint(WIDTH, 0),
                new FlxPoint(WIDTH / 2, HEIGHT)
            ], selected ? FlxColor.WHITE : FlxColor.BLACK);
        FlxSpriteUtil.drawPolygon(this, [
                new FlxPoint(7, 5),
                new FlxPoint(WIDTH - 7, 5),
                new FlxPoint(WIDTH / 2, HEIGHT - 9)
            ], _color);
    }

    public function select()
    {
        redraw(true);
    }

    public function unselect()
    {
        redraw();
    }
}
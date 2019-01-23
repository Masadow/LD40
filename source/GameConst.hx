package;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class GameConst {
    //Determine the different possibles cupcakes colors
	public static var COLORS = [FlxColor.RED, FlxColor.MAGENTA, FlxColor.CYAN];

    public static var CUPCAKES_PATH = [
        new FlxPoint(-130, 200),
        new FlxPoint(1500, 200),
        new FlxPoint(1500, 430),
        new FlxPoint(130, 430),
        new FlxPoint(130, 660),
        new FlxPoint(1920, 660)
    ];

    //Initial cupcake speed
    public static var SPEED = 130;
}
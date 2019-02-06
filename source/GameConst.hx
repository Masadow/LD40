package;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class GameConst {
    public static var CUPCAKE_WIDTH = 200;
    public static var CUPCAKE_SCALE = 0.8;
    public static var CUPCAKES_GAP = 15;
    public static var SPAWN_GAP = GameConst.CUPCAKE_WIDTH * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP;

    //Determine the different possibles cupcakes colors
	public static var COLORS = [FlxColor.RED, FlxColor.MAGENTA, FlxColor.CYAN];

    public static var CUPCAKES_PATH = [
        new FlxPoint(-50 - (220 * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP), 100),
        new FlxPoint(1740, 100),
        new FlxPoint(1740, 350),
        new FlxPoint(10, 350),
        new FlxPoint(10, 600),
        new FlxPoint(1740, 600),
        new FlxPoint(1740, 850),
        new FlxPoint(-250, 850)
    ];

    //Initial cupcake speed
    public static var SPEED = 600;

}
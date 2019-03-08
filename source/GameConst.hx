package;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;

import entities.bonus.Life;

class GameConst {
    public static var CUPCAKE_WIDTH = 250;
    public static var CUPCAKE_HEIGHT = 250;
    public static var CUPCAKE_SCALE = 0.82;
    public static var CUPCAKES_GAP = 0;
    public static var SPAWN_GAP = GameConst.CUPCAKE_WIDTH * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP;
    public static var BELT_WIDTH = 250;
    public static var BELT_HALF_WIDTH = 20;

    public static var LENGTH_PROBS = [
        18., // 1
        0, // 2
        40, // 3
        24, // 4
        13, // 5
        5, // 6
        0, // 7
        0 // 8 -> Automatically become bonus
    ];

    public static var BONUSES = [
        Life
    ];

    //Determine the different possibles cupcakes colors
	public static var COLORS = [FlxColor.RED, FlxColor.YELLOW, FlxColor.BLUE, FlxColor.GREEN];

    public static var CUPCAKES_PATH = [
        // LEVEL 1
        [
            new FlxPoint(-50 - (220 * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP), 400),
            new FlxPoint(1900, 400)
        ],
        // LEVEL 2
        [
            new FlxPoint(-50 - (220 * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP), 300),
            new FlxPoint(1600, 300),
            new FlxPoint(1600, 800),
            new FlxPoint(-CUPCAKE_WIDTH, 800)
        ],
        // LEVEL 3
        [
            new FlxPoint(1950 + (220 * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP), 300),
            new FlxPoint(1400, 300),
            new FlxPoint(1400, 800),
            new FlxPoint(600, 800),
            new FlxPoint(600, 300),
            new FlxPoint(-CUPCAKE_WIDTH, 300)
        ],
        // LEVEL 4
        [
            new FlxPoint(-50 - (220 * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP), 250),
            new FlxPoint(1600, 250),
            new FlxPoint(1600, 550),
            new FlxPoint(100, 550),
            new FlxPoint(100, 550),
            new FlxPoint(100, 850),
            new FlxPoint(1900, 850)
        ],
        // LEVEL 5
        [
            new FlxPoint(-50 - (220 * GameConst.CUPCAKE_SCALE + GameConst.CUPCAKES_GAP), 100),
            new FlxPoint(1740, 100),
            new FlxPoint(1740, 350),
            new FlxPoint(10, 350),
            new FlxPoint(10, 600),
            new FlxPoint(1740, 600),
            new FlxPoint(1740, 850),
            new FlxPoint(-CUPCAKE_WIDTH, 850)
        ]
    ];

    //Initial cupcake speed
    public static var SPEED = 700;
    public static var BACKWARD_SPEED_FACTOR = 5;
}
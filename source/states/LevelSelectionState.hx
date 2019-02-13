package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.input.FlxPointer;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;


class LevelSelectionState extends FlxState
{
    public var level : Int;
    public var belts : FlxGroup;
    public var arrow_left : FlxSprite;
    public var arrow_right : FlxSprite;
    public var title : FlxText;
    public var start : FlxText;

    public function new(level : Int = 0)
    {
        super();
        PlayState.level = level;
    }

	override public function create():Void
	{
		super.create();

		add(new FlxSprite(0, 0, "assets/images/bg_full.png"));


        belts = new FlxGroup();
        constructBelts();
        add(belts);

        arrow_left = new FlxSprite(50, 50);
        arrow_left.makeGraphic(150, 100, FlxColor.TRANSPARENT, false, "arrow_left");
        FlxSpriteUtil.drawPolygon(arrow_left, [new FlxPoint(0, 50), new FlxPoint(150, 0), new FlxPoint(150, 100)], FlxColor.WHITE);
        add(arrow_left);

        arrow_right = new FlxSprite(FlxG.width - 200, 50);
        arrow_right.makeGraphic(150, 100, FlxColor.TRANSPARENT, false, "arrow_right");
        FlxSpriteUtil.drawPolygon(arrow_right, [new FlxPoint(150, 50), new FlxPoint(0, 0), new FlxPoint(0, 100)], FlxColor.WHITE);
        add(arrow_right);

        title = new FlxText(0, 50, 0, "Level 1", 64);
        title.screenCenter(FlxAxes.X);
        add(title);

        start = new FlxText(0, 120, 0, "PLAY!", 48);
        start.screenCenter(FlxAxes.X);
        add(start);
	}

    public function constructBelts()
    {
        var path = GameConst.CUPCAKES_PATH[level];

        belts.clear();

        var i = 1;
        while (i < path.length) {
            var origin = path[i - 1];
            var dest = path[i];

            var belt = new FlxSprite(Math.min(dest.x, origin.x), Math.min(dest.y, origin.y));
            belt.makeGraphic(Std.int(Math.abs(dest.x - origin.x)) + GameConst.CUPCAKE_WIDTH, Std.int(Math.abs(dest.y - origin.y)) + GameConst.CUPCAKE_HEIGHT, FlxColor.BLACK, true);
            belts.add(belt);

            i++;
        }
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				if (touch.x > arrow_left.x && touch.x < arrow_left.x + arrow_left.width && touch.y > arrow_left.y && touch.y < arrow_left.y + arrow_left.height) {
                    level = level == 0 ? GameConst.CUPCAKES_PATH.length - 1 : level - 1;
                } else if (touch.x > arrow_right.x && touch.x < arrow_right.x + arrow_right.width && touch.y > arrow_right.y && touch.y < arrow_right.y + arrow_right.height) {
                    level = level == GameConst.CUPCAKES_PATH.length - 1 ? 0 : level + 1;
                } else if (touch.x > start.x && touch.x < start.x + start.width && touch.y > start.y && touch.y < start.y + start.height) {
                    FlxG.switchState(new PlayState(level));
                    return ;
                }

                title.text = "Level " + (level + 1);
                title.screenCenter(FlxAxes.X);
                constructBelts();

            }
        }

	}
}

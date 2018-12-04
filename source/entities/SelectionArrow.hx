package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import states.PlayState;

class SelectionArrow extends FlxSprite
{
    private static var WIDTH = 150;
    private static var HEIGHT = 150;

    private var incr : Int;
    private var gameState : PlayState;

    public function new(gameState : PlayState, incr : Int, ?X:Float = 0)
    {
        super(X, 780);

        this.gameState = gameState;
        this.incr = incr;

        var vertices : Array<FlxPoint>;
        if (incr < 0) {
            vertices = [
                new FlxPoint(0, HEIGHT / 2),
                new FlxPoint(WIDTH, 0),
                new FlxPoint(WIDTH, HEIGHT)
            ];
        } else {
            vertices = [
                new FlxPoint(WIDTH, HEIGHT / 2),
                new FlxPoint(0, 0),
                new FlxPoint(0, HEIGHT)
            ];            
        }
        makeGraphic(WIDTH, HEIGHT, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawPolygon(this, vertices, FlxColor.YELLOW);
    }

    private function applyIncr()
    {
        gameState.workstations[gameState.workstation_selected].unselect();
        gameState.workstation_selected += incr;
        if (gameState.workstation_selected < 0)
        {
            gameState.workstation_selected = gameState.workstations.length - 1;
        }
        if (gameState.workstation_selected >= gameState.workstations.length)
        {
            gameState.workstation_selected = 0;
        }
        gameState.workstations[gameState.workstation_selected].select();
    }

    override public function update(elapsed:Float):Void
    {
        #if FLX_MOUSE
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justReleased) {
            applyIncr();
        }
        #end
        #if FLX_TOUCH
        for (touch in FlxG.touches.list)
        {
            if (touch.overlaps(this) && touch.justReleased) {
                applyIncr();
            }
        }
        #end
    }
}
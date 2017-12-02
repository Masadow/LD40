package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import entities.Muffin;
import flixel.input.keyboard.FlxKey;

class Conveyor extends FlxSprite
{
    private var elapsedTotal : Float;
    private var lastPopped : Float;
    private var randomizer : FlxRandom;
    private var probabilityBoost : Float;
    private var muffins : FlxGroup;
    private static var SPEED = 75;

	public function new(?Y:Float = 0, muffins : FlxGroup)
	{
		super(0, Y);

        makeGraphic(FlxG.width - 100, cast(FlxG.height - (Y * 2)), FlxColor.GRAY);

        elapsedTotal = 0;
        lastPopped = 0;
        randomizer = new FlxRandom();
        probabilityBoost = 0;
        this.muffins = muffins;
        popMuffin();
	}

    public function popMuffin() : Void {
        var comboSize = randomizer.int(1, 4);
        var combo = [FlxKey.A, FlxKey.S, FlxKey.D, FlxKey.F];
        while (comboSize++ < 4) {
            combo.splice(randomizer.int(0, combo.length - 1), 1);
        }
        var m : Muffin = cast muffins.recycle(Muffin);
        m.init(randomizer.float(this.y, this.y + this.height - Muffin.SIZE), SPEED, combo);
        muffins.add(m);
    }

    public function popMuffins() : Void {
//        var probability = Math.pow((elapsedTotal + 100) / 90, 3) + 15;
        var probability = (elapsedTotal / 5) + 15 + probabilityBoost;
        var c = 0;

        while (probability > 100) {
            probability -= 100;
            c++;
        }

        if (randomizer.bool(probability)) {
            c++;
        }

        probabilityBoost = c == 0 ? probabilityBoost + 5 : 0;

        while (c-- > 0) {
            popMuffin();
        }
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        lastPopped += elapsed;
        elapsedTotal += elapsed;

        if (lastPopped > 0.5) {
            lastPopped -= 0.5;
            popMuffins();
        }
	}
}

package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import entities.Muffin;
import flixel.util.FlxSpriteUtil;

class Selector extends FlxSprite
{
    private var prev : Null<Muffin>; 

	public function new()
	{
		super(-Muffin.BASE_HEIGHT, -Muffin.BASE_HEIGHT);

        makeGraphic(Muffin.BASE_HEIGHT, Muffin.BASE_HEIGHT, FlxColor.TRANSPARENT, false, "selector");
        FlxSpriteUtil.drawRect(this, 2, 1, Muffin.BASE_HEIGHT - 4, Muffin.BASE_HEIGHT - 3, FlxColor.TRANSPARENT, {
            thickness: 3,
            color: FlxColor.BLUE
        });
        prev = null;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (prev != null && !prev.alive) {
            prev.unselect();
            unselect();
        }
	}

    public function select(muffin:Muffin) {
        if (prev != null) {
            prev.unselect();
        }
        if (prev != muffin) {
            muffin.select(this);
            prev = muffin;        
        } else {
            unselect();
        }
    }

    public function unselect() {
        prev = null;
        x = -Muffin.BASE_HEIGHT;
        y = -Muffin.BASE_HEIGHT;
    }
}

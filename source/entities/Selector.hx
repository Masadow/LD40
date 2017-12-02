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
		super(-Muffin.SIZE, -Muffin.SIZE);

        makeGraphic(Muffin.SIZE, Muffin.SIZE, FlxColor.TRANSPARENT, false, "selector");
        FlxSpriteUtil.drawRect(this, 2, 1, Muffin.SIZE - 4, Muffin.SIZE - 3, FlxColor.TRANSPARENT, {
            thickness: 3,
            color: FlxColor.BLUE
        });
        prev = null;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
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
        x = -Muffin.SIZE;
        y = -Muffin.SIZE;
    }
}

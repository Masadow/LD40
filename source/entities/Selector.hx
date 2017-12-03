package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import entities.Muffin;
import flixel.util.FlxSpriteUtil;

class Selector
{
    private var prev : Null<Muffin>; 

	public function new()
	{
        prev = null;
	}

	public function update(elapsed:Float):Void
	{
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
            muffin.select();
            prev = muffin;        
        } else {
            unselect();
        }
    }

    public function unselect() {
        prev = null;
    }
}

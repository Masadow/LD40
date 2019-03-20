package entities.bonus;
import flixel.FlxG;
import entities.Muffin;
import flixel.util.FlxSpriteUtil;
import openfl.display.Bitmap;
import openfl.Assets;
import states.PlayState;


class Bonus {
    private var muffins : List<Muffin>;
    public var idx : Int;
    public var asset_id : String;

    private function new() {
        muffins = new List<Muffin>();
    }

    public function addMuffin(m : Muffin) {
        muffins.add(m);
    }

    public function trigger(ps : PlayState) {}

    public function cancel()
    {
        for (muffin in muffins) {
            muffin.bonus = null;
        }
        muffins.clear();
    }
}
package entities.bonus;
import flixel.FlxG;
import entities.Muffin;
import flixel.util.FlxSpriteUtil;
import openfl.display.Bitmap;
import openfl.Assets;


class Bonus {
    private var muffins : List<Muffin>;
    public var id : String;
    public var idx : Int;

    private function new() {
        muffins = new List<Muffin>();
    }

    public function addMuffin(m : Muffin) {
        muffins.add(m);
    }

    public function trigger() {}

    public function cancel()
    {
        for (muffin in muffins) {
            muffin.bonus = null;
        }
        muffins.clear();
    }
}
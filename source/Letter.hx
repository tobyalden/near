package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class Letter extends FlxSprite
{
    public static inline var SPEED = 200;

    static public var all:FlxGroup = new FlxGroup();

    public function new(x:Int, y:Int)
    {
        super(x, y);
        makeGraphic(16, 16, FlxColor.RED);
        all.add(this);
    }

    override public function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
    }

    private function movement()
    {

    }

    override public function kill()
    {
        all.remove(this);
        destroy();
    }
}

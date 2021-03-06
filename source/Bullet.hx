package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class Bullet extends FlxSprite
{
    
    public static inline var SPEED = 400;

    static public var all:FlxGroup = new FlxGroup();

    private var shotByPlayerTwo:Bool;

    public function new(x:Int, y:Int, shotByPlayerTwo:Bool=false)
    {
        super(x - 2, y - 2);
        this.shotByPlayerTwo = shotByPlayerTwo;
        makeGraphic(4, 4, FlxColor.WHITE);
        all.add(this);
    }


    public function wasShotByPlayerTwo() {
        return shotByPlayerTwo;
    }

    override public function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
    }

    private function movement()
    {
       velocity.y = -SPEED;
    }

    override public function destroy()
    {
        all.remove(this);
        super.destroy();
    }
}

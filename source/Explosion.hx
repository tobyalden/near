package;

import flixel.*;
import flixel.util.*;

class Explosion extends FlxSprite
{
    public function new(source:FlxObject) {
        super(source.x, source.y);
        loadGraphic('assets/images/explosion.png', true, 32, 32);
        animation.add('explode', [0, 1], 10, false);
        animation.play('explode');
    }
    
    override public function update(elapsed:Float)
    {
        if(animation.finished) {
            destroy();
            return;
        }
        super.update(elapsed);
    }

}

package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class Letter extends FlxSprite
{
    public static inline var SPEED = 200;

    public static var alphabet = [
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
        'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
    ];

    static public var all:FlxGroup = new FlxGroup();

    private var myLetter:String;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        loadGraphic('assets/images/letters.png', true, 34, 32);
        var count = 0;
        myLetter = alphabet[Math.floor(Math.random() * alphabet.length)];
        for(letter in alphabet) {
            animation.add(letter, [count]);
            count++;
        }
        animation.play(myLetter);
        all.add(this);
    }

    override public function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
    }

    private function movement()
    {
        velocity.y = SPEED;
    }

    override public function toString()
    {
        return myLetter;
    }

    override public function destroy()
    {
        all.remove(this);
        super.destroy();
    }
}

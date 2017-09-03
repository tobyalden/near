package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class Letter extends FlxSprite
{
    public static inline var SPEED = 50;

    public static var alphabet = [
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
        'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
    ];

    public static var letterFrequency = [
        "a"=> 8.167, "b"=> 1.492, "c"=> 2.782, "d"=> 4.253, "e"=> 12.702,
        "f"=> 2.228, "g"=> 2.015, "h"=> 6.094, "i"=> 6.966, "j"=> 0.153,
        "k"=> 0.772, "l"=> 4.025, "m"=> 2.406, "n"=> 6.749, "o"=> 7.507,
        "p"=> 1.929, "q"=> 0.095, "r"=> 5.987, "s"=> 6.327, "t"=> 9.056,
        "u"=> 2.758, "v"=> 0.978, "w"=> 2.360, "x"=> 0.150, "y"=> 1.974,
        "z"=> 0.074
    ];

    static public var all:FlxGroup = new FlxGroup();

    private var myLetter:String;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        loadGraphic('assets/images/letters.png', true, 34, 32);
        var count = 0;
        myLetter = getRandomWeighted();
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
        if(y > FlxG.height) {
            destroy();
            return;
        }
        super.update(elapsed);
    }

    private static function getRandomWeighted() {
        var randPercent = Math.random() * 100;
        var count = 0;
        while(randPercent > 0) {
           randPercent -= letterFrequency[alphabet[count]];
           count++;
        }
        return alphabet[count];
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

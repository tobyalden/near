package;

import flixel.*;
import flixel.text.*;

class PlayState extends FlxState
{
    static public var dictionary:Dictionary;
    private var player:Player;
    private var currentLetterDisplay:FlxText;

	override public function create():Void
	{
        dictionary = new Dictionary('assets/data/dictionary_small.txt');
        currentLetterDisplay = new FlxText();
        currentLetterDisplay.size = 64;
        currentLetterDisplay.y = FlxG.height - currentLetterDisplay.height;
        add(currentLetterDisplay);
        player = new Player(20, 20);
        add(player);
        for (i in 0...20) {
            add(new Letter(i*50, i*25));
        }
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        FlxG.overlap(Bullet.all, Letter.all, null, destroyBoth);
        currentLetterDisplay.text = player.getCurrentLetters();
		super.update(elapsed);
	}

    private function destroyBoth(sprite1:FlxObject, sprite2:FlxObject)
    {
        var letter:Letter = null;
        if(isLetter(sprite1)) {
            letter = cast(sprite1, Letter);
        }
        else if(isLetter(sprite2)) {
            letter = cast(sprite2, Letter);
        }
        if(letter != null) {
            player.addLetter(letter.toString());
        }
        sprite1.kill();
        sprite2.kill();
        return true;
    }

    private function isLetter(sprite:FlxObject) {
        return (
            Type.getClassName(Type.getClass(sprite))
            == Type.getClassName(Letter)
        );
    }
}

package;

import flixel.*;
import flixel.text.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var SPAWN_COOLDOWN = 0.7;

    private var player:Player;
    private var currentLetterDisplay:FlxText;
    private var lastWordDisplay:FlxText;
    private var dictionary:Dictionary;
    private var spawnCooldown:FlxTimer;

	override public function create():Void
	{
        dictionary = new Dictionary('assets/data/dictionary.txt');
        spawnCooldown = new FlxTimer();
        spawnCooldown.loops = 1;

        currentLetterDisplay = new FlxText();
        currentLetterDisplay.size = 64;
        currentLetterDisplay.y = FlxG.height - currentLetterDisplay.height;
        add(currentLetterDisplay);

        lastWordDisplay = new FlxText();
        lastWordDisplay.size = 64;
        //lastWordDisplay.y = FlxG.height/2 - lastWordDisplay.height/2;
        add(lastWordDisplay);

        player = new Player(20, 20, dictionary);
        add(player);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        FlxG.overlap(Bullet.all, Letter.all, null, destroyBoth);

        currentLetterDisplay.text = player.getCurrentLetters();

        lastWordDisplay.text = player.getLastWord();
        lastWordDisplay.x = FlxG.width/2 - lastWordDisplay.width/2;
        if(dictionary.isWord(player.getLastWord())) {
            lastWordDisplay.color = FlxColor.GREEN;
        }
        else {
            lastWordDisplay.color = FlxColor.RED;
        }

        if(!spawnCooldown.active) {
            spawnCooldown.reset(SPAWN_COOLDOWN);
            var randX = Math.round(FlxG.width * Math.random());
            var letter = new Letter(randX, -50);
            add(letter);
        }
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
        sprite1.destroy();
        sprite2.destroy();
        return true;
    }

    private function isLetter(sprite:FlxObject) {
        return (
            Type.getClassName(Type.getClass(sprite))
            == Type.getClassName(Letter)
        );
   }
}

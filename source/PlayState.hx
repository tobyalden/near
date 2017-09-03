package;

import flixel.*;
import flixel.text.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var SPAWN_COOLDOWN = 0.5;

    private var player1:Player;
    private var player2:Player;
    private var currentLetterDisplayP1:FlxText;
    private var lastWordDisplayP1:FlxText;
    private var currentLetterDisplayP2:FlxText;
    private var lastWordDisplayP2:FlxText;
    private var spawnCooldown:FlxTimer;

	override public function create():Void
	{
        new Dictionary('assets/data/dictionary.txt');
        spawnCooldown = new FlxTimer();
        spawnCooldown.loops = 1;

        currentLetterDisplayP1 = new FlxText();
        currentLetterDisplayP1.size = 64;
        currentLetterDisplayP1.y = FlxG.height - currentLetterDisplayP1.height;
        add(currentLetterDisplayP1);

        currentLetterDisplayP2 = new FlxText();
        currentLetterDisplayP2.size = 64;
        currentLetterDisplayP2.y = FlxG.height - currentLetterDisplayP2.height;
        add(currentLetterDisplayP2);

        lastWordDisplayP1 = new FlxText();
        lastWordDisplayP1.size = 64;
        add(lastWordDisplayP1);

        lastWordDisplayP2 = new FlxText();
        lastWordDisplayP2.size = 64;
        add(lastWordDisplayP2);

        player1 = new Player(20, 20);
        player2 = new Player(100, 100, true);
        add(player1);
        add(player2);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        FlxG.overlap(Bullet.all, Letter.all, null, destroyBoth);

        currentLetterDisplayP1.text = player1.getCurrentLetters();
        currentLetterDisplayP2.text = player2.getCurrentLetters();
        currentLetterDisplayP2.x = FlxG.width - currentLetterDisplayP2.width;

        lastWordDisplayP1.text = player1.getLastWord();
        lastWordDisplayP1.x = 0;
        if(Dictionary.dictionary.isWord(player1.getLastWord())) {
            lastWordDisplayP1.color = FlxColor.GREEN;
        }
        else {
            lastWordDisplayP1.color = FlxColor.RED;
        }

        lastWordDisplayP2.text = player2.getLastWord();
        lastWordDisplayP2.x = FlxG.width - lastWordDisplayP2.width;
        if(Dictionary.dictionary.isWord(player2.getLastWord())) {
            lastWordDisplayP2.color = FlxColor.GREEN;
        }
        else {
            lastWordDisplayP2.color = FlxColor.RED;
        }

        // TODO: Spawn different letters on the different sides of the screen
        if(!spawnCooldown.active) {
            spawnCooldown.reset(SPAWN_COOLDOWN);
            var randX = Math.round(FlxG.width * Math.random());
            var letter = new Letter(
                randX, -50,
                Letter.getRandomPotential(player1.getCurrentLetters())
            );
            add(letter);
        }
		super.update(elapsed);
	}

    private function destroyBoth(sprite1:FlxObject, sprite2:FlxObject)
    {
        var letter:Letter = null;
        var bullet:Bullet = null;
        if(isLetter(sprite1)) {
            letter = cast(sprite1, Letter);
            bullet = cast(sprite2, Bullet);
        }
        else if(isLetter(sprite2)) {
            letter = cast(sprite2, Letter);
            bullet = cast(sprite1, Bullet);
        }
        if(letter != null) {
            if(bullet.wasShotByPlayerTwo()) {
                player2.addLetter(letter.toString());
            }
            else {
                player1.addLetter(letter.toString());
            } 
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

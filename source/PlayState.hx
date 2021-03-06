package;

import flixel.*;
import flixel.group.*;
import flixel.text.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var SPAWN_COOLDOWN = 2;
    public static inline var MIN_SPAWN_COOLDOWN = 0.5;
    public static inline var GAME_OVER_DELAY = 2;

    public static var matchTimer:FlxTimer;

    private var player1:Player;
    private var player2:Player;
    private var line:FlxSprite;
    private var currentLetterDisplayP1:FlxText;
    private var lastWordDisplayP1:FlxText;
    private var currentLetterDisplayP2:FlxText;
    private var lastWordDisplayP2:FlxText;
    private var spawnCooldown:FlxTimer;
    private var spawnCooldownTime:Float;
    private var isGameOver:Bool;
    private var gameOverTimer:FlxTimer;
    private var gameOverText:FlxText;
    private var gameOverDisplay:FlxGroup;


	override public function create():Void
	{
        line = new FlxSprite(FlxG.width/2, 0);
        line.makeGraphic(1, FlxG.height, FlxColor.WHITE);
        add(line);

        spawnCooldown = new FlxTimer();
        spawnCooldown.loops = 1;

        gameOverDisplay = new FlxGroup();
        gameOverText = new FlxText(0, 0, 0, 'GAME OVER', 64);
        gameOverText.screenCenter();
        var restartText = new FlxText(0, 0, 0, 'PRESS START FOR REMATCH', 16);
        restartText.screenCenter();
        restartText.y += gameOverText.height;
        gameOverDisplay.add(gameOverText);
        gameOverDisplay.add(restartText);
        gameOverDisplay.kill();
        add(gameOverDisplay);

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

        player1 = new Player(0, FlxG.height - 16);
        player2 = new Player(FlxG.width - 16, FlxG.height - 16, true);
        add(player1);
        add(player2);

        isGameOver = false;
        gameOverTimer = new FlxTimer();
        gameOverTimer.loops = 1;

        matchTimer = new FlxTimer();
        matchTimer.loops = 0;
        matchTimer.start(9999);

        FlxG.sound.play("assets/sounds/matchstart.wav");

		super.create();
	}

	override public function update(elapsed:Float)
	{
        if(isGameOver && !gameOverTimer.active) {
            gameOverDisplay.revive(); 
            currentLetterDisplayP1.kill();
            currentLetterDisplayP2.kill();
            lastWordDisplayP1.kill();
            lastWordDisplayP2.kill();
            var controller = FlxG.gamepads.lastActive;
            if(controller != null) {
                if(controller.pressed.START) {
                    FlxG.switchState(new PlayState()); 
                    return;
                }
            }
        }
        FlxG.overlap(Bullet.all, Letter.all, null, destroyBoth);
        FlxG.overlap(player1, Letter.all, null, killPlayer);
        FlxG.overlap(player2, Letter.all,  null, killPlayer);

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

        if(!spawnCooldown.active && !isGameOver) {
            var spawnCooldownTime = Math.max(
                SPAWN_COOLDOWN - matchTimer.elapsedTime / 150,
                MIN_SPAWN_COOLDOWN
            );
            spawnCooldown.reset(spawnCooldownTime);
            var randX = Math.round((FlxG.width/2 - 35) * Math.random());
            var letter = new Letter(
                randX, -50,
                Letter.getRandomPotential(player1.getCurrentLetters())
            );
            add(letter);

            var randX = Math.round((FlxG.width/2 - 35) * Math.random());
            randX += Math.round(FlxG.width/2);
            var letter = new Letter(
                randX, -50,
                Letter.getRandomPotential(player2.getCurrentLetters())
            );
            add(letter);
        }
		super.update(elapsed);
	}

    private function killPlayer(player:FlxObject, _:FlxObject) {
        player.kill();
        var _player = cast(player, Player);
        if(cast(player, Player).isPlayerTwo) {
           gameOverText.text = 'P1 WINS';
        }
        else {
           gameOverText.text = 'P2 WINS';
        }
        gameOverText.screenCenter();
        Letter.all.kill();
        isGameOver = true;
        gameOverTimer.reset(GAME_OVER_DELAY);
        FlxG.sound.play("assets/sounds/playerhit.wav");
        return true;
    }

    private function destroyBoth(sprite1:FlxObject, sprite2:FlxObject)
    {
        var letter:Letter = null;
        var bullet:Bullet = null;
        if((isClass(sprite1, Letter)) && isClass(sprite2, Bullet)) {
            letter = cast(sprite1, Letter);
            bullet = cast(sprite2, Bullet);
        }
        else if(isClass(sprite2, Letter) && isClass(sprite1, Bullet)) {
            letter = cast(sprite2, Letter);
            bullet = cast(sprite1, Bullet);
        }
        else if(isClass(sprite1, TrashLetter) && isClass(sprite2, Bullet)) {
            letter = cast(sprite1, Letter);
            bullet = cast(sprite2, Bullet);
        }
        else if(isClass(sprite2, TrashLetter) && isClass(sprite1, Bullet)) {
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
            FlxG.sound.play("assets/sounds/hitletter.wav");
        }
        sprite1.destroy();
        sprite2.destroy();
        return true;
    }

    private function isClass(sprite:FlxObject, cls:Class<FlxSprite>) {
        return (
            Type.getClassName(Type.getClass(sprite))
            == Type.getClassName(cls)
        );
   }

}

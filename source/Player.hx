package;

import flixel.*;
import flixel.input.keyboard.*;
import flixel.util.*;

class Player extends FlxSprite
{
    public static inline var SPEED = 270;
    public static inline var SHOT_COOOLDOWN = 0.25;

    public static var P1_CONTROLS = [
        'up'=>FlxKey.UP,
        'down'=>FlxKey.DOWN,
        'left'=>FlxKey.LEFT,
        'right'=>FlxKey.RIGHT,
        'cast'=>FlxKey.Z,
        'shoot'=>FlxKey.X
    ];

    public static var P2_CONTROLS = [
        'up'=>FlxKey.I,
        'down'=>FlxKey.K,
        'left'=>FlxKey.J,
        'right'=>FlxKey.L,
        'cast'=>FlxKey.A,
        'shoot'=>FlxKey.S
    ];

    private var shotCooldown:FlxTimer;
    private var currentLetters:String;
    private var lastWord:String;
    private var isPlayerTwo:Bool;
    private var controls:Map<String, Int>;

    public function new(x:Int, y:Int, isPlayerTwo:Bool=false)
    {
        super(x, y);
        this.isPlayerTwo = isPlayerTwo;
        if(isPlayerTwo) {
            controls = P2_CONTROLS;
            makeGraphic(16, 16, FlxColor.RED);
        }
        else {
            controls = P1_CONTROLS;
            makeGraphic(16, 16, FlxColor.BLUE);
        }
        shotCooldown = new FlxTimer();
        shotCooldown.loops = 1;
        currentLetters = '';
        lastWord = '';
    }

    override public function update(elapsed:Float)
    {
        movement();
        shooting();
        super.update(elapsed);
        y = Math.max(0, y);
        y = Math.min(y, FlxG.height - height);
        if(isPlayerTwo) {
            x = Math.max(FlxG.width/2, x);
            x = Math.min(x, FlxG.width - width);
        }
        else {
            x = Math.max(0, x);
            x = Math.min(x, FlxG.width/2 - width);
        }
    }

    private function shooting()
    {
        if(FlxG.keys.anyPressed([controls['shoot']]) && !shotCooldown.active)
        {
            shotCooldown.reset(SHOT_COOOLDOWN);
            var bullet = new Bullet(
                Std.int(x + 8), Std.int(y + 8), isPlayerTwo
            );
            FlxG.state.add(bullet);
        }
        if(FlxG.keys.anyJustPressed([controls['cast']])) {
            castWord();
        }
    }

    public function addLetter(letter:String) {
        currentLetters += letter;
    }

    public function getCurrentLetters() {
        return currentLetters;
    }

    public function getLastWord() {
        return lastWord;
    }

    public function castWord() {
        if(Dictionary.dictionary.isWord(currentLetters)) {
            trace('spelled "' + currentLetters + '"!');
        }
        else {
            trace('bzzzt!');
        }
        lastWord = currentLetters;
        currentLetters = '';
    }

    private function movement()
    {
        if(FlxG.keys.anyPressed([controls['up']])) {
            velocity.y = -SPEED;
        }
        else if(FlxG.keys.anyPressed([controls['down']])) {
            velocity.y = SPEED;
        }
        else {
            velocity.y = 0;
        }

        if(FlxG.keys.anyPressed([controls['left']])) {
            velocity.x = -SPEED;
        }
        else if(FlxG.keys.anyPressed([controls['right']])) {
            velocity.x = SPEED;
        }
        else {
            velocity.x = 0;
        }

        if(velocity.x != 0 && velocity.y != 0) {
            velocity.scale(0.707106781);
        }
    }

}

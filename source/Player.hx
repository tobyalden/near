package;

import flixel.*;
import flixel.util.*;

class Player extends FlxSprite
{
    public static inline var SPEED = 200;
    public static inline var SHOT_COOOLDOWN = 0.25;

    private var shotCooldown:FlxTimer;
    private var currentLetters:String;
    private var dictionary:Dictionary;
    private var lastWord:String;

    public function new(x:Int, y:Int, dictionary:Dictionary)
    {
        super(x, y);
        this.dictionary = dictionary;
        makeGraphic(16, 16, FlxColor.BLUE);
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
    }

    private function shooting()
    {
        if(FlxG.keys.pressed.X && !shotCooldown.active)
        {
            shotCooldown.reset(SHOT_COOOLDOWN);
            var bullet = new Bullet(Std.int(x + 8), Std.int(y + 8));
            FlxG.state.add(bullet);
        }
        if(FlxG.keys.justPressed.Z) {
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
        if(dictionary.isWord(currentLetters)) {
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
        if(FlxG.keys.pressed.UP) {
            velocity.y = -SPEED;
        }
        else if(FlxG.keys.pressed.DOWN) {
            velocity.y = SPEED;
        }
        else {
            velocity.y = 0;
        }

        if(FlxG.keys.pressed.LEFT) {
            velocity.x = -SPEED;
        }
        else if(FlxG.keys.pressed.RIGHT) {
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

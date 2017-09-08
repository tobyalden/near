package;

import flixel.*;
import flixel.input.keyboard.*;
import flixel.input.gamepad.*;
import flixel.math.*;
import flixel.util.*;

class Player extends FlxSprite
{
    //public static inline var SPEED = 270;
    public static inline var BASE_SPEED = 270;
    public static inline var SHOT_COOOLDOWN = 0.25;
    public static inline var DEAD_ZONE = 0.5;

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

    public var isPlayerTwo:Bool;
    private var shotCooldown:FlxTimer;
    private var currentLetters:String;
    private var lastWord:String;
    private var controls:Map<String, Int>;
    private var controller:FlxGamepad;
    private var speed:Float;

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

    private function checkPressed(name:String) {
        if(controller == null) {
            return FlxG.keys.anyPressed([controls[name]]);
        }
        else {
            if(name == 'shoot') {
                return controller.pressed.A;
            } 
            if(name == 'cast') {
                return controller.pressed.X;
            } 
        }
        return false;
    }

    private function checkJustPressed(name:String) {
        if(controller == null) {
            return FlxG.keys.anyJustPressed([controls[name]]);
        }
        else {
            if(name == 'shoot') {
                return controller.justPressed.A;
            } 
            if(name == 'cast') {
                return controller.justPressed.X;
            } 
        }
        return false;
    }

    override public function update(elapsed:Float)
    {
        speed = BASE_SPEED / Math.max(
            PlayState.SPAWN_COOLDOWN - PlayState.matchTimer.elapsedTime / 150,
            PlayState.MIN_SPAWN_COOLDOWN
        );
        if(isPlayerTwo) {
            controller = FlxG.gamepads.getByID(1);
        }
        else {
            controller = FlxG.gamepads.getByID(0);
        }

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
        if(checkPressed('shoot') && !shotCooldown.active)
        {
            shotCooldown.reset(SHOT_COOOLDOWN);
            var bullet = new Bullet(
                Std.int(x + 8), Std.int(y + 8), isPlayerTwo
            );
            FlxG.state.add(bullet);
        }
        if(checkJustPressed('cast')) {
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
        var isWord = Dictionary.dictionary.isWord(currentLetters);
        var count = 0;
        for (letter in currentLetters.split('')) {
            var randX = Std.int(Math.random() * (FlxG.width/2 - 34));
            if (!isPlayerTwo && isWord || isPlayerTwo && !isWord) {
                randX += Std.int(FlxG.width/2);
            }
            var trash = new TrashLetter(randX, -50 - count * 50, letter);
            FlxG.state.add(trash);
            count++;
        }
        lastWord = currentLetters;
        currentLetters = '';
    }

    private function movement()
    {
        if(controller != null) {
            controller.deadZone = DEAD_ZONE;
            var leftStick = new FlxVector(
                controller.analog.value.LEFT_STICK_X, 
                controller.analog.value.LEFT_STICK_Y
            );
            leftStick.normalize();
            leftStick.scale(speed);
            velocity.x = leftStick.x;
            velocity.y = leftStick.y;
            return;
        }

        if(checkPressed('up')) {
            velocity.y = -speed;
        }
        else if(checkPressed('down')) {
            velocity.y = speed;
        }
        else {
            velocity.y = 0;
        }

        if(checkPressed('left')) {
            velocity.x = -speed;
        }
        else if(checkPressed('right')) {
            velocity.x = speed;
        }
        else {
            velocity.x = 0;
        }

        if(velocity.x != 0 && velocity.y != 0) {
            velocity.scale(0.707106781);
        }
    }

    override public function kill() {
        FlxG.state.add(new Explosion(this));
        super.kill();
    }

}

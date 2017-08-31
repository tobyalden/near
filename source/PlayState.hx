package;

import flixel.*;

class PlayState extends FlxState
{
    private var player:Player;

	override public function create():Void
	{
        player = new Player(20, 20);
        add(player);
        FlxG.sound.playMusic('assets/music/whitenoise.ogg', 0.1);
        add(new Letter(40, 40));
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        FlxG.overlap(Bullet.all, Letter.all, null, destroyBoth);
		super.update(elapsed);
	}

    private function destroyBoth(sprite1:FlxObject, sprite2:FlxObject)
    {
        sprite1.kill();
        sprite2.kill();
        return true;
    }
}

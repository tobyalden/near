package;

import flixel.*;

class PlayState extends FlxState
{
    private var dictionary:Dictionary;
    private var player:Player;

	override public function create():Void
	{
        dictionary = new Dictionary();
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
		super.update(elapsed);
	}

    private function destroyBoth(sprite1:FlxObject, sprite2:FlxObject)
    {
        sprite1.kill();
        sprite2.kill();
        return true;
    }
}

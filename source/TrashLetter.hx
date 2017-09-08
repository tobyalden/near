package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class TrashLetter extends Letter
{

    public static inline var SPEED = 100;

    public function new(x:Int, y:Int, myLetter:String)
    {
        super(x, y, myLetter);
        speed = SPEED;
    }

    override private function loadLetterGraphics()
    {
        loadGraphic('assets/images/trashletters.png', true, 34, 32);
    }
}

package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class Dictionary
{
    
    static public inline var DICTIONARY_PATH = (
        'assets/data/dictionary.txt'
    );
    private var allWords:Map<String, Dynamic>;

    public function new()
    {
        allWords = new Map<String, Dynamic>();
        var count = 0;
        var file = sys.io.File.read(DICTIONARY_PATH, false);
        var word = file.readLine();
        while(word != null)
        {
            var index = 0;
            var pointer = allWords;
            while(index < word.length) {
                if(pointer.exists(word.charAt(index))) {
                    pointer = pointer.get(word.charAt(index));
                }
                else {
                    var new_branch = new Map<String, Dynamic>();
                    pointer.set(word.charAt(index), new_branch);
                    pointer = new_branch;
                }
                index++;
            }
            try {
                word = file.readLine();
            } catch (e:haxe.io.Eof) {
                word = null; 
            }
            count++;
        }
        file.close();
        trace('Loaded ' + count + ' words into tree.');
    }

}

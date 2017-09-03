package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class Dictionary
{
    static public var dictionary:Dictionary;

    private var allWords:Map<String, Dynamic>;

    public function new(path:String)
    {
        allWords = new Map<String, Dynamic>();
        var count = 0;
        var file = sys.io.File.read(path, false);
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
            pointer.set('isWord', true);
            try {
                word = file.readLine();
            } catch (e:haxe.io.Eof) {
                word = null;
            }
            count++;
        }
        file.close();
        trace('Loaded ' + count + ' words into tree.');
        dictionary = this;
    }

    public function isWord(word:String, countSubstringAsWord:Bool=false)
    {
        try {
            var pointer = allWords;
            for(letter in word.split('')) {
               pointer = pointer[letter];
            }
            if(pointer.get('isWord')) {
                return true;
            }
        }
        catch(e:Dynamic) {
            return false;
        }
        return countSubstringAsWord;
    }

    public function isSubstring(word) {
       return isWord(word, true);
    }

    public function getPotentialLetters(start:String) {
        // Returns a set of all the letters in all the words starting with the
        // given string
        var potentialLetters = [];
        if(!isSubstring(start)) {
            return potentialLetters;
        }
        var allWordsPointer = allWords;
        for(letter in start.split('')) {
            allWordsPointer = allWordsPointer[letter];
        }
        var letterIter:Iterator<String> = (
            allWordsPointer.keys()
        );
        while(letterIter.hasNext()) {
            var key = letterIter.next();
            potentialLetters.push(key);
        }
        return potentialLetters;
    }

}

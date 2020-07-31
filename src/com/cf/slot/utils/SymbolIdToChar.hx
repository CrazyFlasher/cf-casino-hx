package com.cf.slot.utils;

class SymbolIdToChar
{
    private static final alphabet:Array<String> = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];

    public static function get(id:Int):String
    {
        if (id < 10) return Std.string(id);

        return alphabet[id - 10];
    }
}

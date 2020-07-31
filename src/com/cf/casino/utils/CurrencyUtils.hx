package com.cf.casino.utils;

class CurrencyUtils
{
    public static function formatCurrency(value:Float):String
    {
        #if html5
            #if !standAlone
                return JS.formatCurrency(value);
            #else
                return untyped value.toFixed(2);
            #end
        #end

        return Std.string(value);
    }
}

#if html5
@:native("gAPI.casinoUI")
extern class JS
{
    static var formatCurrency:Float -> String;
}
#end
package com.cf.casino.config;

import com.cf.devkit.config.Config;
import haxe.ds.ReadOnlyArray;

class CasinoConfig extends Config implements ICasinoConfig
{
    public var singleWinHighLightDuration(get, never):Float;
    public var allWinsHighLightDuration(get, never):Float;
    public var iterateWinsWhileHighlightingAll(get, never):Bool;
    public var pauseDuringBigWin(get, never):Bool;
    public var winCountUpDuration(get, never):Float;

    public var mysterySymbolIdList(get, never):ReadOnlyArray<Int>;
    private var _mysterySymbolIdList:Array<Int> = [];

    private function get_mysterySymbolIdList():ReadOnlyArray<Int>
    {
        return _mysterySymbolIdList;
    }

    private function get_singleWinHighLightDuration():Float
    {
        return 1;
    }

    private function get_allWinsHighLightDuration():Float
    {
        return 2;
    }

    private function get_iterateWinsWhileHighlightingAll():Bool
    {
        return false;
    }

    private function get_pauseDuringBigWin():Bool
    {
        return false;
    }

    private function get_winCountUpDuration():Float
    {
        return 5;
    }
}

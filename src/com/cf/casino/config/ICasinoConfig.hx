package com.cf.casino.config;

import com.cf.devkit.config.IConfig;
import haxe.ds.ReadOnlyArray;

interface ICasinoConfig extends IConfig
{
    /**
    * Id list of mistery symbols that should be replaced.
    **/
    var mysterySymbolIdList(get, never):ReadOnlyArray<Int>;

    /**
    * Duration of each win to be highlighted on display.
    **/
    var singleWinHighLightDuration(get, never):Float;

    /**
    * All wins highlight duration.
    **/
    var allWinsHighLightDuration(get, never):Float;

    /**
    * Iterate though each win when showing all wins.
    **/
    var iterateWinsWhileHighlightingAll(get, never):Bool;

    /**
    * Pause wins iteration during big win.
    **/
    var pauseDuringBigWin(get, never):Bool;

    /**
    * Duration of increasing visual win value.
    **/
    var winCountUpDuration(get, never):Float;
}

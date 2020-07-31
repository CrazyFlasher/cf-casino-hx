package com.cf.casino.models.app;

import com.domwires.core.mvc.model.IModelImmutable;
import haxe.ds.ReadOnlyArray;

interface IAppModelImmutable extends IModelImmutable
{
    var freeGamesCount(get, never):Int;
    var roundEnd(get, never):Bool;
    var totalWin(get, never):Float;
    var roundTotalWin(get, never):Float;
    var autoPlay(get, never):Bool;
    var fastPlay(get, never):Bool;
    var betAmount(get, never):Int;
    var betValue(get, never):Float;
    var totalBetValue(get, never):Float;
    var winThreshold(get, never):Float;
    var isBigWin(get, never):Bool;
    var replacementIdList(get, never):ReadOnlyArray<Int>;
    var uiAutoPlayEnabled(get, never):Bool;
}

package com.cf.casino.models.win;

import com.cf.casino.models.win.singleWin.ISingleWinModelImmutable;
import com.domwires.core.mvc.model.IModelContainerImmutable;
import haxe.ds.ReadOnlyArray;

interface IWinsModelImmutable extends IModelContainerImmutable
{
    var singleWinModelList(get, never):ReadOnlyArray<ISingleWinModelImmutable>;
    var freeGamesWon(get, never):Bool;
    var freeGamesAwardedCount(get, never):Int;
    var count(get, never):Int;

    function hasWins():Bool;
    function hasHighWins():Bool;
}

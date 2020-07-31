package com.cf.casino.models.win.singleWin;

import com.domwires.core.mvc.model.IModelContainerImmutable;

interface ISingleWinModelImmutable extends IModelContainerImmutable
{
    var amount(get, never):Float;
    var count(get, never):Int;
    var multiplier(get, never):Int;
    var symbolId(get, never):Int;
    var freeGamesAwarded(get, never):Int;

    var hasHighSymbol(get, never):Bool;
}

package com.cf.slot.models.reels.singleReel.symbol;

import com.domwires.core.mvc.model.IModelImmutable;

interface ISymbolModelImmutable extends IModelImmutable
{
    var id(get, never):Int;
    var isWild(get, never):Bool;
    var isScatter(get, never):Bool;
    var vo(get, never):SymbolVo;

    function hasWin(lineId:Int = -1):Bool;
    function hasWinOnAnyLine():Bool;
}

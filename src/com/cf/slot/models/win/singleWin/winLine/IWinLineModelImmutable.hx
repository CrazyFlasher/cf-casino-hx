package com.cf.slot.models.win.singleWin.winLine;

import com.domwires.core.mvc.model.IModelImmutable;

interface IWinLineModelImmutable extends IModelImmutable
{
    var positionIdList(get, never):Array<Int>;
    var id(get, never):Int;
    var hasWild(get, never):Bool;
    var hasScatter(get, never):Bool;
}

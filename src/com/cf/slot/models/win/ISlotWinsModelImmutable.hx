package com.cf.slot.models.win;

import com.cf.slot.models.win.singleWin.ISlotSingleWinModelImmutable;
import com.cf.casino.models.win.IWinsModelImmutable;
import haxe.ds.ReadOnlyArray;

interface ISlotWinsModelImmutable extends IWinsModelImmutable
{
    var slotSingleWinModelList(get, never):ReadOnlyArray<ISlotSingleWinModelImmutable>;
    function hasWildWins():Bool;
}

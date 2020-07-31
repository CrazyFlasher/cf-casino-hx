package com.cf.slot.models.win.singleWin;

import com.cf.casino.models.win.singleWin.ISingleWinModelImmutable;
import com.cf.slot.models.win.singleWin.winLine.IWinLineModelImmutable;
import openfl.geom.Point;

interface ISlotSingleWinModelImmutable extends ISingleWinModelImmutable
{
    var winLine(get, never):IWinLineModelImmutable;
    var scatterPositionIdList(get, never):Array<Point>;
}

package com.cf.slot.models.win.singleWin;

import com.cf.casino.models.win.singleWin.ISingleWinModel;
import com.cf.casino.models.win.singleWin.SingleWinVo;
import com.cf.slot.models.win.singleWin.winLine.IWinLineModel;
import com.cf.slot.models.win.singleWin.winLine.IWinLineModelImmutable;
import com.cf.casino.models.win.singleWin.SingleWinModel;
import openfl.geom.Point;

class SlotSingleWinModel extends SingleWinModel implements ISlotSingleWinModel
{
    private var slotVo:SlotSingleWinVo;

    public var winLine(get, never):IWinLineModelImmutable;
    public var scatterPositionIdList(get, never):Array<Point>;

    private var _winLine:IWinLineModel;

    override private function init():Void
    {
        super.init();

        createWinLineModel();
    }

    override public function update(vo:SingleWinVo):ISingleWinModel
    {
        slotVo = cast vo;

        super.update(vo);

        _winLine.update(slotVo.winLine);

        return this;
    }

    private function createWinLineModel():IWinLineModel
    {
        _winLine = modelFactory.getInstance(IWinLineModel);
        addModel(_winLine);

        return _winLine;
    }

    private function get_winLine():IWinLineModelImmutable
    {
        return slotVo.winLine != null ? _winLine : null;
    }

    private function get_scatterPositionIdList():Array<Point>
    {
        return slotVo.scatterPositionIdList;
    }
}

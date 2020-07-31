package com.cf.slot.models.win;

import com.cf.slot.models.win.singleWin.ISlotSingleWinModel;
import com.cf.casino.models.win.singleWin.SingleWinVo;
import com.cf.casino.models.win.singleWin.ISingleWinModel;
import com.cf.casino.models.win.IWinsModel;
import com.cf.slot.models.win.singleWin.ISlotSingleWinModelImmutable;
import com.cf.casino.models.win.WinsModel;
import com.domwires.core.utils.ArrayUtils;
import com.cf.casino.models.win.IWinsModel;
import com.cf.casino.models.win.singleWin.ISingleWinModel;
import com.cf.casino.models.win.singleWin.SingleWinVo;
import com.cf.casino.models.win.WinsModel;
import com.cf.casino.models.win.WinsVo;
import com.cf.slot.models.win.singleWin.ISlotSingleWinModel;
import com.cf.slot.models.win.singleWin.ISlotSingleWinModelImmutable;
import com.cf.slot.models.win.singleWin.SlotSingleWinVo;
import haxe.ds.ReadOnlyArray;

@:keep
class SlotWinsModel extends WinsModel implements ISlotWinsModel
{
    public var slotSingleWinModelList(get, never):ReadOnlyArray<ISlotSingleWinModelImmutable>;

    private var _slotSingleWinModelList:Array<ISlotSingleWinModelImmutable> = [];

    override public function clear():IWinsModel
    {
        ArrayUtils.clear(_slotSingleWinModelList);

        return super.clear();
    }

    override private function createSingleWinModel(vo:SingleWinVo):ISingleWinModel
    {
        var model:ISlotSingleWinModel = cast super.createSingleWinModel(vo);

        _slotSingleWinModelList.push(model);

        return model;
    }

    private function get_slotSingleWinModelList():ReadOnlyArray<ISlotSingleWinModelImmutable>
    {
        return _slotSingleWinModelList;
    }

    public function hasWildWins():Bool
    {
        for (singleWin in _slotSingleWinModelList)
        {
            if (singleWin.winLine != null && singleWin.winLine.hasWild)
            {
                return true;
            }
        }

        return false;
    }
}

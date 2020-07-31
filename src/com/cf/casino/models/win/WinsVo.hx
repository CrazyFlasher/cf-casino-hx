package com.cf.casino.models.win;

import com.cf.casino.models.win.singleWin.SingleWinVo;
import com.domwires.core.utils.ArrayUtils;
import com.ganapati.casino.models.win.singleWin.SingleWinVo;

class WinsVo extends AbstractVo
{
    public var singleWinVoList(get, never):Array<SingleWinVo>;

    private var _singleWinVoList:Array<SingleWinVo> = [];

    override private function init():Void
    {
        super.init();

        modelFactory.registerPool(SingleWinVo, 1, false, "isBusy");
    }

    public function update(json:Dynamic):Void
    {
        for (singleWinVo in _singleWinVoList)
        {
            singleWinVo.isBusy = false;
        }

        ArrayUtils.clear(_singleWinVoList);

        var vo:SingleWinVo;
        var winJsonList:Array<Dynamic> = json.wins;
        for (winJson in winJsonList)
        {
            vo = modelFactory.getInstance(SingleWinVo);
            vo.isBusy = true;
            vo.update(winJson, json.display);

            _singleWinVoList.push(vo);
        }
    }

    private function get_singleWinVoList():Array<SingleWinVo>
    {
        return _singleWinVoList;
    }
}

package com.cf.casino.models.win;

import com.cf.casino.models.win.singleWin.SingleWinVo;
import com.cf.casino.models.win.singleWin.ISingleWinModel;
import com.cf.casino.models.win.singleWin.ISingleWinModelImmutable;
import com.domwires.core.utils.ArrayUtils;
import haxe.ds.ReadOnlyArray;

@:keep
class WinsModel extends AbstractAppModelContainer implements IWinsModel
{
    public var singleWinModelList(get, never):ReadOnlyArray<ISingleWinModelImmutable>;
    public var freeGamesWon(get, never):Bool;
    public var freeGamesAwardedCount(get, never):Int;
    public var count(get, never):Int;

    private var _singleWinModelList:Array<ISingleWinModelImmutable> = [];
    private var _freeGamesAwardedCount:Int;

    override private function init():Void
    {
        super.init();

        modelFactory.registerPool(ISingleWinModel, 1, false, "isBusy");
    }

    public function update(vo:WinsVo):IWinsModel
    {
        clear();

        var model:ISingleWinModel;
        for (singleWinVo in vo.singleWinVoList)
        {
            model = createSingleWinModel(singleWinVo);
            addModel(model);

            _freeGamesAwardedCount += model.freeGamesAwarded;
        }

        return this;
    }

    public function clear():IWinsModel
    {
        removeAll(false);

        ArrayUtils.clear(_singleWinModelList);

        _freeGamesAwardedCount = 0;

        return this;
    }

    private function createSingleWinModel(vo:SingleWinVo):ISingleWinModel
    {
        var model:ISingleWinModel = modelFactory.getInstance(ISingleWinModel);
        model.update(vo);

        _singleWinModelList.push(model);

        return model;
    }

    private function get_singleWinModelList():ReadOnlyArray<ISingleWinModelImmutable>
    {
        return _singleWinModelList;
    }

    public function hasWins():Bool
    {
        return _singleWinModelList.length > 0;
    }

    public function hasHighWins():Bool
    {
        for (singleWin in _singleWinModelList)
        {
            if (isHighWin(singleWin))
            {
                return true;
            }
        }

        return false;
    }

    private function isHighWin(model:ISingleWinModelImmutable):Bool
    {
        return model.hasHighSymbol;
    }

    private function get_freeGamesWon():Bool
    {
        return _freeGamesAwardedCount > 0;
    }

    private function get_freeGamesAwardedCount():Int
    {
        return _freeGamesAwardedCount;
    }

    private function get_count():Int
    {
        return _singleWinModelList.length;
    }
}

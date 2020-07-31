package com.cf.slot.models.reels;

import com.cf.slot.models.reels.singleReel.ISingleReelModelImmutable;
import com.cf.slot.models.reels.singleReel.ISingleReelModel;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.models.AbstractAppModelContainer;
import haxe.ds.ReadOnlyArray;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.models.AbstractAppModelContainer;
import com.cf.slot.models.reels.singleReel.ISingleReelModel;
import com.cf.slot.models.reels.singleReel.ISingleReelModelImmutable;

@:keep
class ReelsModel extends AbstractAppModelContainer implements IReelsModel
{
    @Inject
    private var config:ISlotConfig;

    public var singleReelModelListImmutable(get, never):ReadOnlyArray<ISingleReelModelImmutable>;

    private var _singleReelModelList:Array<ISingleReelModel> = [];
    private var _singleReelModelListImmutable:Array<ISingleReelModelImmutable> = [];

    public var scatterCount(get, never):Int;
    private var _scatterCount:Int = 0;

    override private function init():Void
    {
        super.init();

        for (i in 0...config.reelsCount)
        {
            createSingleReelModel(i);
        }
    }

    private function createSingleReelModel(index:Int):ISingleReelModel
    {
        var model:ISingleReelModel = cast modelFactory.getInstance(ISingleReelModel);
        addModel(model);

        model.setIndex(index);

        _singleReelModelList.push(model);
        _singleReelModelListImmutable.push(model);

        return model;
    }

    public function populate(baseGameValues:Array<Array<Int>>, freeGameValues:Array<Array<Int>>):IReelsModel
    {
        var reelModel:ISingleReelModel;
        for (i in 0...config.reelsCount)
        {
            reelModel = _singleReelModelList[i];
            reelModel.populate(baseGameValues[i], freeGameValues[i]);
        }

        return this;
    }

    private function get_singleReelModelListImmutable():ReadOnlyArray<ISingleReelModelImmutable>
    {
        return _singleReelModelListImmutable;
    }

    public function update(vo:ReelsVo):IReelsModel
    {
        _scatterCount = 0;

        for (index in 0...vo.singleReelVoList.length)
        {
            _singleReelModelList[index].update(vo.singleReelVoList[index]);

            _scatterCount += _singleReelModelList[index].scatterCount;
        }

        return this;
    }

    public function getReelByIndexImmutable(index:Int):ISingleReelModelImmutable
    {
        return getReelByIndex(index);
    }

    public function getReelByIndex(index:Int):ISingleReelModel
    {
        return _singleReelModelList[index];
    }

    private function get_scatterCount():Int
    {
        return _scatterCount;
    }

    public function hasWilds():Bool
    {
        for (reelModel in _singleReelModelListImmutable)
        {
            if (reelModel.hasWilds())
            {
                return true;
            }
        }

        return false;
    }

    public function hasWildOnNextReels(reelIndex:Int):Bool
    {
        for (index in reelIndex + 1..._singleReelModelListImmutable.length)
        {
            if (_singleReelModelListImmutable[index].hasWilds())
            {
                return true;
            }
        }

        return false;
    }

    public function getSymbolCount(id:Int):Int
    {
        var count:Int = 0;

        for (reelModel in _singleReelModelListImmutable)
        {
            count += reelModel.getSymbolCount(id);
        }

        return count;
    }
}

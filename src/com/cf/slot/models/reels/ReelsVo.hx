package com.cf.slot.models.reels;

import com.cf.slot.models.reels.singleReel.SingleReelVo;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.models.AbstractVo;

class ReelsVo extends AbstractVo
{
    @Inject
    private var config:ISlotConfig;

    public var singleReelVoList(get, never):Array<SingleReelVo>;

    private var _singleReelVoList:Array<SingleReelVo> = [];

    override private function init():Void
    {
        super.init();

        for (i in 0...config.reelsCount)
        {
            _singleReelVoList.push(modelFactory.getInstance(SingleReelVo));
        }
    }

    public function update(json:Dynamic):Void
    {
        var reelJsonList:Array<Dynamic> = json.display;

        for (reelIndex in 0...reelJsonList.length)
        {
            _singleReelVoList[reelIndex].update(reelJsonList[reelIndex]);
        }
    }

    private function get_singleReelVoList():Array<SingleReelVo>
    {
        return _singleReelVoList;
    }
}

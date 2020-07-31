package com.cf.slot.models.reels.singleReel;

import com.cf.slot.models.reels.singleReel.symbol.SymbolVo;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.models.AbstractVo;
import haxe.ds.ReadOnlyArray;

class SingleReelVo extends AbstractVo
{
    @Inject
    private var config:ISlotConfig;

    public var symbolVoList(get, never):ReadOnlyArray<SymbolVo>;

    private var _symbolVoList:Array<SymbolVo> = [];

    override private function init():Void
    {
        super.init();

        for (i in 0...config.symbolsOnReelCount)
        {
            _symbolVoList.push(modelFactory.getInstance(SymbolVo));
        }
    }

    public function update(json:Dynamic):Void
    {
        var symbolIdList:Array<Dynamic> = cast json;
        var symbolId:Int;
        for (i in 0...symbolIdList.length)
        {
            symbolId = symbolIdList[i];

            _symbolVoList[i].id = symbolId;
        }
    }

    private function get_symbolVoList():ReadOnlyArray<SymbolVo>
    {
        return _symbolVoList;
    }
}

package com.cf.slot.models.reels.singleReel;

import com.cf.slot.utils.SymbolIdToChar;
import com.cf.slot.models.reels.singleReel.symbol.SymbolVo;
import com.cf.devkit.trace.Trace;
import com.cf.slot.models.reels.singleReel.symbol.ISymbolModelImmutable;
import com.cf.slot.models.reels.singleReel.symbol.ISymbolModel;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.models.AbstractAppModelContainer;
import com.cf.slot.utils.SymbolIdToChar;
import com.cf.devkit.trace.Trace;
import haxe.ds.ReadOnlyArray;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.models.AbstractAppModelContainer;
import com.domwires.core.utils.ArrayUtils;
import com.cf.slot.models.reels.singleReel.symbol.ISymbolModel;
import com.cf.slot.models.reels.singleReel.symbol.ISymbolModelImmutable;
import com.cf.slot.models.reels.singleReel.symbol.SymbolVo;

@:keep
class SingleReelModel extends AbstractAppModelContainer implements ISingleReelModel
{
    @Inject
    private var config:ISlotConfig;

    public var scatterCount(get, never):Int;
    private var _scatterCount:Int;

    public var index(get, never):Int;

    public var baseGameValues(get, never):Array<Int>;
    public var freeGameValues(get, never):Array<Int>;

    public var symbolModelListImmutable(get, never):ReadOnlyArray<ISymbolModelImmutable>;

    private var _index:Int;

    private var _symbolModelList:Array<ISymbolModel> = [];
    private var _symbolModelListImmutable:Array<ISymbolModelImmutable> = [];

    private var prevBaseGameValues:Array<Int>;

    private var _baseGameValues:Array<Int>;
    private var _freeGameValues:Array<Int>;

    private var baseGameValuesString:String;
    private var freeGameValuesString:String;

    private var _symbolIdList:Array<Int> = [];

    override private function init():Void
    {
        super.init();

        for (i in 0...config.symbolsOnReelCount)
        {
            createSymbolModel();
        }
    }

    private function createSymbolModel():ISymbolModel
    {
        var symbolModel:ISymbolModel = modelFactory.getInstance(ISymbolModel);
        addModel(symbolModel);

        _symbolModelList.push(symbolModel);
        _symbolModelListImmutable.push(symbolModel);

        return symbolModel;
    }

    public function populate(baseGameValues:Array<Int>, freeGameValues:Array<Int>):ISingleReelModel
    {
        if (prevBaseGameValues != baseGameValues)
        {
            prevBaseGameValues = baseGameValues;

            _baseGameValues = baseGameValues.concat(baseGameValues);
            _freeGameValues = freeGameValues.concat(freeGameValues);

            baseGameValuesString = replaceToChar(baseGameValues).toString().split(",").join("");
            freeGameValuesString = replaceToChar(freeGameValues).toString().split(",").join("");

            trace("baseGameValuesString: " + baseGameValuesString, Trace.INFO);
            trace("freeGameValuesString: " + freeGameValuesString, Trace.INFO);
        }

        var vo:SymbolVo;
        for (i in 0..._symbolModelList.length)
        {
            vo = _symbolModelList[i].vo;
            if (vo != null)
            {
                vo.id = _baseGameValues[i];
            } else
            {
                vo = createSymbolVo(_baseGameValues[i], i);
            }

            updateSymbol(i, vo);
        }

        return this;
    }

    private function createSymbolVo(id:Int, index:Int):SymbolVo
    {
        var vo:SymbolVo = modelFactory.getInstance(SymbolVo);
        vo.id = id;

        return vo;
    }

    private function replaceToChar(values:Array<Int>):Array<String>
    {
        var arr:Array<String> = [];

        for (symId in values)
        {
            arr.push(SymbolIdToChar.get(symId));
        }

        return arr;
    }

    public function setIndex(value:Int):ISingleReelModel
    {
        _index = value;

        return this;
    }

    public function update(vo:SingleReelVo):ISingleReelModel
    {
        _scatterCount = 0;

        for (index in 0...vo.symbolVoList.length)
        {
            updateSymbol(index, vo.symbolVoList[index]);
        }

        return this;
    }

    private function updateSymbol(index:Int, vo:SymbolVo):Void
    {
        var symbolModel:ISymbolModel = _symbolModelList[index];
        symbolModel.update(vo);

        if (symbolModel.isScatter)
        {
            _scatterCount++;
        }
    }

    public function getSymbolCount(id:Int):Int
    {
        var count:Int = 0;

        for (symbolModel in _symbolModelListImmutable)
        {
            if (symbolModel.id == id)
            {
                count++;
            }
        }

        return count;
    }

    public function getSymbolByIndex(index:Int):ISymbolModel
    {
        return _symbolModelList[index];
    }

    private function get_symbolModelListImmutable():ReadOnlyArray<ISymbolModelImmutable>
    {
        return _symbolModelListImmutable;
    }

    private function get_index():Int
    {
        return _index;
    }

    private function get_scatterCount():Int
    {
        return _scatterCount;
    }

    public function hasWilds():Bool
    {
        for (symbolModel in _symbolModelListImmutable)
        {
            if (symbolModel.isWild)
            {
                return true;
            }
        }

        return false;
    }

    public function hasScatters():Bool
    {
        for (symbolModel in _symbolModelListImmutable)
        {
            if (symbolModel.isScatter)
            {
                return true;
            }
        }

        return false;
    }

    public function getPosition(symbolIdListString:String, isFreeGame:Bool):Int
    {
        var arrString:String = isFreeGame ? freeGameValuesString : baseGameValuesString;

        return arrString.indexOf(symbolIdListString);
    }

    public function getSymbolIdList(position:Int, isFreeGame:Bool):Array<Int>
    {
        ArrayUtils.clear(_symbolIdList);

        var arr:Array<Int> = isFreeGame ? _freeGameValues : _baseGameValues;

        if (position > arr.length - 1)
        {
            position = 0;
        } else
        if (position < 0)
        {
            position = arr.length + position;
        }

        var value:Int;
        for (i in 0...config.symbolsOnReelCount)
        {
            value = position + i;
            if (value == arr.length)
            {
                value = value - arr.length;
            }

            _symbolIdList.push(arr[value]);
        }

        return _symbolIdList;
    }

    private function get_baseGameValues():Array<Int>
    {
        return _baseGameValues;
    }

    private function get_freeGameValues():Array<Int>
    {
        return _freeGameValues;
    }
}

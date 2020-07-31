package com.cf.slot.views.reels.single;

import com.cf.slot.views.reels.symbol.SymbolView;
import com.cf.devkit.tween.TweenTransition;
import com.cf.slot.utils.SymbolIdToChar;
import com.cf.slot.models.reels.singleReel.symbol.ISymbolModelImmutable;
import com.cf.devkit.bundle.IMovieClip;
import com.cf.slot.views.reels.symbol.SymbolView;
import com.cf.devkit.tween.ITween;
import com.cf.slot.config.ISlotConfig;
import com.cf.devkit.services.stats.IStatsServiceImmutable;
import com.cf.slot.models.reels.singleReel.ISingleReelModelImmutable;
import com.cf.casino.views.MovieClipView;
import com.cf.slot.utils.SymbolIdToChar;
import motion.Actuate;
import haxe.ds.ReadOnlyArray;
import com.cf.devkit.tween.TweenTransition;
import com.domwires.core.mvc.message.IMessage;
import com.cf.devkit.tween.TweenMessageType;
import com.cf.devkit.tween.ITween;
import com.cf.devkit.trace.Trace;
import com.domwires.core.utils.ArrayUtils;
import com.cf.slot.views.reels.symbol.SymbolView;
import com.cf.slot.models.reels.singleReel.symbol.ISymbolModelImmutable;
import com.cf.devkit.services.stats.IStatsServiceImmutable;
import com.cf.casino.views.MovieClipView;
import com.cf.devkit.bundle.IMovieClip;
import com.cf.slot.config.ISlotConfig;
import com.cf.slot.models.reels.singleReel.ISingleReelModelImmutable;
import openfl.geom.Point;
import openfl.Lib;

@:keep
class SingleReelView extends MovieClipView
{
    public var model(get, never):ISingleReelModelImmutable;

    @Inject
    private var stats:IStatsServiceImmutable;

    @Inject
    private var _model:ISingleReelModelImmutable;

    @Inject
    private var config:ISlotConfig;

    private var tween:ITween;

    private var y(get, set):Float;
    private var _y:Float = 0;

    private var symbolsCount:Int;

    private var symbolViewList:Array<SymbolView>;
    private var resultSymbolViewList:Array<SymbolView>;

    private var fastPlay:Bool;
    private var isFreeSpin:Bool;

    private var spinLoops:Int;

    private var currentSpinDelay:Float;
    private var currentLoopCount:Int = 0;
    private var currentSpinLoopTime:Float;
    private var currentSpinStopTime:Float;
    private var isLastLoop:Bool;

    private var currentPosition:Int = -1;

    private var symbolHeight:Float = 0;
    private var symbolWidth:Float = 0;

    private var symbolsToBeCombinedWithFirstList:Array<SymbolView> = [];

    override public function set_movieAssets(value:IMovieClip):IMovieClip
    {
        super.set_movieAssets(value);

        setup();

        return value;
    }

    public function setTimeScale(value:Float):Void
    {
        tween.timeScale = value;
    }

    public function showResult(animate:Bool, fastPlay:Bool, isFreeSpin:Bool):Void
    {
        if (isFreeSpin != this.isFreeSpin)
        {
            currentPosition = -1;
        }

        tween.timeScale = 1.0;

        this.fastPlay = fastPlay;
        this.isFreeSpin = isFreeSpin;

        if (animate)
        {
            currentSpinDelay = _model.index * config.spinDelay;
            currentSpinLoopTime = config.spinLoopTime;
            currentSpinStopTime = config.spinStopTime;

            currentLoopCount = 0;
            spinLoops = 0;

            animationStarted();
        } else
        {
            updateSymbolAssets();
        }
    }

    private function setup():Void
    {
        tween = viewFactory.getInstance(ITween);

        symbolViewList = [];
        resultSymbolViewList = [];

        symbolsCount = model.symbolModelListImmutable.length;

        var symbolView:SymbolView;
        var symbolAssets:IMovieClip;
        var displayAssets:IMovieClip = _movieAssets.getMovieClip("display");

        for (i in 0...symbolsCount + 1)
        {
            symbolAssets = displayAssets.getMovieClip("cell_" + i + "_" + model.index);

            symbolView = viewFactory.getInstance(SymbolView);
            symbolView.movieAssets = symbolAssets;

            if (symbolWidth == 0)
            {
                symbolWidth = symbolView.width;
                symbolHeight = symbolView.height;
            }

            //assing index only to bottom (real) symbols
            if (isResultSymbolIndex(i))
            {
                symbolView.index = i - 1;
                symbolView.model = model.symbolModelListImmutable[i - 1];

                resultSymbolViewList.push(symbolView);
            }

            symbolViewList.push(symbolView);
        }

        updateSymbolAssets();
    }

    public function setLoopsCountBeforeStop(value:Int):Void
    {
        currentLoopCount = value;
        spinLoops = 0;
    }

    public function updateSpeedMultiplier():Void
    {
        if (config.extraAnticipation != null)
        {
            currentSpinLoopTime = config.spinLoopTime / config.extraAnticipation.speedMutliplier;
            currentSpinStopTime = config.spinStopTime / config.extraAnticipation.speedMutliplier;
        }
    }

    public function resetSpeedMultiplier():Void
    {
        if (config.extraAnticipation != null)
        {
            currentSpinLoopTime = config.spinLoopTime;
            currentSpinStopTime = config.spinStopTime;
        }
    }

    private function isResultSymbolIndex(index:Int):Bool
    {
        return index > 0;
    }

    public function updateSymbolAssets():Void
    {
        var symbolView:SymbolView;
        var symbolModel:ISymbolModelImmutable;

        for (i in 0...resultSymbolViewList.length)
        {
            symbolView = resultSymbolViewList[i];
            symbolModel = model.symbolModelListImmutable[i];

            symbolView.id = symbolModel.id;
        }

        symbolView = symbolViewList[0];

        symbolView.id = getNextSymbolId();
    }

    private function getNextSymbolId():Int
    {
        var loopsLeft:Int = currentLoopCount - spinLoops;

        if (!(currentLoopCount == 0 || loopsLeft > symbolsCount - 1))
        {
            return getResultSymbolId();
        }

        var currentDisplay:String =
            SymbolIdToChar.get(resultSymbolViewList[0].id) +
            SymbolIdToChar.get(resultSymbolViewList[1].id) +
            SymbolIdToChar.get(resultSymbolViewList[2].id);

        if (currentPosition == -1)
        {
            currentPosition = _model.getPosition(currentDisplay, isFreeSpin);
        } else
        {
            currentPosition--;

            if (currentPosition < 0)
            {
                currentPosition = !isFreeSpin ? _model.baseGameValues.length - 1 : _model.freeGameValues.length - 1;
            }
        }
        var nextSymbolId:Int = _model.getSymbolIdList(currentPosition - 1, isFreeSpin)[0];

//        trace("currentDisplay " + currentDisplay);
//        trace("currentPosition " + currentPosition);
//        trace("nextSymbolId " + nextSymbolId);

        return nextSymbolId;
    }

    private function getRandomSymbolId():Int
    {
        return Math.floor(Math.random() * config.totalSymbolCount);
    }

    private function anticipationCompleted():Void
    {
        dispatchMessage(SingleReelViewMessageType.AnticipationCompleted);
    }

    private function anticipationStarted():Void
    {
        dispatchMessage(SingleReelViewMessageType.AnticipationStarted);
    }

    public function highLightSymbols(value:Bool, lineId:Int = -1, highLightIterationIndex:Int = 0):Void
    {
        for (symbolView in resultSymbolViewList)
        {
            if (value)
            {
                if (symbolView.model.hasWin(lineId))
                {
                    highLightWinSymbol(symbolView, highLightIterationIndex);
                } else
                {
                    if (symbolView.firstInCombinationSequence == null || !symbolView.firstInCombinationSequence.model.hasWinOnAnyLine())
                    {
                        highLightNoWinSymbol(symbolView, highLightIterationIndex);
                    }
                }
            } else
            {
                symbolView.reset();
            }
        }
    }

    public function combineWinSymbols():Void
    {
        ArrayUtils.clear(symbolsToBeCombinedWithFirstList);

        var endCombineIndex:Int = 0;

        var firstCombinedSymbol:SymbolView = null;
        var symbolView:SymbolView;

        for (i in 0...resultSymbolViewList.length)
        {
            symbolView = resultSymbolViewList[i];
            if (symbolView.model.hasWinOnAnyLine())
            {
                if (firstCombinedSymbol == null)
                {
                    firstCombinedSymbol = symbolView;

                    endCombineIndex = i;
                } else
                if (symbolView.model.id == firstCombinedSymbol.id)
                {
                    if (i - endCombineIndex == 1)
                    {
                        endCombineIndex = i;

                        symbolsToBeCombinedWithFirstList.push(symbolView);
                    }
                } else
                {
                    break;
                }
            }
        }

        if (firstCombinedSymbol != null && endCombineIndex > 0 && symbolsToBeCombinedWithFirstList.length > 0)
        {
            combine(firstCombinedSymbol, symbolsToBeCombinedWithFirstList);
        }
    }

    private function combine(firstCombinedSymbol:SymbolView, symbolsToBeCombinedWithFirstList:Array<SymbolView>):Void
    {
        #if debug
        var indexList:Array<Int> = [];
        for (s in symbolsToBeCombinedWithFirstList)
        {
            indexList.push(s.index);
        }
        trace("Reel " + _model.index + ": " + firstCombinedSymbol.index + " can be combined with " + indexList, Trace.INFO);
        #end

        var count:Int = symbolsToBeCombinedWithFirstList.length + 1;
        firstCombinedSymbol.setIsCombined(firstCombinedSymbol, count);

        for (combinedWithFirst in symbolsToBeCombinedWithFirstList)
        {
            combinedWithFirst.setIsCombined(firstCombinedSymbol, count);
        }
    }

    private function highLightWinSymbol(symbolView:SymbolView, highLightIterationIndex:Int):Void
    {
        var symbolToHighlight:SymbolView = symbolView.firstInCombinationSequence == null ? symbolView
            : symbolView.firstInCombinationSequence;

        symbolToHighlight.showHighLight(false, highLightIterationIndex);
    }

    private function highLightNoWinSymbol(symbolView:SymbolView, highLightIterationIndex:Int):Void
    {
        symbolView.hideHighLight(highLightIterationIndex);
    }

    private function animationStarted():Void
    {
        if (currentSpinDelay > 0)
        {
            Actuate.timer(currentSpinDelay).onComplete(startSpin);
        } else
        {
            startSpin();
        }
    }

    private function startSpin():Void
    {
        if (!fastPlay)
        {
//            Actuate.tween(this, config.preSpinTime, {y: -symbolHeight / 8}).ease(Quad.easeOut).onComplete(startLoop);
            tween.setOnComplete(startLoop);

            tween.tween(this, config.preSpinTime, {y: symbolHeight - symbolHeight * config.preStartReelDisplacementFactor}, TweenTransition.EASE_OUT);
            y = symbolHeight;

            replaceTopWinBottom();
        } else
        {
            startLoop();
        }

        anticipationStarted();
    }

    private function startLoop():Void
    {
        blurSymbols(true, config.accelerateSpinTime * 4, TweenTransition.EASE_IN);

        tween.setOnComplete(loop);
        tween.tween(this, config.accelerateSpinTime * (fastPlay ? 4 : 1), {y: symbolHeight}, TweenTransition.EASE_IN);
//        Actuate.tween(this, config.accelerateSpinTime, {y: symbolHeight}).ease(Quad.easeIn).onComplete(loop);
    }

    private function blurSymbols(value:Bool, duration:Float, ease:String):Void
    {
        for (symbolView in symbolViewList)
        {
            symbolView.setBlur(value, duration, ease);
        }
    }

    private function stopSpin():Void
    {
        currentLoopCount = 0;
        spinLoops = 0;

        if (fastPlay)
        {
            restoreReelPosition();
            replaceBottomWithTop();
        }

        anticipationCompleted();
    }

    private function loop():Void
    {
        isLastLoop = currentLoopCount == 0 || spinLoops < currentLoopCount;

        restoreReelPosition();
        replaceBottomWithTop();

        var ease:String;
        var duration:Float;

        if (isLastLoop)
        {
            ease = TweenTransition.LINEAR;
            duration = currentSpinLoopTime;
        } else
        {
            ease = fastPlay ? TweenTransition.EASE_OUT : TweenTransition.LINEAR;
            duration = fastPlay ? currentSpinStopTime : currentSpinLoopTime;

            blurSymbols(false, duration, ease);
        }

        tween.setOnComplete(onLoopComplete);
        tween.tween(this, duration, {y: symbolHeight}, ease);
//        Actuate.tween(this, duration, {y: symbolHeight}).ease(ease).onComplete(onLoopComplete);
    }

    private function onLoopComplete():Void
    {
        if (isLastLoop)
        {
            if (currentLoopCount != 0)
            {
                spinLoops++;
            }

            loop();
        } else
        {
            if (fastPlay)
            {
                stopSpin();
            } else
            {
                preStop();
            }
        }
    }

    private function preStop():Void
    {
        restoreReelPosition();
        replaceBottomWithTop();

//        Actuate.tween(this, config.preStopTime, {y: symbolHeight / 16}).ease(Linear.easeNone).onComplete(preStopComplete);

        tween.setOnComplete(preStopComplete);
        tween.tween(this, config.preStopTime, {y: symbolHeight * config.preStopReelDisplacementFactor}, TweenTransition.LINEAR);
    }

    private function preStopComplete():Void
    {
        tween.setOnComplete(stopSpin);
        tween.tween(this, config.preStopTime, {y: 0}, TweenTransition.EASE_OUT);
//        Actuate.tween(this, config.preStopTime, {y: 0}).onComplete(stopSpin).ease(Quad.easeOut);
    }

    private function replaceTopWinBottom():Void
    {
        for (i in 0...3)
        {
            symbolViewList[i].id = symbolViewList[i + 1].id;
        }

        symbolViewList[symbolViewList.length - 1].id = getNextSymbolId(); //TODO: better return prev symbol id from strips
    }

    private function replaceBottomWithTop():Void
    {
        var i:Int = resultSymbolViewList.length;

        while(i > 0)
        {
            symbolViewList[i].id = symbolViewList[i - 1].id;

            i--;
        }

        symbolViewList[0].id = getNextSymbolId();
    }

    private function getResultSymbolId():Int
    {
        var left:Int = currentLoopCount - spinLoops;
        if (left == 2) return _model.symbolModelListImmutable[2].id;
        if (left == 1) return _model.symbolModelListImmutable[1].id;
        return _model.symbolModelListImmutable[0].id;
    }

    private function restoreReelPosition():Void
    {
        y = 0;
    }

    private function get_y():Float
    {
        return _y;
    }

    private function set_y(value:Float):Float
    {
        _y = value;

        for (symbolView in symbolViewList)
        {
            symbolView.assets.y = symbolView.originY + _y;
        }

        return value;
    }

    private function get_model():ISingleReelModelImmutable
    {
        return _model;
    }

    public function getSymbolViewList():ReadOnlyArray<SymbolView>
    {
        return symbolViewList;
    }

    public function getResultSymbolViewList():ReadOnlyArray<SymbolView>
    {
        return resultSymbolViewList;
    }
}

enum SingleReelViewMessageType
{
    AnticipationStarted;
    AnticipationCompleted;
}


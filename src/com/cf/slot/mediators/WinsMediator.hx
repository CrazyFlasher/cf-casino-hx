package com.cf.slot.mediators;

import com.cf.casino.models.win.singleWin.ISingleWinModelImmutable;
import com.cf.slot.models.win.singleWin.ISlotSingleWinModelImmutable;
import com.cf.devkit.tween.TweenTransition;
import com.cf.casino.mediators.MediatorMessageType;
import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.models.state.StateModelMessageType;
import com.cf.devkit.tween.ITween;
import com.cf.slot.models.win.ISlotWinsModelImmutable;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.mediators.AbstractAppMediator;
import com.domwires.core.mvc.message.IMessage;
import motion.Actuate;
import motion.actuators.IGenericActuator;

class WinsMediator extends AbstractAppMediator
{
    @Inject
    private var slotConfig:ISlotConfig;

    @Inject
    private var slotWinsModel:ISlotWinsModelImmutable;

    private var highLightTimer:IGenericActuator;
    private var currenthighLightedWinLine:Int;

    private var mappingData:Dynamic = {};
    private var highLightIterationIndex:Int;

    private var countUpTween:ITween;

    private var isShowingAllWins:Bool;

    @:keep
    private var countUpValue(get, set):Float;

    @:keep
    private var _countUpValue:Float;

    private var skip:Bool;
    private var canSkip:Bool;

    override private function init():Void
    {
        super.init();

        countUpTween = viewFactory.getInstance(ITween);
    }

    override private function addListeners():Void
    {
        super.addListeners();

        addMessageListener(BigWinMediatorMessageType.CountUpStarted, handleBigWinCountUpStarted);
        addMessageListener(BigWinMediatorMessageType.CountUpCompleted, handleBigWinCountUpCompleted);
        addMessageListener(BigWinMediatorMessageType.Completed, handleBigWinCompleted);
        addMessageListener(ReelsMediatorMessageType.AnticipationCompleted, reelsAnticipationCompleted);

        appStateModel.addMessageListener(StateModelMessageType.StateUpdated, appStateUpdated);
    }

    override private function handleScreenClick(m:IMessage):Void
    {
        super.handleScreenClick(m);

        if (canSkip && isAutoPlay() && !skip && slotConfig.skipWinsHighLightAllowed)
        {
            skip = true;
            canSkip = false;

            if (isShowingAllWins)
            {
                isShowingAllWins = false;

                showAllWinsCompleted();
            }

            stopCountUpWin();
            stopHighLightTimer();
            highLightComplete();
        }
    }

    private function appStateUpdated(m:IMessage):Void
    {
        if (appStateModel.state == AppState.RoundStarted)
        {
            skip = false;
            canSkip = false;

            stopHighLightTimer();
        }
    }

    private function stopHighLightTimer():Void
    {
        if (highLightTimer != null)
        {
            Actuate.stop(highLightTimer, null, false, false);
        }
    }

    private function handleBigWinCountUpStarted(m:IMessage)
    {
        countUpWin();
    }

    private function handleBigWinCountUpCompleted(m:IMessage)
    {
        stopCountUpWin();
    }

    private function handleBigWinCompleted(m:IMessage)
    {
        if (slotConfig.pauseDuringBigWin)
        {
            startWinsHighLighting();
        }
    }

    private function reelsAnticipationCompleted(m:IMessage)
    {
        canSkip = true;

        if (!slotConfig.pauseDuringBigWin || !appModel.isBigWin)
        {
            startWinsHighLighting();
        }
    }

    private function startWinsHighLighting():Void
    {
        if (canHighLight())
        {
            highLightIterationIndex = isShowingPrevFinalResults() ? 1 : 0;
            currenthighLightedWinLine = 0;

            highLightAllWins();
        } else
        {
            highLightComplete();
        }
    }

    private function canHighLight():Bool
    {
        return slotWinsModel.hasWins();
    }

    private function continueHighLight():Void
    {
        if (isShowingAllWins)
        {
            isShowingAllWins = false;

            showAllWinsCompleted();
        }

        if (!isAutoPlay() || !slotConfig.iterateWinsWhileHighlightingAll)
        {
            highLightComplete();

            if (!isAutoPlay())
            {
                highLightNextWinLine();
            }
        } else
        {
            highLightNextWinLine();
        }
    }

    private function showAllWinsCompleted():Void
    {
        dispatchMessage(WinsMediatorMessageType.ShowAllWinsCompleted);
    }

    @:keep
    private function get_countUpValue():Float
    {
        return _countUpValue;
    }

    @:keep
    private function set_countUpValue(value:Float):Float
    {
        _countUpValue = value;

        mappingData.value = value;

        dispatchMessage(MediatorMessageType.WinValueUpdated, mappingData);

        return value;
    }

    private function stopCountUpWin():Void
    {
        countUpTween.stop(true);

        countUpValue = appModel.totalWin;
    }

    private function countUpWin():Void
    {
        _countUpValue = 0.0;
        countUpTween.tween(this, appModel.isBigWin ? getCountUpDuration() : getAllHighLightDuration(), {countUpValue: appModel.totalWin}, TweenTransition.EASE_IN_OUT);
    }

    private function highLightAllWins():Void
    {
        isShowingAllWins = true;

        if (!appModel.isBigWin && !isShowingPrevFinalResults())
        {
            if (slotWinsModel.count > 0)
            {
                countUpWin();
            } else
            {
                countUpValue = appModel.totalWin;
            }
        }

        var duration:Float = getAllHighLightDuration();
        mappingData.duration = duration;
        dispatchMessage(WinsMediatorMessageType.ShowAllWinsStarted, mappingData);

        if (winsCountSuits() && !isShowingPrevFinalResults())
        {
            stopHighLightTimer();
            highLightTimer = Actuate.timer(duration);
            highLightTimer.onComplete(continueHighLight);
        } else
        {
            continueHighLight();
        }
    }

    private function winsCountSuits():Bool
    {
        return slotWinsModel.count > 1 || (slotWinsModel.count == 1 && appModel.autoPlay);
    }

    private function highLightNextWinLine():Void
    {
        var singleWinModel:ISlotSingleWinModelImmutable = slotWinsModel.slotSingleWinModelList[currenthighLightedWinLine];

        highLightNextSingleWin();

        currenthighLightedWinLine++;

        if (currenthighLightedWinLine == slotWinsModel.count)
        {
            currenthighLightedWinLine = 0;

            highLightIterationIndex++;
        }

        stopHighLightTimer();
        highLightTimer = Actuate.timer(getSingleWinHighLightDuration(singleWinModel));

        /*if (highLightIterationIndex == 1 && slotConfig.iterateWinsWhileHighlightingAll && isShowingAllWins)
        {
            isShowingAllWins = false;

            showAllWinsCompleted();
        }*/

        if (isAutoPlay() && highLightIterationIndex == 1)
        {
            highLightTimer.onComplete(highLightComplete);
        } else
        {
            highLightTimer.onComplete(highLightNextWinLine);
        }
    }

    private function highLightNextSingleWin():Void
    {
        var singleWinModel:ISlotSingleWinModelImmutable = slotWinsModel.slotSingleWinModelList[currenthighLightedWinLine];

        mappingData.singleWinModel = singleWinModel;
        mappingData.highLightIterationIndex = highLightIterationIndex;

        dispatchMessage(WinsMediatorMessageType.SelectedWinUpdated, mappingData);
    }

    private function getSingleWinHighLightDuration(model:ISingleWinModelImmutable):Float
    {
        return slotWinsModel.count > 1 ? slotConfig.singleWinHighLightDuration : slotConfig.allWinsHighLightDuration;
    }

     private function getAllHighLightDuration():Float
    {
        var duration:Float = slotConfig.allWinsHighLightDuration;

        if (isAutoPlay() && !slotConfig.iterateWinsWhileHighlightingAll)
        {
            duration /= 2;
        }

        return duration;
    }

    private function getCountUpDuration():Float
    {
        return slotConfig.winCountUpDuration;
    }

    private function highLightComplete():Void
    {
        if (!appModel.isBigWin)
        {
            dispatchMessage(MediatorMessageType.ShowResultsCompleted);
        }
    }
}

enum WinsMediatorMessageType
{
    ShowAllWinsStarted;
    ShowAllWinsCompleted;
    SelectedWinUpdated;
}
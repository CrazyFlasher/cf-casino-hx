package com.cf.slot.mediators;

import com.cf.casino.mediators.MediatorMessageType;
import com.cf.slot.models.win.ISlotWinsModelImmutable;
import com.cf.slot.config.ISlotConfig;
import com.cf.casino.mediators.AbstractAppMediator;
import com.domwires.core.mvc.message.IMessage;

class AbstractBigWinMediator extends AbstractAppMediator
{
    @Inject
    private var slotConfig:ISlotConfig;

    @Inject
    private var slotWinsModel:ISlotWinsModelImmutable;

    override private function init():Void
    {
        super.init();

        createView();
    }

    private function createView():Void
    {
        throw haxe.io.Error.Custom("Override!");
    }

    override public function show(value:Bool):Void
    {
        if (value)
        {
            dispatchStarted();
            dispatchCountUpStarted();
        } else
        {
            dispatchCountUpCompleted();
            dispatchCompleted();
        }
    }

    override private function addListeners():Void
    {
        super.addListeners();

        if (slotConfig.pauseDuringBigWin)
        {
            addMessageListener(ReelsMediatorMessageType.AnticipationCompleted, reelsAnticipationCompleted);
        } else
        {
            addMessageListener(WinsMediatorMessageType.ShowAllWinsCompleted, handleShowAllWinsCompleted);
        }
    }

    override private function handleScreenClick(m:IMessage):Void
    {
        super.handleScreenClick(m);

        if (slotConfig.skipBigWinAllowed)
        {
            skipBigWin();
        }
    }

    private function skipBigWin():Void
    {
        throw haxe.io.Error.Custom("Override!");
    }

    private function handleShowAllWinsCompleted(m:IMessage)
    {
        readyToShow();
    }

    private function reelsAnticipationCompleted(m:IMessage)
    {
        readyToShow();
    }

    private function readyToShow():Void
    {
        if (appModel.isBigWin)
        {
            show(!isShowingPrevFinalResults() && slotWinsModel.hasWins());
        }
    }

    private function dispatchStarted():Void
    {
        dispatchMessage(BigWinMediatorMessageType.Started);
    }

    private function dispatchCompleted():Void
    {
        dispatchMessage(BigWinMediatorMessageType.Completed);
        dispatchMessage(MediatorMessageType.ShowResultsCompleted);
    }

    private function dispatchCountUpStarted():Void
    {
        dispatchMessage(BigWinMediatorMessageType.CountUpStarted);
    }

    private function dispatchCountUpCompleted():Void
    {
        dispatchMessage(BigWinMediatorMessageType.CountUpCompleted);
    }
}

enum BigWinMediatorMessageType
{
    Started;
    Completed;
    CountUpStarted;
    CountUpCompleted;
}
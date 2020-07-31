package com.cf.slot.mediators;

import com.cf.devkit.trace.Trace;
import com.cf.devkit.bundle.IDisplayObject;
import com.cf.slot.models.win.singleWin.ISlotSingleWinModelImmutable;
import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.models.state.StateModelMessageType;
import com.cf.devkit.bundle.IMovieClip;
import com.cf.slot.models.win.ISlotWinsModelImmutable;
import com.cf.casino.mediators.AbstractAppMediator;
import com.cf.slot.config.ISlotConfig;
import com.domwires.core.mvc.message.IMessage;
import openfl.geom.Point;
import com.cf.slot.mediators.WinsMediator.WinsMediatorMessageType;

class AbstractPaylinesMediator extends AbstractAppMediator
{
    @Inject
    private var slotConfig:ISlotConfig;

    @Inject
    private var slotWinsModel:ISlotWinsModelImmutable;

    private var symbolsContainer:IMovieClip;

    private var symbolPositionList:Array<Array<Point>>;

    override private function init():Void
    {
        super.init();

        symbolsContainer = getSymbolsContainer();

        populateSymbolPositionList();
    }

    override public function show(value:Bool):Void
    {
        throw haxe.io.Error.Custom("Override!");
    }

    private function getSymbolsContainer():IMovieClip
    {
        throw haxe.io.Error.Custom("Override!");
    }

    override private function addListeners():Void
    {
        super.addListeners();

        addMessageListener(WinsMediatorMessageType.ShowAllWinsStarted, handleShowAllWins);
        addMessageListener(WinsMediatorMessageType.SelectedWinUpdated, handleSelectedWinUpdated);

        appStateModel.addMessageListener(StateModelMessageType.StateUpdated, appStateUpdated);
    }

    private function appStateUpdated(m:IMessage):Void
    {
        if (appStateModel.state == AppState.RoundStarted)
        {
            hideAll();
        }
    }

    private function handleSelectedWinUpdated(m:IMessage):Void
    {
        showPayline(m.data.singleWinModel, true, slotConfig.singleWinHighLightDuration);
    }

    private function handleShowAllWins(m:IMessage):Void
    {
        if (slotWinsModel.count > 0)
        {
            for (singleWinModel in slotWinsModel.slotSingleWinModelList)
            {
                if (singleWinModel.winLine != null)
                {
                    showPayline(singleWinModel, false, cast m.data.duration);
                }
            }
        }
    }

    private function showPayline(singleWin:ISlotSingleWinModelImmutable, hideOther:Bool, lifeTime:Float):Void
    {
        throw haxe.io.Error.Custom("Override!");
    }

    private function hideAll():Void
    {
        throw haxe.io.Error.Custom("Override!");
    }

    private function populateSymbolPositionList():Void
    {
        symbolPositionList = [];

        for (reelIndex in 0...slotConfig.reelsCount)
        {
            var symbolPositionOnReelList:Array<Point> = [];
            var symbol:IDisplayObject;

            for (symbolIndex in 0...slotConfig.symbolsOnReelCount)
            {
                symbol = symbolsContainer.getDisplayObject("cell_" + (symbolIndex + 1) + "_" + reelIndex);

                symbolPositionOnReelList.push(new Point(symbol.x + getSymbolWidth(symbol) / 2, symbol.y + getSymbolHeight(symbol) / 2));
            }

            symbolPositionList.push(symbolPositionOnReelList);
        }

        trace("Symbol position list for paylines: " + symbolPositionList, Trace.INFO);
    }

    private function getLinePoints(positionIdList:Array<Int>):Array<Point>
    {
        var linePointList:Array<Point> = [];

        var point:Point;
        var positionId:Int;
        for (i in 0...positionIdList.length)
        {
            positionId = positionIdList[i];
            point = new Point(
            symbolPositionList[i][positionId].x,
            symbolPositionList[i][positionId].y
            );

            linePointList.push(point);
        }

        return linePointList;
    }

    private function getSymbolWidth(symbol:IDisplayObject):Float
    {
        return symbol.width;
    }

    private function getSymbolHeight(symbol:IDisplayObject):Float
    {
        return symbol.height;
    }
}

package com.cf.casino.mediators;

import com.cf.casino.mediators.ui.UIMediatorMessageType;
import com.cf.casino.models.state.enums.RoundState;
import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.models.state.IStateModelImmutable;
import com.cf.casino.models.app.IAppModelImmutable;
import com.cf.devkit.mediators.BaseMediator;
import com.domwires.core.mvc.mediator.IMediator;
import com.domwires.core.mvc.message.IMessage;

#if !useStarling
import openfl.display.DisplayObjectContainer;
#else
#end

class AbstractAppMediator extends BaseMediator implements IMediator
{
    @Inject
    private var appModel:IAppModelImmutable;

    @Inject("appStateModel")
    private var appStateModel:IStateModelImmutable;

    @Inject("roundStateModel")
    private var roundStateModel:IStateModelImmutable;

    private function isAutoPlay():Bool
    {
        return /*appModel.autoPlay || */appModel.freeGamesCount > 0;
    }

    private function isShowingPrevFinalResults():Bool
    {
        return appStateModel.state == AppState.ShowingPrevResult &&
            !(
                roundStateModel.state == RoundState.FreePlay ||
                roundStateModel.nextState == RoundState.FreePlay
            );
    }

    override private function addListeners():Void
    {
        super.addListeners();

        addMessageListener(UIMediatorMessageType.ScreenClick, handleScreenClick);
    }

    private function handleScreenClick(m:IMessage):Void
    {

    }
}

package com.cf.casino.mediators.ui;

import com.cf.devkit.models.pause.PauseState;
import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.models.state.enums.RoundState;
import com.cf.casino.views.ui.UIViewMessageType;
import com.cf.casino.models.state.StateModelMessageType;
import com.cf.devkit.display.Stage;
import com.cf.casino.views.ui.IUIView;
import com.cf.devkit.mediators.audio.IAudioMediator;
import com.domwires.core.mvc.message.IMessage;

#if !useStarling
import openfl.display.DisplayObjectContainer;
#else
import starling.display.DisplayObjectContainer;
#end

@:keep
class UIMediator extends AbstractAppMediator implements IUIMediator
{
    @Inject
    private var audio:IAudioMediator;

    public var fastPlay(get, never):Bool;

    private var uiView:IUIView;

    private var menuOpened:Bool = false;

    private var prevWin:Float;

    override public function init():Void
    {
        uiView = viewFactory.getInstance(IUIView);

        super.init();

        if (uiView.assets != null)
        {
            container.addChild(uiView.assets);
        }
    }

    override private function getContainer():DisplayObjectContainer
    {
        return Stage.get();
    }

    override private function addListeners():Void
    {
        super.addListeners();

        addMessageListener(MediatorMessageType.ShowResultsCompleted, animationCompleted);
        addMessageListener(MediatorMessageType.WinValueUpdated, winValueUpdated);
        addMessageListener(MediatorMessageType.ShowPlayButton, showPlayButton);
        addMessageListener(MediatorMessageType.HidePlayButton, hidePlayButton);
        addMessageListener(MediatorMessageType.ShowBetButton, showBetButton);
        addMessageListener(MediatorMessageType.HideBetButton, hideBetButton);

        appStateModel.addMessageListener(StateModelMessageType.StateUpdated, roundModelStateUpdated);

        uiView.addMessageListener(UIViewMessageType.MenuToggle, onMenuToggle);
        uiView.addMessageListener(UIViewMessageType.ButtonClick, onButtonClick);
        uiView.addMessageListener(UIViewMessageType.OverlayToggle, onOverlayToggle);
        uiView.addMessageListener(UIViewMessageType.MusicVolumeUpdate, onMusicVolumeUpdate);
        uiView.addMessageListener(UIViewMessageType.SoundVolumeUpdate, onSoundVolumeUpdate);
        uiView.addMessageListener(UIViewMessageType.QuickPlayUpdate, onQuickPlayUpdate);
        uiView.addMessageListener(UIViewMessageType.ScreenClick, onScreenClick);
        uiView.addMessageListener(UIViewMessageType.BetUpdate, onBetUpdate);
        uiView.addMessageListener(UIViewMessageType.UIResize, onUIResize);
        uiView.addMessageListener(UIViewMessageType.FastPlayUpdate, onFastPlayUpdate);
        uiView.addMessageListener(UIViewMessageType.VisibilityChanged, onVisibilityChanged);
        uiView.addMessageListener(UIViewMessageType.UiAutoPlayEnabledUpdate, onUiAutoPlayEnabledUpdate);

        uiView.addMessageListener(UIViewMessageType.PerformClicked, performClicked);

        //do not lister ScreenClick, because its dispatched from current mediator
        removeMessageListener(UIMediatorMessageType.ScreenClick, handleScreenClick);
    }

    private function updateFreePlaysValueOnResult():Void
    {
        if (roundStateModel.state == RoundState.FreePlay)
        {
            uiView.updateFreePlaysValue(appModel.freeGamesCount);
        }
    }

    private function updateFreePlaysValueOnAnimationComplete():Void
    {
        uiView.updateFreePlaysValue(appModel.freeGamesCount);
    }

    private function showPlayButton(m:IMessage = null):Void
    {
        uiView.showPlayButton(true);
    }

    private function hidePlayButton(m:IMessage = null):Void
    {
        uiView.showPlayButton(false);
    }

    private function showBetButton(m:IMessage = null):Void
    {
        uiView.showBetButton(true);
    }

    private function hideBetButton(m:IMessage = null):Void
    {
        uiView.showBetButton(false);
    }

    private function roundModelStateUpdated(m:IMessage):Void
    {
        if (appStateModel.state == AppState.RoundStarted)
        {
            handleRoundStarted();
        } else
        if (appStateModel.state == AppState.ShowingPrevResult)
        {
            handleShowingPrevResult();
        } else
        if (appStateModel.state == AppState.ShowingResult)
        {
            handleShowingResult();
        }
    }

    private function handleRoundStarted():Void
    {
        if (roundStateModel.state != RoundState.FreePlay)
        {
            prevWin = 0;

            uiView.updateWinValue(0);
        } else
        if (roundStateModel.nextState != RoundState.RoundEnd)
        {
            prevWin = appModel.roundTotalWin;
        }
    }

    private function handleShowingResult():Void
    {
        updateFreePlaysValueOnResult();
    }

    private function handleShowingPrevResult():Void
    {
        updateFreePlaysValueOnResult();

        if (!isShowingPrevFinalResults())
        {
            var value:Float = roundStateModel.state == RoundState.FreePlay ? appModel.roundTotalWin - appModel.totalWin :
            appModel.roundTotalWin;

            prevWin = value;

            uiView.updateWinValue(value);
        }
    }

    private function winValueUpdated(m:IMessage):Void
    {
        uiView.updateWinValue(m.data.value + prevWin);
    }

    private function animationCompleted(m:IMessage):Void
    {
        showPlayButton();
        updateFreePlaysValueOnAnimationComplete();
    }

    private function onFastPlayUpdate(m:IMessage):Void
    {
        //At first JS casinoUI dispatches event, then changes property
        dispatchMessage(UIMediatorMessageType.FastPlayUpdate, {value: !uiView.fastPlay});
    }

    private function performClicked(m:IMessage):Void
    {
        hidePlayButton();

        dispatchMessage(UIMediatorMessageType.Perform);
    }

    private function onUIResize(m:IMessage):Void
    {
        dispatchMessage(UIMediatorMessageType.UIResize, uiView.data);
    }

    private function onVisibilityChanged(m:IMessage):Void
    {
        trace("onVisibilityChanged " + uiView.data);

        var state:PauseState;

        if (!menuOpened)
        {
            state = uiView.data ? PauseState.UnPaused : PauseState.PausedVisualsSoundsMusic;
        } else
        {
            state = uiView.data ? PauseState.PausedVisualsSounds : PauseState.PausedVisualsSoundsMusic;
        }

        dispatchMessage(UIMediatorMessageType.VisibilityChanged, {state: state});
    }

    private function onUiAutoPlayEnabledUpdate(m:IMessage):Void
    {
        trace("onUiAutoPlayEnabledUpdate " + uiView.data);

        dispatchMessage(UIMediatorMessageType.UiAutoPlayUpdated, {value: uiView.data});
    }

    private function onMenuToggle(m:IMessage):Void
    {
        trace("onMenuToggle " + uiView.data);

        menuOpened = cast uiView.data;

        dispatchMessage(UIMediatorMessageType.MenuToggle, {menuOpened: menuOpened});
    }

    private function onOverlayToggle(m:IMessage):Void
    {
        trace("onOverlayToggle " + uiView.data);

        dispatchMessage(UIMediatorMessageType.OverlayToggle, uiView.data);
    }

    private function onMusicVolumeUpdate(m:IMessage = null):Void
    {
        trace("onMusicVolumeUpdate " + uiView.data);

        dispatchMessage(UIMediatorMessageType.MusicVolumeUpdate, {volume: uiView.data / 100 });
    }

    private function onSoundVolumeUpdate(m:IMessage = null):Void
    {
        trace("onSoundVolumeUpdate " + uiView.data);

        dispatchMessage(UIMediatorMessageType.SoundVolumeUpdate, {volume: uiView.data / 100 });
    }

    private function onQuickPlayUpdate(m:IMessage):Void
    {
        trace("QuickPlayUpdate " + uiView.data);

        dispatchMessage(UIMediatorMessageType.QuickPlayUpdate, uiView.data);
    }

    private function onScreenClick(m:IMessage):Void
    {
        trace("onScreenClick " + uiView.data);

        dispatchMessage(UIMediatorMessageType.ScreenClick, uiView.data);
    }

    private function onBetUpdate(m:IMessage):Void
    {
        trace("onBetUpdate " + uiView.data);

        if (uiView.data.value != null)
        {
            dispatchMessage(UIMediatorMessageType.BetUpdate, {
                total: uiView.data.total, __total: "Float",
                value: uiView.data.value, __value: "Float",
                amount: uiView.data.amount, __amount: "Int"
            });
        }
    }

    private function onButtonClick(m:IMessage):Void
    {
        trace("onButtonClick " + uiView.data);

        dispatchMessage(UIMediatorMessageType.ButtonClick, uiView.data);
    }

    public function get_fastPlay():Bool
    {
        return uiView.fastPlay;
    }
}

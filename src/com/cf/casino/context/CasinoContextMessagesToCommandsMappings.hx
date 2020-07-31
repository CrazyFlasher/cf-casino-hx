package com.cf.casino.context;

class CasinoContextMessagesToCommandsMappings extends AbstractMessagesToCommandsMappings
{
    override private function mapMessagesToCommands():Void
    {
        map(PauseModelMessageType.PauseStateChanged, HandlePauseCommand);

        map1(CommunicatorMessageType.HandleInit, [LoadResourcesCommand, HandleInitCommand]);
        map(CommunicatorMessageType.HandleStart, UpdateAppStateCommand, {state: AppState.Ready});
        map(CommunicatorMessageType.HandleRoundStart, UpdateAppStateCommand, {state: AppState.RoundStarted});
        map1(CommunicatorMessageType.HandleError, [HandleErrorCommand, UpdateAppStateCommand], {state: AppState.Error});
        map1(CommunicatorMessageType.HandleResult, [UpdateModelsCommand, UpdateAppStateCommand], {state: AppState.ShowingResult});
        map1(CommunicatorMessageType.HandlePrevResult, [UpdateModelsCommand, UpdateAppStateCommand], {state: AppState.ShowingPrevResult});
        map1(CommunicatorMessageType.HandleUnfinishedGame, [UpdateModelsCommand, UpdateAppStateCommand], {state: AppState.Unfinished});

        map(ResourceServiceMessageType.LoadProgress, HandlePreloadProgressCommand);
        map1(ResourceServiceMessageType.LoadComplete, [UpdateAppStateCommand, HandlePreloadCompleteCommand], {state: AppState.AssetsLoaded});

        map(MediatorMessageType.ShowResultsCompleted, HandleResultsShownCommand);

        map(UIMediatorMessageType.UIResize, ResizeCommand);
        map(UIMediatorMessageType.Perform, PerformCommand);
        map(UIMediatorMessageType.FastPlayUpdate, UpdateFastPlayCommand);
        map(UIMediatorMessageType.MenuToggle, HandleMenuStateChangedCommand);
        map(UIMediatorMessageType.VisibilityChanged, UpdatePauseStateCommand);
        map(UIMediatorMessageType.BetUpdate, UpdateBetCommand);
        map(UIMediatorMessageType.UiAutoPlayUpdated, UpdateUiAutoPlayCommand);
    }
}

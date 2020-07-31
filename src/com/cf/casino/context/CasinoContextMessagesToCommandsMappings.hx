package com.cf.casino.context;

import com.cf.casino.commands.UpdateUiAutoPlayCommand;
import com.cf.casino.commands.UpdateBetCommand;
import com.cf.casino.commands.UpdatePauseStateCommand;
import com.cf.casino.commands.HandleMenuStateChangedCommand;
import com.cf.casino.commands.UpdateFastPlayCommand;
import com.cf.casino.commands.PerformCommand;
import com.cf.casino.commands.ResizeCommand;
import com.cf.casino.mediators.ui.UIMediatorMessageType;
import com.cf.casino.commands.HandleResultsShownCommand;
import com.cf.casino.mediators.MediatorMessageType;
import com.cf.casino.commands.HandlePreloadCompleteCommand;
import com.cf.devkit.services.resources.ResourceServiceMessageType;
import com.cf.casino.commands.HandlePreloadProgressCommand;
import com.cf.casino.commands.UpdateModelsCommand;
import com.cf.casino.commands.HandleErrorCommand;
import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.commands.UpdateAppStateCommand;
import com.cf.casino.commands.HandleInitCommand;
import com.cf.casino.commands.LoadResourcesCommand;
import com.cf.casino.services.communicator.CommunicatorMessageType;
import com.cf.casino.commands.HandlePauseCommand;
import com.cf.devkit.models.pause.PauseModelMessageType;

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

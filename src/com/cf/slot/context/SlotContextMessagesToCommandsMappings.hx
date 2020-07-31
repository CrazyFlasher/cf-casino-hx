package com.cf.slot.context;

import com.cf.slot.commands.guards.AppStateIsAssetsLoadedStateGuards;
import com.cf.casino.commands.HandlePreloadCompleteCommand;
import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.commands.UpdateAppStateCommand;
import com.cf.casino.models.state.StateModelMessageType;
import com.cf.devkit.services.resources.ResourceServiceMessageType;
import com.cf.casino.context.CasinoContextMessagesToCommandsMappings;

class SlotContextMessagesToCommandsMappings extends CasinoContextMessagesToCommandsMappings
{
    override private function mapMessagesToCommands():Void
    {
        super.mapMessagesToCommands();

        cm.unmapAll(ResourceServiceMessageType.LoadComplete);

        #if !useStarling
        map(ResourceServiceMessageType.LoadComplete, PrerenderSymbolsCommand, null, true, true);

        map(StateModelMessageType.StateUpdated, UpdateAppStateCommand, {state: AppState.AssetsLoaded}, true, true)
            .addGuards(AppStateIsPrerenderCompleteStateGuards);
        #else
        map(ResourceServiceMessageType.LoadComplete, UpdateAppStateCommand, {state: AppState.AssetsLoaded}, false);
        #end

        map(StateModelMessageType.StateUpdated, HandlePreloadCompleteCommand, null, true, true)
            .addGuards(AppStateIsAssetsLoadedStateGuards);
    }
}

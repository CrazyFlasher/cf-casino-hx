package com.cf.slot.commands.guards;

import com.cf.casino.models.state.enums.AppState;
import com.cf.casino.models.state.IStateModel;
import com.cf.devkit.commands.guards.AbstractAppGuards;

class AppStateIsPrerenderCompleteStateGuards extends AbstractAppGuards
{
    @Inject("appStateModel")
    private var appStateModel:IStateModel;

    override private function get_allows():Bool
    {
        super.get_allows();

        return appStateModel.state == AppState.PrerenderComplete;
    }
}

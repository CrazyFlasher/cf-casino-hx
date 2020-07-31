package com.cf.slot.commands.guards;

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

package com.cf.casino.commands;

import com.cf.casino.models.state.IStateModel;
import com.cf.devkit.commands.AbstractAppCommand;

class UpdateAppStateCommand extends AbstractAppCommand
{
    @Inject("appStateModel")
    private var appStateModel:IStateModel;

    @Inject("state")
    private var state:EnumValue;

    override public function execute():Void
    {
        super.execute();

        trace(state);

        appStateModel.setState(state);
    }
}

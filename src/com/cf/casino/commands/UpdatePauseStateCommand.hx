package com.cf.casino.commands;

import com.cf.devkit.models.pause.IPauseModel;
import com.cf.devkit.commands.AbstractAppCommand;

class UpdatePauseStateCommand extends AbstractAppCommand
{
    @Inject
    private var pauseModel:IPauseModel;

    @Inject("state")
    private var state:EnumValue;

    override public function execute():Void
    {
        super.execute();

        pauseModel.setState(state);
    }
}

package com.cf.casino.commands;

import com.cf.devkit.commands.AbstractAppCommand;
import com.cf.casino.services.communicator.ICommunicatorService;

class InitializeCommand extends AbstractAppCommand
{
    @Inject
    private var comService:ICommunicatorService;

    override public function execute():Void
    {
        super.execute();

        comService.init();
    }
}

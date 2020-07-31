package com.cf.casino.commands;

import com.cf.casino.services.communicator.ICommunicatorService;
import com.cf.devkit.commands.AbstractAppCommand;

class PerformCommand extends AbstractAppCommand
{
    @Inject
    private var comService:ICommunicatorService;

    override public function execute():Void
    {
        super.execute();

        comService.perform();
    }
}

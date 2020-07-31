package com.cf.casino.commands;

import com.cf.devkit.services.resources.IResourceService;
import com.cf.devkit.commands.AbstractAppCommand;
import com.cf.casino.services.communicator.ICommunicatorService;

class HandlePreloadProgressCommand extends AbstractAppCommand
{
    @Inject
    private var comService:ICommunicatorService;

    @Inject
    private var resService:IResourceService;

    override public function execute():Void
    {
        #if debug
        logExecution = false;
        #end

        super.execute();

        comService.updatePreloadingProgress(resService.progress);
    }
}

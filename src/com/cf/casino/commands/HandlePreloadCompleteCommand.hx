package com.cf.casino.commands;

import com.cf.devkit.services.resources.IResourceService;
import com.cf.casino.services.communicator.ICommunicatorService;
import com.cf.devkit.commands.AbstractAppCommand;

class HandlePreloadCompleteCommand extends AbstractAppCommand
{
    @Inject
    private var comService:ICommunicatorService;

    @Inject
    private var resService:IResourceService;

    override public function execute():Void
    {
        super.execute();

        comService.preloadingComplete();
    }
}

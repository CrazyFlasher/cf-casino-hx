package com.cf.casino.commands;

import com.cf.devkit.commands.AbstractAppCommand;
import com.cf.devkit.services.resources.IResourceService;

class LoadResourcesCommand extends AbstractAppCommand
{
    @Inject
    private var resService:IResourceService;

    override public function execute():Void
    {
        super.execute();

        resService.loadFromManifest();
    }
}

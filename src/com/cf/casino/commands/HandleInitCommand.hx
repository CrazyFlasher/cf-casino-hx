package com.cf.casino.commands;

import com.cf.casino.services.communicator.ICommunicatorService;
import com.cf.casino.models.initData.IInitDataModel;
import com.cf.devkit.commands.AbstractAppCommand;

class HandleInitCommand extends AbstractAppCommand
{
    @Inject
    private var initDataModel:IInitDataModel;

    @Inject
    private var comService:ICommunicatorService;

    override public function execute():Void
    {
        super.execute();

        initDataModel.populate(comService.initData);
    }
}

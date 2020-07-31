package com.cf.casino.commands;

import com.cf.casino.models.app.IAppModel;
import com.cf.devkit.commands.AbstractAppCommand;

class UpdateUiAutoPlayCommand extends AbstractAppCommand
{
    @Inject
    private var appModel:IAppModel;

    @Inject("value")
    private var value:Bool;

    override public function execute():Void
    {
        super.execute();

        appModel.setUiAutoPlayEnabled(value);
    }
}

package com.cf.casino.commands;

import com.cf.devkit.trace.Trace;
import com.cf.casino.models.payload.IPayloadModel;
import com.cf.casino.services.communicator.ICommunicatorService;
import com.cf.devkit.commands.AbstractAppCommand;

class UpdatePayloadCommand extends AbstractAppCommand
{
    @Inject
    private var comService:ICommunicatorService;

    @Inject("value")
    @Optional
    private var value:String;

    @Inject("notify")
    @Optional
    private var notify:Bool;

    @Inject
    private var payloadModel:IPayloadModel;

    override public function execute():Void
    {
        super.execute();

        trace("Request payload:", value, Trace.INFO);

        payloadModel.setValue(value, notify);
    }
}

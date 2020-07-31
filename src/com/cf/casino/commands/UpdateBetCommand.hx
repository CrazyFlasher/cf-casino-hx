package com.cf.casino.commands;

import com.cf.devkit.trace.Trace;
import com.cf.casino.models.app.IAppModel;
import com.cf.devkit.commands.AbstractAppCommand;

class UpdateBetCommand extends AbstractAppCommand
{
    @Inject("total")
    private var total:Float;

    @Inject("value")
    private var value:Float;

    @Inject("amount")
    private var amount:Int;

    @Inject
    private var appModel:IAppModel;

    override public function execute():Void
    {
        super.execute();

        trace(value, amount, total, Trace.INFO);

        appModel.setBetValue(value);
        appModel.setBetAmount(amount);
        appModel.setTotalBetValue(total);
    }
}

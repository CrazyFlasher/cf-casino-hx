package com.cf.slot.commands;

import com.cf.slot.models.reels.IReelsModel;

class HandleInitCommand extends com.cf.casino.commands.HandleInitCommand
{
    @Inject
    private var reelsModel:IReelsModel;

    override public function execute():Void
    {
        super.execute();

        reelsModel.populate(cast comService.initData.reelStripsBG, cast comService.initData.reelStripsFG);
    }
}

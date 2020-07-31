package com.cf.casino.commands;

import com.cf.devkit.models.pause.PauseState;
import com.cf.devkit.commands.AbstractAppCommand;
import com.cf.devkit.models.pause.IPauseModel;
import motion.Actuate;
import zygame.utils.SpineManager;

class HandlePauseCommand extends AbstractAppCommand
{
    @Inject
    private var pauseModel:IPauseModel;

    override public function execute():Void
    {
        super.execute();

        if (pauseModel.state != PauseState.UnPaused)
        {
            SpineManager.pause();
            Actuate.pauseAll();

            #if useStarling
            starling.core.Starling.current.stop(false);
            #end
        } else
        {
            SpineManager.resume();
            Actuate.resumeAll();

            #if useStarling
            starling.core.Starling.current.start();
            #end
        }
    }
}

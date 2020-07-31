package com.cf.casino.commands;

import com.cf.devkit.models.pause.PauseState;
import com.cf.devkit.commands.AbstractAppCommand;
import com.domwires.core.mvc.command.ICommandMapper;

class HandleMenuStateChangedCommand extends AbstractAppCommand
{
    @Inject
    private var commandMapper:ICommandMapper;

    @Inject("menuOpened")
    private var menuOpened:Bool;

    override public function execute():Void
    {
        super.execute();

        var state:PauseState = menuOpened ? PauseState.PausedVisualsSounds : PauseState.UnPaused;

        commandMapper.executeCommand(UpdatePauseStateCommand, {state: state});
    }
}

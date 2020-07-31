package com.cf.casino.commands;

import com.cf.casino.models.win.IWinsModel;
import com.cf.devkit.commands.AbstractAppCommand;

class HandleErrorCommand extends AbstractAppCommand
{
	@Inject
	private var winsModel:IWinsModel;

	override public function execute():Void
	{
		super.execute();

		winsModel.clear();
	}
}

package com.cf.casino.models.win.singleWin;

import com.domwires.core.mvc.model.IModelContainer;

interface ISingleWinModel extends ISingleWinModelImmutable extends IModelContainer
{
	var isBusy(get, never):Bool;

	function update(vo:SingleWinVo):ISingleWinModel;
}

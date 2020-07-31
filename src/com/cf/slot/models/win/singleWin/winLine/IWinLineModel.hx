package com.cf.slot.models.win.singleWin.winLine;

import com.domwires.core.mvc.model.IModel;

interface IWinLineModel extends IWinLineModelImmutable extends IModel
{
	function update(vo:WinLineVo):IWinLineModel;
}

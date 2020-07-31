package com.cf.casino.models.win;

import com.domwires.core.mvc.model.IModelContainer;

interface IWinsModel extends IWinsModelImmutable extends IModelContainer
{
    function update(vo:WinsVo):IWinsModel;
    function clear():IWinsModel;
}

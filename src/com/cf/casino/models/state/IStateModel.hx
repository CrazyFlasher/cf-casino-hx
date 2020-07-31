package com.cf.casino.models.state;

import com.domwires.core.mvc.model.IModel;

interface IStateModel extends IStateModelImmutable extends IModel
{
    function setState(value:EnumValue):IStateModel;
    function setNextState(value:EnumValue):IStateModel;
}

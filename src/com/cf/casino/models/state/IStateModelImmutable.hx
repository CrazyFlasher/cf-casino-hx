package com.cf.casino.models.state;

import com.domwires.core.mvc.model.IModelImmutable;

interface IStateModelImmutable extends IModelImmutable
{
    var state(get, never):EnumValue;
    var nextState(get, never):EnumValue;
    var prevState(get, never):EnumValue;
}

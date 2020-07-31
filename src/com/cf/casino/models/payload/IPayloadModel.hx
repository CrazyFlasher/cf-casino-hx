package com.cf.casino.models.payload;

import com.domwires.core.mvc.model.IModel;

interface IPayloadModel extends IPayloadModelImmutable extends IModel
{
    function setValue(value:Dynamic, notify:Bool = true):IPayloadModel;
}

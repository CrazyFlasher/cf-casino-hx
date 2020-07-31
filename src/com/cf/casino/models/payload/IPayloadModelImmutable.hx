package com.cf.casino.models.payload;

import com.domwires.core.mvc.model.IModelImmutable;

interface IPayloadModelImmutable extends IModelImmutable
{
    var value(get, never):Dynamic;
}

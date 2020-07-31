package com.cf.casino.models.texts;

import com.domwires.core.mvc.model.IModelImmutable;

interface ITextsModelImmutable extends IModelImmutable
{
    function get(key:String):String;
}

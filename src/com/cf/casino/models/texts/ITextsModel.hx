package com.cf.casino.models.texts;

import com.domwires.core.mvc.model.IModel;

interface ITextsModel extends ITextsModelImmutable extends IModel
{
    function set(key:String, value:String):ITextsModel;
    function clear():ITextsModel;
}

package com.cf.casino.models.initData;

import com.domwires.core.mvc.model.IModel;

interface IInitDataModel extends IInitDataModelImmutable extends IModel
{
    function populate(value:Dynamic):IInitDataModel;
}

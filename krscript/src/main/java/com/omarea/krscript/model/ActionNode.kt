package com.omarea.krscript.model

class ActionNode(currentConfigXml: String) : RunnableNode(currentConfigXml){
    var params: ArrayList<ActionParamInfo>? = null
}

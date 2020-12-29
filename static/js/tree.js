var setting = {
    check: {
        enable: true,
    },
    data: {
        simpleData: {
            enable: true,
        },
    },
    callback: {
        // onClick: addSubNode,
        onExpand: expandNode
    }
}
var zNodes;
var zTree;

function expandNode(event, treeId, treeNode) {
    if (!treeNode.isParent) return;
    var data = treeNode.children;
    preLoadNode(data);
}

function wrapAjax(myJson) {
    $.ajax({
        cache: true,
        url: "getunionjson",
        type: "POST",
        dataType: "json",
        data: { sId: myJson },
        async: false,
        success: function (data) {
            addSubNodes(data);
        },
        error: function (data) {
            console.log(data);
        },
    });
}

function addSubNodes(data) {
    for (var val in data) {
        parentNode = zTree.getNodeByParam('id', val)
        console.log("preoload: " + parentNode.name)
        zTree.addNodes(parentNode, data[val], isSilent = true)
    }
}

function preLoadNode(rawData) {
    if (rawData == undefined) rawData = zTree.getNodes();
    var data_list = [];
    for (var p in rawData) {//遍历json对象的每个key/value对,p为key
        if (rawData[p].isParent == 1 && rawData[p].children == undefined) {
            data_list.push(rawData[p].id);
        }
    }
    if (data_list.length != 0)
        wrapAjax(JSON.stringify(data_list));
}

function onLoadTree() {
    $.ajax({
        cache: true,
        url: "getjson",
        type: "GET",
        dataType: "json",
        async: true,
        success: function (data) {
            zNodes = data;
            zTree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            preLoadNode(zTree.getNodes());
        },
        error: function (data) {
            console.log(error);
        },
    });
}

$(function () {
    onLoadTree();
});

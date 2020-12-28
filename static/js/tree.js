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
        onExpand: addSubNode
    }
}
var zNodes;
var zTree;

function addSubNode(event, treeId, treeNode) {
    if (!treeNode.isParent) return;
    var data = treeNode.children;
    preLoadNode(data);
}

function wrapAjax(myJson){
    $.ajax({
        cache: true,
        url: "getjson",
        type: "GET",
        dataType: "json",
        data: { sId: myJson.id },
        async: true,
        success: function (data) {
            console.log("preload: " + myJson.name);
            zTree.addNodes(myJson, data, isSilent = true);
        },
        error: function (data) {
            console.log(data);
        },
    });
}

function preLoadNode(rawData) {
    if (!rawData) rawData = zTree.getNodes();
    for (var p in rawData) {//遍历json对象的每个key/value对,p为key
        if (rawData[p].isParent == 1 && rawData[p].children == undefined) {
            wrapAjax(rawData[p]);
        }
    }
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

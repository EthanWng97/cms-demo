var setting = {
    check: {
        enable: true,
    },
    data: {
        simpleData: {
            enable: true,
        },
    },
    async: { // 属性配置
        enable: true,
        url: "getjson",
        autoParam: ["id=sId"],
        type: 'get',
        dataType: "json"
    },
    callback: {
        onExpand: expandNode
    }
}
var zNodes;
var zTree;
//获取树成功后进行的回调操作

function expandNode(event, treeId, treeNode) {
    if (!treeNode.isParent) return;
    var data = treeNode.children;
    preLoadNode(data);
}

function preLoadNode(rawData) {
    if (!rawData) rawData = zTree.getNodes();
    for (var p in rawData) {//遍历json对象的每个key/value对,p为key
        if (rawData[p].isParent == 1 && rawData[p].children == undefined) {
            console.log("preload: " + rawData[p].name);
            zTree.reAsyncChildNodesPromise(rawData[p], "refresh", isSilent = true);
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

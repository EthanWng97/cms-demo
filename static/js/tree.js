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
    var s = treeNode.children;
    if (s != undefined)
        return;
    // console.log(treeNode.id)
    $.ajax({
        cache: true,
        url: "getjson",
        type: "GET",
        dataType: "json",
        data: { sId: treeNode.id },
        async: true,
        success: function (data) {
            // var newNodes = [{ name: "newNode1" }, { name: "newNode2" }, { name: "newNode3" }];
            // console.log(data)
            zTree.addNodes(treeNode, data);
            preLoadNode(data);
        },
        error: function (data) {
            alert("error");
        }
    });

}

function preLoadNode(rawData) {
    for (var p in rawData) {//遍历json对象的每个key/value对,p为key
        if (rawData[p].isParent == 1) {
            console.log("preload: " + rawData[p].name + "id: " + rawData[p].id);
            $.ajax({
                cache: true,
                url: "getjson",
                type: "GET",
                dataType: "json",
                data: { sId: rawData[p].id },
                async: true,
                success: function (data) {
                    zTree.addNodes(rawData[p], data);
                },
                error: function (data) {
                    console.log(data);
                },
            });
        }
    }
}

function onLoadTree() {
    $.ajax({
        cache: true,
        url: "getjson",
        type: "GET",
        dataType: "json",
        async: false,
        success: function (data) {
            zNodes = data;
        },
        error: function () {
            console.log(error);
        },
    });
    zTree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
    preLoadNode(zNodes);
}

$(function () {
    onLoadTree();
});

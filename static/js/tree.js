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
    console.log(treeNode.id)
    $.ajax({
        cache: true,
        url: "getjson",
        type: "GET",
        dataType: "json",
        data: { sId: treeNode.id },
        async: true,
        success: function (data) {
            // var newNodes = [{ name: "newNode1" }, { name: "newNode2" }, { name: "newNode3" }];
            console.log(data)
            // console.log(newNodes)
            zTree.addNodes(treeNode, data);
        },
        error: function (data) {
            alert("error");
        }
    });

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
}

$(function () {
    onLoadTree();
});

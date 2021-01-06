var setting = {
    views: {
        // addHoverDom: addHoverDom, //当鼠标移动到节点上时，显示用户自定义控件
        // removeHoverDom: removeHoverDom, //离开节点时的操作
        // selectedMulti: false
        dblClickExpand: false
    },
    data: {
        simpleData: {
            enable: true,
        },
    },
    edit: {
        enable: true,
        editNameSelectAll: true,
        showRemoveBtn: true,
        removeTitle: "删除节点",
        showRenameBtn: true,
        renameTitle: "编辑节点"
    },
    callback: {
        onExpand: expandNode,
        beforeRemove: beforeRemove,  // determine whether the node can be deleted
        beforeRename: beforeRename,   // determine whether the node can be renamed
        onRemove: onRemove,
        // onRename: onRename,
        // beforeDrag: beforeDrag,
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
        error: function (error) {
            console.log(error);
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
        url: "getunionjson",
        type: "POST",
        dataType: "json",
        async: true,
        success: function (data) {
            zNodes = data["0"];
            zTree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            preLoadNode(zTree.getNodes());
        },
        error: function (error) {
            console.log(error);
        },
    });
}

$(function () {
    onLoadTree();
});

var tree = {
    zTree: '',
    pTreeId: '',
    pTreeNode: '',
    setting: {
        view: {
            dblClickExpand: false
        },
        data: {
            simpleData: {
                enable: true,
            },
        },
        // edit: {
        //     enable: true,
        //     editNameSelectAll: true,
        //     showRemoveBtn: true,
        //     removeTitle: "删除节点",
        //     showRenameBtn: true,
        //     renameTitle: "编辑节点"
        // },
        callback: {
            onExpand: expandNode,
            // beforeRemove: beforeRemove, // determine whether the node can be deleted
            // beforeRename: beforeRename, // determine whether the node can be renamed
            // onRemove: onRemove,
            onRightClick: onRightClick,
            // onRename: onRename,
            // beforeDrag: beforeDrag,
        }
    },
    preLoadNode: function (rawData) {
        if (rawData == undefined) rawData = tree.zTree.getNodes();
        var data_list = [];
        for (var p in rawData) { //遍历json对象的每个key/value对,p为key
            if (rawData[p].isParent == 1 && rawData[p].children == undefined) {
                data_list.push(rawData[p].id);
            }
        }
        if (data_list.length != 0) {
            var sendData = {
                sId: JSON.stringify(data_list)
            };
            wrapAjax(true, "getunionjson", "POST", "json", sendData, false, function (data) {
                tree.addSubNodes(data);
            }, function (error) {
                console.log(error);
            });
        }
    },
    addSubNodes: function (data) {
        for (var val in data) {
            parentNode = tree.zTree.getNodeByParam('id', val)
            console.log("preoload: " + parentNode.name)
            tree.zTree.addNodes(parentNode, data[val], isSilent = true)
        }
    }
}

$(function () {
    onLoadTree();
});
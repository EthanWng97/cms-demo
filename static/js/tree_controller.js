var method = "async"
var tree;
if(method == "normal"){
    tree = {
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
            callback: {
                onExpand: expandNode,
                onRightClick: onRightClick,
                onDblClick: onDblClick,
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
                wrapAjax(true, "dataset/load", "POST", "json", sendData, false, function (data) {
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

}
else if (method == "async"){
    tree = {
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
            async: { // 属性配置
                enable: true,
                url: "dataset/load",
                otherParam: getParam,
                type: 'post',
                dataType: "json",
                dataFilter: dataFilter
            },
            callback: {
                onExpand: expandNode,
                onRightClick: onRightClick,
                onDblClick: onDblClick,
            }
        },
        preLoadNode: function (rawData) {
            if (!rawData) rawData = tree.zTree.getNodes();
            for (var p in rawData) { //遍历json对象的每个key/value对,p为key
                if (rawData[p].isParent == 1 && rawData[p].children == undefined) {
                    console.log("preload: " + rawData[p].name);
                    tree.zTree.reAsyncChildNodesPromise(rawData[p], "refresh", isSilent = true);
                }
            }
        }
    }
}

function getParam(treeId, treeNode) {
    var data_list = [];
    data_list.push(treeNode.id);
    var jsonObj = {
        "sId": JSON.stringify(data_list)
    };
    return jsonObj
}

function dataFilter(treeId, parentNode, responseData) {
    if (responseData) {
        return responseData[parentNode.id];
    }
}

function onLoadTree() {
    wrapAjax(true, "dataset/load", "POST", "json", null, true, function (data) {
        zNodes = data["0"];
        tree.zTree = $.fn.zTree.init($("#treeDemo"), tree.setting, zNodes);
        tree.preLoadNode(tree.zTree.getNodes());
    }, function (error) {
        console.log(error);
    });
}

function expandNode(event, treeId, treeNode) {
    if (!treeNode.isParent) return;
    var data = treeNode.children;
    tree.preLoadNode(data);
};

function beforeRename(treeId, treeNode, newName, isCancel) {
    if (isCancel == true) return
    if (newName.length == 0) {
        layer.msg("节点名称不能为空.");
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
        setTimeout(function () {
            zTree.editName(treeNode)
        }, 10);
        return false;
    }
    return true;
}

function beforeRemove(treeNode) {
    if (treeNode.children != undefined) {
        layer.msg("请先删除子项表。");
        return false;
    }
    return true;
}

function onRemove(treeNode) {
    jsonObj = createActionJson(type = "del");
    var sendData = {
        action: jsonObj
    };
    wrapAjax(true, "dataset/action", "POST", "json", sendData, true, function (data) {
        var msg = data[0].info[0]._einfo
        layer.msg(msg);
        if (msg.indexOf("success") != -1) {
            tree.zTree.removeNode(treeNode);
        }
    }, function (error) {
        console.log(error);
    });
}

function onRightClick(event, treeId, treeNode) {
    tree.pTreeId = treeId;
    tree.pTreeNode = treeNode;
    var x = event.clientX;
    var y = event.clientY;

    $('#directory-tree-menu').css({
        left: x + 'px',
        top: y + 'px'
    }).show();

    $(document).on('mousedown', function (event) {
        if (!(event.target.id == 'directory-tree-menu' || $(event.target).parents('#directory-tree-menu').length > 0)) {
            hideMenu();
        }
    });
}

function onDblClick(event, treeId, treeNode) {
    if (treeNode != null)
        showTab(treeNode.name, null, treeNode.id);
};

function hideMenu() {
    $('#directory-tree-menu').hide();
    $(document).off('mousedown');
}

$(document).on('click', '#menu-item-addRoot', function () {
    hideMenu();
    console.log("添加根");
});
$(document).on('click', '#menu-item-addTable', function () {
    hideMenu();
    console.log("添加[列表]");
});
$(document).on('click', '#menu-item-addRela', function () {
    hideMenu();
    console.log("添加[关联]");
});
$(document).on('click', '#menu-item-modify', function () {
    hideMenu();
    showForm('springtb', tree.pTreeNode)
});
$(document).on('click', '#menu-item-delete', function () {
    hideMenu();
    if (beforeRemove(tree.pTreeNode)) onRemove(tree.pTreeNode);
});
$(document).on('click', '#menu-item-clip', function () {
    hideMenu();
    console.log("剪切[表]");
});
$(document).on('click', '#menu-item-sort', function () {
    hideMenu();
    console.log("排序");
});
$(document).on('click', '#menu-item-translate', function () {
    hideMenu();
    console.log("翻译");
});
$(document).on('click', '#menu-item-edit', function () {
    hideMenu();
    console.log("编辑");
});
$(document).on('click', '#menu-item-manageList', function () {
    hideMenu();
    console.log("列表分组管理");
});
$(document).on('click', '#menu-item-procedure', function () {
    hideMenu();
    console.log("存储过程");
});
$(document).on('click', '#menu-item-exportModel', function () {
    hideMenu();
    console.log("模型导出");
});
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
                wrapAjax(true, "dataset/tree", "POST", "json", sendData, false, function (data) {
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
                url: "dataset/tree",
                otherParam: otherParam,
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
/**
 * Description. 用于异步加载post参数的构建
 *
 * @param {JSON}   treeNode 节点的 JSON 数据对象
 *
 * @return {JSON}  jsonObj 参数列表
 */
function otherParam(treeId, treeNode) {
    var data_list = [];
    data_list.push(treeNode.id);
    var jsonObj = {
        "sId": JSON.stringify(data_list)
    };
    return jsonObj
}

/**
 * Description. 用于异步加载返回数据的筛选
 *
 * @param {JSON}   treeNode 节点的 JSON 数据对象
 * @param {JSON}   responseData 数据接口返回数据
 *
 * @return {JSON}  jsonObj 参数列表
 */
function dataFilter(treeId, parentNode, responseData) {
    if (responseData) {
        return responseData[parentNode.id];
    }
}

/**
 * Description. 加载树，当网页加载完进行自动加载
 */
function onLoadTree() {
    wrapAjax(true, "dataset/tree", "POST", "json", null, true, function (data) {
        zNodes = data["0"];
        tree.zTree = $.fn.zTree.init($("#treeDemo"), tree.setting, zNodes);
        tree.preLoadNode(tree.zTree.getNodes());
    }, function (error) {
        console.log(error);
    });
}

/**
 * Description. 展开父节点的回调函数
 *
 * @param {JSON}   treeNode 节点的 JSON 数据对象
 *
 */
function expandNode(event, treeId, treeNode) {
    if (!treeNode.isParent) return;
    var data = treeNode.children;
    tree.preLoadNode(data);
};

/**
 * Description. 重命名前的回调函数，用来判断节点是否满足重命名条件
 *
 * @param {JSON}   treeNode 节点的 JSON 数据对象
 * @param {string}   newName 新节点名称
 * @param {bool}   isCancel 是否取消操作
 * 
 * @return {bool}  返回该节点是否可以重命名
 */
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

/**
 * Description. 删除前的回调函数，用来判断节点是否满足删除条件
 *
 * @param {JSON}   treeNode 节点的 JSON 数据对象
 * 
 * @return {bool}  返回该节点是否可以删除
 */
function beforeRemove(treeNode) {
    if (treeNode.children != undefined) {
        layer.msg("请先删除子项表。");
        return false;
    }
    return true;
}

/**
 * Description. 删除节点的回调函数
 *
 * @param {Object}   treeNode 节点信息
 * 
 */
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

/**
 * Description. 鼠标右键点击节点的回调函数
 *
 * @param {event}   event  js event 对象
 * @param {string}   treeId 节点id
 * @param {JSON}   treeNode 鼠标右键点击时所在节点的 JSON 数据对象
 * 
 */
function onRightClick(event, treeId, treeNode) {
    tree.pTreeId = treeId;
    tree.pTreeNode = treeNode;
    showTreeMenu(event, treeId, treeNode);
}

/**
 * Description. 显示右键菜单
 *
 * @param {event}   event  js event 对象
 * @param {string}   treeId 节点id
 * @param {JSON}   treeNode 鼠标右键点击时所在节点的 JSON 数据对象
 * 
 */
function showTreeMenu(event, treeId, treeNode) {
    layui.dropdown.render({
        elem: '#ztree', //也可绑定到 document，从而重置整个右键
        trigger: 'contextmenu', //contextmenu
        show: true,            
        id: 'tree-menu', //定义唯一索引
        data: treeMenuItem,
        click: function (obj, othis) {
            if(!treeNode) return;
            if (obj.id === 'modify') {
                showForm('springtb', tree.pTreeNode)
            } else if (obj.id === 'delete') {
                if (beforeRemove(tree.pTreeNode)) onRemove(tree.pTreeNode);
            } else {
                layui.layer.alert(obj.title);
            }
        }
    });
}

/**
 * Description. 鼠标双击点击节点的回调函数
 *
 * @param {event}   event  js event 对象
 * @param {string}   treeId 节点id
 * @param {JSON}   treeNode 鼠标右键点击时所在节点的 JSON 数据对象
 * 
 */
function onDblClick(event, treeId, treeNode) {
    tree.pTreeId = treeId;
    tree.pTreeNode = treeNode;
    if(treeNode == null) return;
    if (treeNode.isParent == true){
        expandNode(event, treeId, treeNode);
        tree.zTree.expandNode(treeNode);
    }    
    else
        showTab(treeNode.name, null, treeNode.id);
};
var tree = {
    zTree: '',
    pNode: '',
    setting: {
        data: {
            simpleData: {
                enable: true,
            },
        },
        async: { // 属性配置
            enable: true,
            url: "getunionjson",
            otherParam: getParam,
            type: 'post',
            dataType: "json",
            dataFilter: dataFilter
        },
        callback: {
            onExpand: expandNode,
            onRightClick: onRightClick,
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
var zNodes;
var zTree;

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

$(function () {
    onLoadTree();
});
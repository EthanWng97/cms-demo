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
            onExpand: expandNode
        }
    },
    preLoadNode: function (rawData) {
        if (!rawData) rawData = tree.zTree.getNodes();
        for (var p in rawData) {//遍历json对象的每个key/value对,p为key
            if (rawData[p].isParent == 1 && rawData[p].children == undefined) {
                console.log("preload: " + rawData[p].name);
                tree.zTree.reAsyncChildNodesPromise(rawData[p], "refresh", isSilent = true);
            }
        }
    }
}
// var setting = {
//     data: {
//         simpleData: {
//             enable: true,
//         },
//     },
//     async: { // 属性配置
//         enable: true,
//         url: "getunionjson",
//         otherParam: getParam,
//         type: 'post',
//         dataType: "json",
//         dataFilter: dataFilter
//     },
//     callback: {
//         onExpand: expandNode
//     }
// }
var zNodes;
var zTree;
//获取树成功后进行的回调操作

function getParam(treeId, treeNode) {
    var data_list = [];
    data_list.push(treeNode.id);
    var jsonObj = { "sId": JSON.stringify(data_list) };
    return jsonObj
}

function dataFilter(treeId, parentNode, responseData) {
    if (responseData) {
        return responseData[parentNode.id];
    }
}
// function expandNode(event, treeId, treeNode) {
//     if (!treeNode.isParent) return;
//     var data = treeNode.children;
//     preLoadNode(data);
// }

// function preLoadNode(rawData) {
//     if (!rawData) rawData = zTree.getNodes();
//     for (var p in rawData) {//遍历json对象的每个key/value对,p为key
//         if (rawData[p].isParent == 1 && rawData[p].children == undefined) {
//             console.log("preload: " + rawData[p].name);
//             zTree.reAsyncChildNodesPromise(rawData[p], "refresh", isSilent = true);
//         }
//     }
// }
// function onLoadTree() {
//     $.ajax({
//         cache: true,
//         url: "getunionjson",
//         type: "POST",
//         dataType: "json",
//         async: true,
//         success: function (data) {
//             zNodes = data["0"];
//             zTree = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
//             preLoadNode(zTree.getNodes());
//         },
//         error: function (error) {
//             console.log(error);
//         },
//     });
// }

$(function () {
    onLoadTree();
});

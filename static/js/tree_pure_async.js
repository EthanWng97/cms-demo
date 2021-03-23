var tree = {
    zTree: '',
    pNode: '',
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
    showTable();
    var pagestyle = function () {
        var container = $("#tab-container");
        var w = $(window).width() - 350;
        if (w < 100) {
            w = 100;
        }
        container.width(w);
        $("#tab-show").width(w).width(w);

        var h = $(window).height() - container.offset().top - 10;
        container.height(h);
    }
    // 窗体加载时自适应宽度
    pagestyle();
    //注册窗体改变大小事件 
    $(window).on("resize", pagestyle);
});
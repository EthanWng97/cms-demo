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
        // otherParam:{"otherParam":"zTreeAsyncTest"}, 
        type: 'get',
        dataType: "json"
    },
    callback: {
    }
}
var zNodes;
var zTree;
//获取树成功后进行的回调操作

function onLoadTree() {
    $.ajax({
        cache: true,
        url: "getjson",
        type: "GET",
        dataType: "json",
        async: true,
        success: function (data) {
            zNodes = data;
            zTree = $.fn.zTree.init($("#treeDemo"), setting, null);
        },
        error: function (data) {
            console.log(error);
        },
    });
    // console.log(zTree.getNodes());
}

$(function () {
    onLoadTree();
});

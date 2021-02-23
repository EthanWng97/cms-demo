function onLoadTree() {
    $.ajax({
        cache: true,
        url: "getunionjson",
        type: "POST",
        dataType: "json",
        async: true,
        success: function (data) {
            zNodes = data["0"];
            tree.zTree = $.fn.zTree.init($("#treeDemo"), tree.setting, zNodes);
            tree.preLoadNode(tree.zTree.getNodes());
        },
        error: function (error) {
            console.log(error);
        },
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

// function onRename(event, treeId, treeNode, isCancel) {
//     if (isCancel) {
//         return;
//     }
//     // var zTree = $.fn.zTree.getZTreeObj("treeDemo");
//     // var onodes = zTree.getNodes();
//     // console.log(onodes);
//     //发送请求修改节点信息
//     var data = {
//         "id": treeNode.id,
//         "code": treeNode.pId,  //父节点
//         "name": treeNode.name,
//     };
//     console.log(data);
//     // $.ajax({
//     //     type: 'post',
//     //     url: "",
//     //     data: data,
//     //     timeout: 1000, //超时时间设置，单位毫秒
//     //     dataType: 'json',
//     //     success: function (res) {
//     //         layer.msg(res.msg)
//     //     }
//     // });
// }

function beforeRemove(treeId, treeNode) {
    if (treeNode.children != undefined) {
        layer.msg("请先删除子项表。");
        return false;
    }
    return true;
}

function onRemove(event, treeId, treeNode){
        var data = {
        "sId": treeNode.id,
        "pId": treeNode.pId,  //父节点
        "name": treeNode.name,
    };
    var info_json = {
        "action": "del",
        "sId": treeNode.id,
        "pId": treeNode.pId,
        "tbType": 0,
        "name": "testname",
        "shortName": "testshortName",
        "description": "testdescription",
        "descriptionEn": "testdescriptionEn",
        "tbName": "testtbName",
        "fieldName": "testfieldName",
        "fieldNo": 123,
        "isFile": 0,
        "filePathNo": "testfilePathNo",
        "storedProcName": "teststoredProcName",
        "remark": "testremark",
        "sTamp": "2020-11-12 04:17:43.635664",
        "queue": 1};
    
    var data_list = [];
    data_list.push(info_json);
    var jsonObj = {
        "_userId": "",
        "_userName": "",
        "_info": JSON.stringify(data_list),
        "_entity": "123",
        "_error": "123",
        "_eInfo": "123"
    };

    $.ajax({
        cache: true,
        url: "dataset",
        type: 'post',
        dataType: "json",
        data: { action: JSON.stringify(jsonObj) },
        // timeout: 1000, //超时时间设置，单位毫秒
        success: function (data) {
            layer.msg(data[0].info[0]._einfo);
            tree.zTree.removeNode(treeNode);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert("请求对象XMLHttpRequest: " + XMLHttpRequest);
            alert("错误类型textStatus: " + textStatus);
            alert("异常对象errorThrown: " + errorThrown);
        }
    });
}
function onRightClick(event, treeId, treeNode) {
    tree.pTreeId = treeId;
    tree.pTreeNode = treeNode;
    var type = '';
    var x = event.clientX;
    var y = event.clientY;

    $('#directory-tree-menu').css({ left: x + 'px', top: y + 'px' }).show();
    // if (treeNode.name == '数据模型') $('#menu-item-addRoot').hide();
    // else $('#menu-item-addRoot').show();

    $(document).on('mousedown', function (event) {
        if (!(event.target.id == 'directory-tree-menu' || $(event.target).parents('#directory-tree-menu').length > 0)) {
            hideMenu();
        }
    });
}
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
    console.log("修改");
});
$(document).on('click', '#menu-item-delete', function () {
    hideMenu();
    console.log("删除");
    if (beforeRemove(tree.pTreeId, tree.pTreeNode)) onRemove(event, tree.pTreeId, tree.pTreeNode);
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
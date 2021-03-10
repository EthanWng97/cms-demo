function onLoadTree() {

    wrapAjax(true, "getunionjson", "POST", "json", null, true, function (data) {
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

function createActionJson(type, treeNode) {
    var info_json = {
        "action": type,
        "sId": tree.pTreeNode.id,
        "pId": tree.pTreeNode.pId,
        "tbType": parseInt($('#tbtype').val()),
        "name": $('#name').val(),
        "shortName": $('#shortname').val(),
        "description": $('#description').val(),
        "descriptionEn": $('#descriptionen').val(),
        "tbName": $('#tbname').val(),
        "fieldName": $('#fieldname').val(),
        "fieldNo": parseInt($('#fieldno').val()),
        "isFile": $("input:checkbox[name='isfile']:checked").length == 1 ? 1 : 0,
        "filePathNo": $('#filepathno').val(),
        "storedProcName": $('#storedprocname').val(),
        "remark": $('#remark').val(),
    };

    var action_list = [];
    action_list.push(info_json);
    var jsonObj = {
        "_userId": "123",
        "_userName": "123",
        "_info": JSON.stringify(action_list),
        "_entity": "123",
        "_error": "123",
        "_eInfo": "123"
    };
    return JSON.stringify(jsonObj);
}

function beforeRemove(treeId, treeNode) {
    if (treeNode.children != undefined) {
        layer.msg("请先删除子项表。");
        return false;
    }
    return true;
}

function onRemove(event, treeId, treeNode) {
    jsonObj = createActionJson(type = "del");
    var sendData = {
        action: jsonObj
    };
    wrapAjax(true, "dataset", "POST", "json", sendData, true, function (data) {
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

function hideMenu() {
    $('#directory-tree-menu').hide();
    $(document).off('mousedown');
}

function _xname(pid, description, name) {
    if (!pid || !description)
        return name;
    return description + "[" + name + "]"
}

function loadFormData(database, treeNode) {
    $("#information").empty();
    var jsonObj = {
        "_db": database,
        "_sid": treeNode.id,
    };
    var sendData = {
        row: JSON.stringify(jsonObj)
    };
    wrapAjax(true, "dataset/rowdata", "POST", "json", sendData, true, function (data) {
        createForm(data);
    }, function (error) {
        console.log(error);
    });
}

function createForm(data) {
    for (var val in data) {
        // console.log(val + " " + data[val]);//输出如:name
        if (val == 'tbtype')
            $("#information").append(tbtype);
        else if (val == 'name')
            $("#information").append(name);
        else if (val == 'shortname')
            $("#information").append(shortname);
        else if (val == 'description')
            $("#information").append(description);
        else if (val == 'descriptionen')
            $("#information").append(descriptionen);
        else if (val == 'tbname')
            $("#information").append(tbname);
        else if (val == 'fieldname')
            $("#information").append(fieldname);
        else if (val == 'fieldno')
            $("#information").append(fieldno);
        else if (val == 'isfile')
            $("#information").append(isfile);
        else if (val == 'filepathno')
            $("#information").append(filepathno);
        else if (val == 'storedprocname')
            $("#information").append(storedprocname);
        else if (val == 'remark')
            $("#information").append(remark);
        else if (val == 'createuser')
            $("#information").append(createuser);
        else if (val == 'createtime')
            $("#information").append(createtime);
        else if (val == 'modifyuser')
            $("#information").append(modifyuser);
        else if (val == 'modifytime')
            $("#information").append(modifytime);
    };
    console.log(data['name']);
    layer.open({
        type: 1, //Page层类型
        skin: 'layui-layer-lan',
        area: ['500px', '600px'],
        title: ['表', 'font-size:18px'],
        btn: ['确定', '取消'],
        shadeClose: true,
        shade: 0, //遮罩透明度
        maxmin: false, //允许全屏最小化
        content: $("#information"),
        success: function () {
            $('#tbtype').val(data['tbtype']);
            $('#name').val(data['name']);
            $('#shortname').val(data['shortname']);
            $('#description').val(data['description']);
            $('#descriptionen').val(data['descriptionen']);
            $('#tbname').val(data['tbname']);
            $('#fieldname').val(data['fieldname']);
            data['isfile'] == 1 ? $('#isfile').prop("checked", true) : $('#isfile').prop("checked", false);

            $('#fieldno').val(data['fieldno']);
            $('#filepathno').val(data['filepathno']);
            $('#storedprocname').val(data['storedprocname']);
            $('#remark').val(data['remark']);
            $('#createuser').val(data['createuser']);
            $('#createtime').val(data['createtime']);
            $('#modifyuser').val(data["modifyuser"]);
            $('#modifytime').val(data["modifytime"]);
        },
        yes: function (index, layero) {
            jsonObj = createActionJson(type = "upp");
            console.log(jsonObj)
            var sendData = {
                action: jsonObj
            };
            wrapAjax(true, "dataset", "POST", "json", sendData, true, function (data) {
                var msg = data[0].info[0]._einfo;
                layer.msg(msg);
                if (msg.indexOf("success") != -1) {
                    tree.pTreeNode.name = _xname(tree.pTreeNode.pId, $('#description').val(), $('#name').val());
                    tree.zTree.updateNode(tree.pTreeNode);
                }
            }, function (error) {
                console.log(error);
            });
            layer.close(index);
        }
    });
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
    loadFormData('springtb', tree.pTreeNode)
});
$(document).on('click', '#menu-item-delete', function () {
    hideMenu();
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

function wrapAjax(cache, url, type, dataType, sendData = null, async = true, success, failed) {
    $.ajax({
        cache: cache,
        url: url,
        type: type,
        dataType: dataType,
        data: sendData,
        async: async,
        success: function (data) {
            success(data);
        },
        error: function (error) {
            failed(error);
        },
    });
}
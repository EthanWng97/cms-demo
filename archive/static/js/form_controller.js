layui.use(['layer', 'form'], function () {});

function showForm(database, treeNode) {
    $("#information").empty();

    // get details given treeNode.id to create form
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
    // construct form given list of data
    constructForm(data);

    // console.log(data['name']);
    // show thr form and fill the data
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
            // fill the data
            fillForm(data);
        },
        yes: function (index, layero) {
            submitForm();
            layer.close(index);
        },
        btn2: function (index, layero) {
            $('#information').empty();
        }
    });

}

function constructForm(data) {
    for (var val in data) {
        if (val == 'tbType')
            $("#information").append(tbType);
        else if (val == 'name')
            $("#information").append(name);
        else if (val == 'shortName')
            $("#information").append(shortName);
        else if (val == 'description')
            $("#information").append(description);
        else if (val == 'descriptionEn')
            $("#information").append(descriptionEn);
        else if (val == 'tbName')
            $("#information").append(tbName);
        else if (val == 'fieldName')
            $("#information").append(fieldName);
        else if (val == 'fieldNo')
            $("#information").append(fieldNo);
        else if (val == 'isFile')
            $("#information").append(isFile);
        else if (val == 'filePathNo')
            $("#information").append(filePathNo);
        else if (val == 'storedProcName')
            $("#information").append(storedProcName);
        else if (val == 'remark')
            $("#information").append(remark);
        else if (val == 'createUser')
            $("#information").append(createUser);
        else if (val == 'createTime')
            $("#information").append(createTime);
        else if (val == 'modifyUser')
            $("#information").append(modifyUser);
        else if (val == 'modifyTime')
            $("#information").append(modifyTime);
    };
}

function submitForm() {
    jsonObj = createActionJson(type = "upp");
    // console.log(jsonObj)
    var sendData = {
        action: jsonObj
    };
    wrapAjax(true, "dataset/action", "POST", "json", sendData, true, function (data) {
        var msg = data[0].info[0]._einfo;
        layer.msg(msg);
        if (msg.indexOf("success") != -1) {
            tree.pTreeNode.name = _xname(tree.pTreeNode.pId, $('#description').val(), $('#name').val());
            tree.pTreeNode.isParent = $('#tbType').val() == 0;
            tree.zTree.updateNode(tree.pTreeNode);
            $('#information').empty();
        }
    }, function (error) {
        console.log(error);
        $('#information').empty();
    });
}

function createActionJson(type, treeNode) {
    var data = layui.form.val("information");
    var info_json = {
        "action": type,
        "sId": tree.pTreeNode.id,
        "pId": tree.pTreeNode.pId,
        "tbType": parseInt(data['tbType']),
        "name": data['name'],
        "shortName": data['shortName'],
        "description": data['description'],
        "descriptionEn": data['descriptionEn'],
        "tbName": data['tbName'],
        "fieldName": data['fieldName'],
        "fieldNo": parseInt(data['fieldNo']),
        "isFile": data['isFile'] ? 1 : 0,
        "filePathNo": data['filePathNo'],
        "storedProcName": data['storedProcName'],
        "remark": data['remark'],
    };

    var action_list = [];
    action_list.push(info_json);
    var jsonObj = {
        "_userId": "123",
        "_userName": "123",
        "_info": JSON.stringify(action_list),
        "_entity": "123",
        "_error": "",
        "_eInfo": ""
    };
    return JSON.stringify(jsonObj);
}

function _xname(pid, description, name) {
    if (!pid || !description)
        return name;
    return description + "[" + name + "]"
}

function fillForm(data) {
    var form = layui.form;
    // console.log(data);
    form.val("information", {
        "tbType": data['tbType'],
        "name": data['name'],
        "shortName": data['shortName'],
        "description": data['description'],
        "descriptionEn": data['descriptionEn'],
        "tbName": data['tbName'],
        "fieldName": data['fieldName'],
        "isFile": data['isFile'] == 1,
        "fieldNo": data['fieldNo'],
        "filePathNo": data['filePathNo'],
        "storedProcName": data['storedProcName'],
        "remark": data['remark'],
        "createUser": data['createUser'],
        "createTime": data['createTime'],
        "modifyUser": data['modifyUser'],
        "modifyTime": data['modifyTime']
    })
    form.render(null, 'information'); //刷新select选择框渲染
}
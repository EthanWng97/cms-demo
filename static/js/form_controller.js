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

    console.log(data['name']);
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
}

function submitForm() {
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
            $('#information').empty();
        }
    }, function (error) {
        console.log(error);
        $('#information').empty();
    });
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

function _xname(pid, description, name) {
    if (!pid || !description)
        return name;
    return description + "[" + name + "]"
}

function fillForm(data) {
    var form = layui.form;
    console.log(data);
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
    form.render(); //刷新select选择框渲染
}
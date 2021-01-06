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
    console.log(data);
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
        success: function (res) {
            layer.msg(res.msg)
        }
    });
}
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
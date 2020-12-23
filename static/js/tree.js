var setting = {
    check: {
        enable: true,
    },
    data: {
        simpleData: {
            enable: true,
        },
    },
};

var zNodes;

function setCheck() {
    $.ajax({
        url: "getjson",
        type: "POST",
        dataType: "json",
        success: function (data) {
            // alert(data.name + ":" + data.age);
            console.log(data);
            zNodes = data;
        },
        error: function () {
            console.log("error");
        },
    });

    var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
        type = { Y: "ps", N: "ps" };
    zTree.setting.check.chkboxType = type;
}

$(function () {
    $.fn.zTree.init($("#treeDemo"), setting, zNodes);
    setCheck();
});

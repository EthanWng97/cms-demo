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
    var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
        type = { Y: "ps", N: "ps" };
    zTree.setting.check.chkboxType = type;
}

$(function () {
    $.ajax({
        url: "getjson",
        type: "POST",
        dataType: "json",
        success: function (data) {
            zNodes = data;
            console.log(zNodes);
            $(document).ready(function () {
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            });
        },
        error: function () {
            console.log(error);
        },
    });
});

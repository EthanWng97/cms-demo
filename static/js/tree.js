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

function onLoadTree() {
    var zNodes;
    $.ajax({
        url: "getjson",
        type: "POST",
        dataType: "json",
        success: function (data) {
            zNodes = data;
            $(document).ready(function () {
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            });
        },
        error: function () {
            console.log(error);
        },
    });
}

$(function () {
    onLoadTree();
});

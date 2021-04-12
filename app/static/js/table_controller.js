layui.use(['table', 'form', 'dropdown'], function () {});

function showTable1(id) {
    type = 'table1';
    url = '/dataset/table1/';
    height = 600;
    cols = colsTable1;
    limit = 20;
    showTable(id, type, url, height, cols, limit, function (res, curr, count) {
        $.each(res.data, function (index, values, arr) {
            // console.log(values);

            // values['isField'];
            $('#isField-' + values['id']).prop("checked", values['isField'] == 1);

            // values['fdType'];
            $('#fdType-' + values['id']).val(values['fdType']);

            // values['isNullable'];
            $('#isNullable-' + values['id']).prop("checked", values['isNullable'] == 1);

            // values['isUseable'];
            $('#isUseable-' + values['id']).prop("checked", values['isUseable'] == 1);

            // values['isForeignKey'];
            $('#isForeignKey-' + values['id']).prop("checked", values['isForeignKey'] == 1);

            // values['uiType'];
            $('#uiType-' + values['id']).val(values['uiType'].toString());

            // values['uiVisible'];
            $('#uiVisible-' + values['id']).prop("checked", values['uiVisible'] == 1);

            // values['uiReadOnly'];
            $('#uiReadOnly-' + values['id']).prop("checked", values['uiReadOnly'] == 1);

            // values['isAddField'];
            $('#isAddField-' + values['id']).prop("checked", values['isAddField'] == 1);

            // values['isEditField'];
            $('#isEditField-' + values['id']).prop("checked", values['isEditField'] == 1);

            // values['orderType'];
            $('#orderType-' + values['id']).val(values['orderType'].toString());

            layui.form.render();
        });
    })
}

function showTable2(id) {
    type = "table2";
    url = '/dataset/table2/';
    height = 250;
    cols = colsTable2;
    limit = 20;
    showTable(id, type, url, height, cols, limit, function (res, curr, count) {
        $.each(res.data, function (index, values, arr) {
            $('#type-' + values['id']).val(values['type'].toString());

            layui.form.render();
        });
    });
}

function showTable(id, type, url, height, cols, limit, done) {
    var tableId = '#' + type + '-' + id;
    var requestUrl = url + id
    layui.table.render({
        elem: tableId, //指定原始表格元素选择器（推荐id选择器）
        url: requestUrl,
        height: height, //容器高度
        cols: cols,
        even: true,
        //,page: true //是否显示分页
        //,limits: [5, 7, 10]
        limit: limit, //每页默认显示的数量

        done: function (res, curr, count) {
            layui.dropdown.render({
                elem: '.'+type, //也可绑定到 document，从而重置整个右键
                trigger: 'contextmenu', //contextmenu
                show: true,
                id: type +'-menu', //定义唯一索引
                data: tableMenuItem(type),
                click: function (obj, othis) {
                    console.log(obj);
                    // if (obj.id === 'modify') {
                    //     // showForm('springtb', tree.pTreeNode)
                    // } else if (obj.id === 'delete') {
                    //     if (beforeRemove(tree.pTreeNode)) onRemove(tree.pTreeNode);
                    // } else {
                    //     layui.layer.alert(obj.title);
                    // }
                }
            });
            // $('#isFieldCheckbox').val(data['fieldno']);
            //刷新select选择框渲染
            // $("[data-field='lowerHairPath']").css('display', 'none');
            // $(".layui-table-main tr").each(function (index, val) {
            //     $($(".layui-table-fixed-l .layui-table-body tbody tr")[index]).height($(val).height());
            //     $($(".layui-table-fixed-r .layui-table-body tbody tr")[index]).height($(val).height());
            // });
            // //动态监听表头高度变化，冻结行跟着改变高度
            // $(".layui-table-header tr").resize(function () {
            //     $(".layui-table-header tr").each(function (index, val) {
            //         $($(".layui-table-fixed .layui-table-header table tr")[index]).height($(val).height());
            //     });
            // });
            // //初始化高度，使得冻结行表头高度一致
            // $(".layui-table-header tr").each(function (index, val) {
            //     $($(".layui-table-fixed .layui-table-header table tr")[index]).height($(val).height());
            // });
            // //动态监听表体高度变化，冻结行跟着改变高度
            // $(".layui-table-body tr").resize(function () {
            //     $(".layui-table-body tr").each(function (index, val) {
            //         $($(".layui-table-fixed .layui-table-body table tr")[index]).height($(val).height());
            //     });
            // });
            // //初始化高度，使得冻结行表体高度一致
            // $(".layui-table-body tr").each(function (index, val) {
            //     $($(".layui-table-fixed .layui-table-body table tr")[index]).height($(val).height());
            // });
            done(res, curr, count);
        }
    });
}
layui.use(['table', 'form'], function () {});

function showTable(id) {
    var tableId = '#' + id;
    var requestUrl = '/dataset/table/' + id
    layui.table.render({

        elem: tableId, //指定原始表格元素选择器（推荐id选择器）
        url: requestUrl,
        height: 600, //容器高度
        cols: cols_template,
        data: data_template,

        even: true,
        //,page: true //是否显示分页
        //,limits: [5, 7, 10]

        limit: 20, //每页默认显示的数量

        done: function (res, curr, count) {
            $.each(res.data, function (index, values, arr) {
                console.log(values);

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
        }
    });
}
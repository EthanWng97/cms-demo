layui.use(['table'], function () {});

function showTable(id) {
    tableId = '#' + id;
    layui.table.render({
        elem: tableId //指定原始表格元素选择器（推荐id选择器）
            ,
        height: 600 //容器高度
            ,
        cols: cols_template,
        data: data_template,
            
        even: true
        //,page: true //是否显示分页
        //,limits: [5, 7, 10]
        ,limit: 20 //每页默认显示的数量
        , done: function (res, curr, count) {
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
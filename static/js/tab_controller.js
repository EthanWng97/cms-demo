layui.use(['element', 'jquery'], function () {
    loadTemplateTable1();
    loadTemplateTable2();

});

function showTab(title, content, id) {
    var isExist = false;
    $.each($(".layui-tab-title li[lay-id]"), function () {
        if ($(this).attr("lay-id") == id) {
            isExist = true;
        }
    })
    if (isExist == false) {
        content = '<div class="table1"><table id="' +'table1-'+ id + '" class="table1" lay-filter="test"></table></div>'+
        '<div class="table2"><table id="' + 'table2-' + id + '" class="table2" lay-filter="test"></table></div>';
        tabAdd(title, content, id);
        showTable1(id);
        showTable2(id);
    }
    tabChange(id);
}

function tabAdd(title, content, id) {
    layui.element.tabAdd('docDemoTabBrief', {
        title: title,
        content: content,
        id: id
    })
}

function tabChange(id) {
    layui.element.tabChange('docDemoTabBrief', id)
}
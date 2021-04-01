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
        content = '<table id="' +'table1-'+ id + '" lay-filter="test"></table>'+
        '<table id="' + 'table2-' + id + '" lay-filter="test"></table>';
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
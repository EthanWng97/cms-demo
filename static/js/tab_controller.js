layui.use(['element', 'jquery'], function () {
    loadTableTemplate();
});

function showTab(title, content, id) {
    var isExist = false;
    $.each($(".layui-tab-title li[lay-id]"), function () {
        if ($(this).attr("lay-id") == id) {
            isExist = true;
        }
    })
    if (isExist == false) {
        content = '<table id="' + id + '" lay-filter="test"></table>'
        tabAdd(title, content, id);
        showTable(id);
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
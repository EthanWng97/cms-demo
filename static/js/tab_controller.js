layui.use(['element', 'jquery'], function () {});

function showTab(title, content, id) {
    var isExist = false;
    $.each($(".layui-tab-title li[lay-id]"), function () {
        if ($(this).attr("lay-id") == id) {
            isExist = true;
        }
    })
    if (isExist == false) {
        tabAdd(title, content, id);
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
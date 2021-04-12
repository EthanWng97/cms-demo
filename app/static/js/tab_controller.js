layui.use(['element', 'jquery'], function () {
    loadTemplateTable1();
    loadTemplateTable2();

});

/**
 * Description. 展示 Tab
 *
 * @param {string}   title 从树形结构返回的节点 name，用于 tab title 的显示
 * @param {string}   content Tab 中显示的具体内容
 * @param {string}   id 从树形结构返回的节点 id，作为 tab 的唯一索引值
 */
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

/**
 * Description. 添加 Tab
 *
 * @param {string}   title 从树形结构返回的节点 name，用于 tab title 的显示
 * @param {string}   content Tab 中显示的具体内容
 * @param {string}   id 从树形结构返回的节点 id，作为 tab 的唯一索引值
 */
function tabAdd(title, content, id) {
    layui.element.tabAdd('docDemoTabBrief', {
        title: title,
        content: content,
        id: id
    })
}

/**
 * Description. 切换 Tab
 *
 * @param {string}   id 从树形结构返回的节点 id，作为 tab 的唯一索引值
 */
function tabChange(id) {
    layui.element.tabChange('docDemoTabBrief', id)
}
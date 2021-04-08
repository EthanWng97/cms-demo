var treeMenuItem = [{
    title: '添加根[表]',
    id: 'addRoot'
}, {
    title: '添加[列表]',
    id: 'addTable'
}, {
    title: '添加[关联]',
    id: 'addRela'
}, {
    title: '修改',
    id: 'modify'
}, {
    title: '删除',
    id: 'delete'
}, {
    title: '剪切[表]',
    id: 'clip'
}, {
    type: '-'
}, {
    title: '排序',
    id: 'sort'
}, {
    title: '翻译',
    id: 'translate'
}, {
    title: '编辑',
    id: 'edit'
}, {
    title: '列表分组管理',
    id: 'manageList'
}, {
    title: '存储过程',
    id: 'procedure'
}, {
    title: '模型导出',
    id: 'exportModel'
}];

function tableMenuItem(type){
    if(type == 'table1'){
        return [{
            title: '添加',
            id: 'add'
        }, {
            title: '插入',
            id: 'insert'
        }, {
            title: '删除',
            id: 'delete'
        }, {
            title: '清空',
            id: 'clean'
        }, {
            title: '数据库加载',
            id: 'load'
        }, {
            title: '保存',
            id: 'save'
        }, {
            title: '翻译',
            id: 'translate'
        }, {
            title: 'Excel导出[all]',
            id: 'exportAll'
        }, {
            title: 'Excel导出',
            id: 'export'
        }, {
            title: 'Excel导入',
            id: 'import'
        }, {
            title: '测试',
            id: 'test'
        }]
    }
    else{
        return [{
            title: '新建表格模版',
            id: 'addTableTemp'
        }, {
            title: '新建WinForm模版',
            id: 'addWinFormTemp'
        }, {
            type: '-'
        }, {
            title: 'Web模版',
            id: 'webTemp'
        }, {
            title: 'Web模版2',
            id: 'webTemp2'
        }, {
            type: '-'
        }, {
            title: 'Report模版',
            id: 'reportTemp'
        }, {
            title: 'Report模版2',
            id: 'reportTemp2'
        }, {
            type: '-'
        }, {
            title: '编辑',
            id: 'edit'
        }]
    }
}
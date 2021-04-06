function loadTemplateTable1() {
    var isFieldCheckbox =
        '<script type="text/html" id="isFieldCheckbox">' +
        '<input type="checkbox" name="isField" id="isField-{{d.id}}" lay-skin="primary"> ' +
        '</script>';

    var isNullableCheckbox =
        '<script type="text/html" id="isNullableCheckbox">' +
        '<input type="checkbox" name="isNullable" id="isNullable-{{d.id}}" lay-skin="primary">' +
        '</script>';

    var isUseableCheckbox =
        '<script type="text/html" id="isUseableCheckbox">' +
        '<input type="checkbox" name="isUseable" id="isUseable-{{d.id}}" lay-skin="primary">' +
        '</script>';

    var isForeignKeyCheckbox =
        '<script type="text/html" id="isForeignKeyCheckbox">' +
        '<input type="checkbox" name="isForeignKey" id="isForeignKey-{{d.id}}" lay-skin="primary">' +
        '</script>';

    var uiVisibleCheckbox =
        '<script type="text/html" id="uiVisibleCheckbox">' +
        '<input type="checkbox" name="uiVisible" id="uiVisible-{{d.id}}" lay-skin="primary">' +
        '</script>';

    var uiReadOnlyCheckbox =
        '<script type="text/html" id="uiReadOnlyCheckbox">' +
        '<input type="checkbox" name="uiReadOnly" id="uiReadOnly-{{d.id}}" lay-skin="primary">' +
        '</script>';

    var isAddFieldCheckbox =
        '<script type="text/html" id="isAddFieldCheckbox">' +
        '<input type="checkbox" name="isAddField" id="isAddField-{{d.id}}" lay-skin="primary">' +
        '</script>';

    var isEditFieldCheckbox =
        '<script type="text/html" id="isEditFieldCheckbox">' +
        '<input type="checkbox" name="isEditField" id="isEditField-{{d.id}}" lay-skin="primary">' +
        '</script>';

    var fdTypeSelect =
        '<script type="text/html" id="fdTypeSelect">' +
        '<select name="fdTypeSelect" id="fdType-{{d.id}}" lay-verify="" lay-search="">' +
        '    <option value="integer">integer</option>' +
        '    <option value="varchar">varchar</option>' +
        '    <option value="timestamp with time zone">timestamp with time zone</option>' +
        '    <option value="bool">bool</option>' +
        '</select>' +
        '</script>';

    var uiTypeSelect =
        '<script type="text/html" id="uiTypeSelect">' +
        '<select name="uiTypeSelect" id="uiType-{{d.id}}" lay-verify="" lay-search="">' +
        '    <option value="1">Lable</option>' +
        '    <option value="2">TextBox</option>' +
        '    <option value="3">CheckBox</option>' +
        '    <option value="4">DateBox</option>' +
        '    <option value="5">RichTextBox</option>' +
        '    <option value="6">DropDownTree</option>' +
        '    <option value="7">NumberBox</option>' +
        '    <option value="8">NumberSpinner</option>' +
        '    <option value="9">DateTimeBox</option>' +
        '</select>' +
        '</script>';

    var orderTypeSelect =
        '<script type="text/html" id="orderTypeSelect">' +
        '<select name="orderTypeSelect" id="orderType-{{d.id}}" lay-verify="" lay-search="">' +
        '    <option value="-1">升序</option>' +
        '    <option value="1">降序</option>' +
        '</select>' +
        '</script>';

    $("body").append(isFieldCheckbox);
    $("body").append(fdTypeSelect);
    $("body").append(uiTypeSelect);
    $("body").append(orderTypeSelect);
    $("body").append(isNullableCheckbox);
    $("body").append(isUseableCheckbox);
    $("body").append(isForeignKeyCheckbox);
    $("body").append(uiVisibleCheckbox);
    $("body").append(uiReadOnlyCheckbox);
    $("body").append(isAddFieldCheckbox);
    $("body").append(isEditFieldCheckbox);
}
var colsTable1 = [
    [ //标题栏
        {
            type: 'numbers',
        },
        {
            field: 'isField',
            title: '是否字',
            width: 80,
            align: 'center',
            templet: '#isFieldCheckbox'
        }, {
            field: 'name',
            title: '字段名称',
            width: 120
        }, {
            field: 'description',
            title: '字段描述',
            minWidth: 150
        }, {
            field: 'fdType',
            title: '字段类型',
            minWidth: 160,
            templet: '#fdTypeSelect'
        }, {
            field: 'length',
            title: '字段长',
            width: 80
        }, {
            field: 'decimal',
            title: '小数长',
            width: 80
        }, {
            field: 'descriptionEn',
            title: '字段英文描述',
            width: 160,
        }, {
            field: 'isNullable',
            title: '是否允许为空',
            width: 120,
            align: 'center',
            templet: '#isNullableCheckbox'
        }, {
            field: 'isUseable',
            title: '是否启用',
            width: 80,
            align: 'center',
            templet: '#isUseableCheckbox'
        }, {
            field: 'isForeignKey',
            title: '有外键',
            width: 80,
            align: 'center',
            templet: '#isForeignKeyCheckbox'
        }, {
            field: 'fkTbId',
            title: '外键表',
            width: 80,
        }, {
            field: 'fkFieldId',
            title: '外键字段',
            width: 80,
        }, {
            field: 'defaultValue',
            title: '函数',
            width: 80,
        }, {
            field: 'uiType',
            title: '界面控件类型',
            minWidth: 160,
            templet: '#uiTypeSelect'
        }, {
            field: 'uiMask',
            title: '控件输入掩码',
            width: 120,
        }, {
            field: 'uiVisible',
            title: '是否可见',
            width: 80,
            align: 'center',
            templet: '#uiVisibleCheckbox'
        }, {
            field: 'uiReadOnly',
            title: '是否只读',
            width: 80,
            align: 'center',
            templet: '#uiReadOnlyCheckbox'
        }, {
            field: 'uiWidth',
            title: '默认宽度',
            width: 80,
        }, {
            field: 'uiDefault',
            title: '默认值',
            width: 80,
        }, {
            field: 'isAddField',
            title: '是否添加',
            width: 80,
            align: 'center',
            templet: '#isAddFieldCheckbox'
        }, {
            field: 'isEditField',
            title: '是否修改',
            width: 80,
            align: 'center',
            templet: '#isEditFieldCheckbox'
        }, {
            field: 'orderType',
            title: '排序',
            minWidth: 100,
            templet: '#orderTypeSelect'
        }, {
            field: 'remark',
            title: '备注',
            width: 80,
        }, {
            field: 'createUser',
            title: '创建人',
            width: 80,
        }, {
            field: 'createTime',
            title: '创建时间',
            width: 80,
        }, {
            field: 'modifyuser',
            title: '修改人',
            width: 80,
        }, {
            field: 'modifytime',
            title: '修改时间',
            width: 80,
        }
    ]
];

function loadTemplateTable2() {
    var typeSelect =
        '<script type="text/html" id="typeSelect">' +
        '<select name="typeSelect" id="type-{{d.id}}" lay-verify="" lay-search="">' +
        '    <option value="1">多数据集</option>' +
        '    <option value="2">单数据集(WinForm)</option>' +
        '    <option value="3">单数据(Web)</option>' +
        '</select>' +
        '</script>';
    $("body").append(typeSelect);
}
var colsTable2 = [
    [ //标题栏
        {
            type: 'numbers',
        },
        {
            field: 'type',
            title: '实例类型',
            width: 200,
            templet: '#typeSelect'
        }, {
            field: 'no',
            title: '编码',
            width: 120
        }, {
            field: 'name',
            title: '名称',
            width: 120
        }, {
            field: 'description',
            title: '描述',
            width: 120
        }, {
            field: 'descriptionEn',
            title: '英文描述',
            width: 120
        }, {
            field: 'remark',
            title: '备注',
            width: 80,
        }, {
            field: 'createUser',
            title: '创建人',
            width: 300,
        }, {
            field: 'createTime',
            title: '创建时间',
            width: 300,
        }, {
            field: 'modifyuser',
            title: '修改人',
            width: 300,
        }, {
            field: 'modifytime',
            title: '修改时间',
            width: 300,
        }
    ]
];
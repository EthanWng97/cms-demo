function loadTableTemplate() {
    var isFieldCheckbox =
        '<script type="text/html" id="isFieldCheckbox">' +
        '<input type="checkbox" name="isField" lay-skin="primary">' +
        '</script>';

    var isNullableCheckbox =
        '<script type="text/html" id="isNullableCheckbox">' +
        '<input type="checkbox" name="isNullable" lay-skin="primary">' +
        '</script>';

    var isUseableCheckbox =
        '<script type="text/html" id="isUseableCheckbox">' +
        '<input type="checkbox" name="isUseable" lay-skin="primary">' +
        '</script>';

    var isForeignKeyCheckbox =
        '<script type="text/html" id="isForeignKeyCheckbox">' +
        '<input type="checkbox" name="isForeignKey" lay-skin="primary">' +
        '</script>';

    var uiVisibleCheckbox =
        '<script type="text/html" id="uiVisibleCheckbox">' +
        '<input type="checkbox" name="uiVisible" lay-skin="primary">' +
        '</script>';

    var uiReadOnlyCheckbox =
        '<script type="text/html" id="uiReadOnlyCheckbox">' +
        '<input type="checkbox" name="uiReadOnly" lay-skin="primary">' +
        '</script>';

    var isAddFieldCheckbox =
        '<script type="text/html" id="isAddFieldCheckbox">' +
        '<input type="checkbox" name="isAddField" lay-skin="primary">' +
        '</script>';

    var isEditFieldCheckbox =
        '<script type="text/html" id="isEditFieldCheckbox">' +
        '<input type="checkbox" name="isEditField" lay-skin="primary">' +
        '</script>';

    var fdTypeSelect =
        '<script type="text/html" id="fdTypeSelect">' +
        '<select name="fdTypeSelect" lay-verify="" lay-search="">' +
        '    <option value="integer">integer</option>' +
        '    <option value="varchar">varchar</option>' +
        '    <option value="timestamp with time zone">timestamp with time zone</option>' +
        '    <option value="bool">bool</option>' +
        '</select>' +
        '</script>';

    var uiTypeSelect =
        '<script type="text/html" id="uiTypeSelect">' +
        '<select name="uiTypeSelect" lay-verify="" lay-search="">' +
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
        '<select name="orderTypeSelect" lay-verify="" lay-search="">' +
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
var cols_template = [
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
            field: 'modifyUser',
            title: '修改人',
            width: 80,
        }, {
            field: 'modifyTime',
            title: '修改时间',
            width: 80,
        }
    ]
];

var data_template = [{
    "id": "10001",
    "username": "杜甫",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "116",
    "ip": "192.168.0.8",
    "logins": "108",
    "joinTime": "2016-10-14"
}, {
    "id": "10002",
    "username": "李白",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "12",
    "ip": "192.168.0.8",
    "logins": "106",
    "joinTime": "2016-10-14",
    "LAY_CHECKED": true
}, {
    "id": "10003",
    "username": "王勃",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "65",
    "ip": "192.168.0.8",
    "logins": "106",
    "joinTime": "2016-10-14"
}, {
    "id": "10004",
    "username": "贤心",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "666",
    "ip": "192.168.0.8",
    "logins": "106",
    "joinTime": "2016-10-14"
}, {
    "id": "10005",
    "username": "贤心",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "86",
    "ip": "192.168.0.8",
    "logins": "106",
    "joinTime": "2016-10-14"
}, {
    "id": "10006",
    "username": "贤心",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "12",
    "ip": "192.168.0.8",
    "logins": "106",
    "joinTime": "2016-10-14"
}, {
    "id": "10007",
    "username": "贤心",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "16",
    "ip": "192.168.0.8",
    "logins": "106",
    "joinTime": "2016-10-14"
}, {
    "id": "10008",
    "username": "贤心",
    "email": "xianxin@layui.com",
    "sex": "男",
    "city": "浙江杭州",
    "sign": "人生恰似一场修行",
    "experience": "106",
    "ip": "192.168.0.8",
    "logins": "106",
    "joinTime": "2016-10-14"
}];
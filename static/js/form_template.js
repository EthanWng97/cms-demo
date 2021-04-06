var tbType = '<div class="layui-form-item">' +
    '<label class="layui-form-label">表类型</label>' +
    '<div class="layui-input-block">' +
    '<select id="tbType" name="tbType" lay-verify="required" class="tbType">' +
    '<option value=""></option>' +
    '<option value="0">文件夹</option>' +
    '<option value="1">表</option>' +
    '</select>' +
    '</div>' +
    '</div>';

var name = '<div class="layui-form-item">' +
    '<label class="layui-form-label">名称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="name" name="name" lay-verify="title" placeholder="请输入名称" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';


var shortName = '<div class="layui-form-item">' +
    '<label class="layui-form-label">简称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="shortName" name="shortName" lay-verify="title" placeholder="请输入简称" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';



var description = '<div class="layui-form-item">' +
    '<label class="layui-form-label">描述</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="description" name="description" lay-verify="title" placeholder="请输入描述" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';



var descriptionEn = '<div class="layui-form-item">' +
    '<label class="layui-form-label">英文描述</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="descriptionEn" name="descriptionEn" lay-verify="title" placeholder="请输入英文描述" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';



var tbName = '<div class="layui-form-item">' +
    '<label class="layui-form-label">实际标名称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="tbName" name="tbName" lay-verify="title" placeholder="请输入实际标名称" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';



var fieldName = '<div class="layui-form-item">' +
    '<label class="layui-form-label">拓展类型字段名称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="fieldName" name="fieldName" lay-verify="title" placeholder="请输入拓展类型字段名称" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';

var fieldNo = '<div class="layui-form-item">' +
    '<label class="layui-form-label">类型值</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="fieldNo" name="fieldNo" lay-verify="title" placeholder="请输入类型值" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';

var isFile = '<div class="layui-form-item">' +
    '<label class="layui-form-label">是否有文档附件</label>' +
    '<div class="layui-input-block">' +
    '<input type="checkbox" id="isFile" name="isFile" lay-skin="primary">' +
    '</div>' +
    '</div>';



var filePathNo = '<div class="layui-form-item">' +
    '<label class="layui-form-label">文档附件目录编码</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="filePathNo" name="filePathNo" lay-verify="title" placeholder="请输入文档附件目录编码" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';


var storedProcName = '<div class="layui-form-item">' +
    '<label class="layui-form-label">存储过程名称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="storedProcName" name="storedProcName" lay-verify="title" placeholder="请输入存储过程名称" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';

var remark = '<div class="layui-form-item">' +
    '<label class="layui-form-label">备注</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="remark" name="remark" lay-verify="title" placeholder="请输入备注" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';


var createUser = '<div class="layui-form-item">' +
    '<label class="layui-form-label">创建人</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="createUser" name="createUser" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';



var createTime = '<div class="layui-form-item">' +
    '<label class="layui-form-label">创建时间</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="createTime" name="createTime" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';


var modifyUser = '<div class="layui-form-item">' +
    '<label class="layui-form-label">修改人</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="modifyUser" name="modifyUser" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';


var modifyTime = '<div class="layui-form-item">' +
    '<label class="layui-form-label">修改时间</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="modifyTime" name="modifyTime" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';
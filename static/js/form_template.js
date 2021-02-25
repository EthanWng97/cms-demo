var tbtype = '<div class="layui-form-item">' +
    '<label class="layui-form-label">表类型</label>' +
    '<div class="layui-input-block">' +
    '<select id="tbtype" name="tbtype" lay-verify="required" class="tbtype">' +
    '<option value=""></option>' +
    '<option value="0">表</option>' +
    '<option value="1">文件夹</option>' +
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


var shortname = '<div class="layui-form-item">' +
    '<label class="layui-form-label">简称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="shortname" name="shortname" lay-verify="title" placeholder="请输入简称" autocomplete="off"' +
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



var descriptionen = '<div class="layui-form-item">' +
    '<label class="layui-form-label">英文描述</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="descriptionen" name="descriptionen" lay-verify="title" placeholder="请输入英文描述" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';



var tbname = '<div class="layui-form-item">' +
    '<label class="layui-form-label">实际标名称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="tbname" name="tbname" lay-verify="title" placeholder="请输入实际标名称" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';



var filename = '<div class="layui-form-item">' +
    '<label class="layui-form-label">拓展类型字段名称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="filename" name="filename" lay-verify="title" placeholder="请输入拓展类型字段名称" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';

var fileno = '<div class="layui-form-item">' +
    '<label class="layui-form-label">类型值</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="fileno" name="fileno" lay-verify="title" placeholder="请输入类型值" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';

var isfile = '<div class="layui-form-item">' +
    '<label class="layui-form-label">是否有文档附件</label>' +
    '<div class="layui-input-block">' +
    '<input type="checkbox" id="isfile" name="isfile" lay-skin="primary">' +
    '</div>' +
    '</div>';



var filepathno = '<div class="layui-form-item">' +
    '<label class="layui-form-label">文档附件目录编码</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="filepathno" name="filepathno" lay-verify="title" placeholder="请输入文档附件目录编码" autocomplete="off"' +
    'class="layui-input">' +
    '</div>' +
    '</div>';


var storedprocname = '<div class="layui-form-item">' +
    '<label class="layui-form-label">存储过程名称</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="storedprocname" name="storedprocname" lay-verify="title" placeholder="请输入存储过程名称" autocomplete="off"' +
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


var createuser = '<div class="layui-form-item">' +
    '<label class="layui-form-label">创建人</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="createuser" name="createuser" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';



var createtime = '<div class="layui-form-item">' +
    '<label class="layui-form-label">创建时间</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="createtime" name="createtime" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';


var modifyuser = '<div class="layui-form-item">' +
    '<label class="layui-form-label">修改人</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="modifyuser" name="modifyuser" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';


var modifytime = '<div class="layui-form-item">' +
    '<label class="layui-form-label">修改时间</label>' +
    '<div class="layui-input-block">' +
    '<input type="text" id="modifytime" name="modifytime" lay-verify="title" autocomplete="off"' +
    'class="layui-input" readonly="readonly">' +
    '</div>' +
    '</div>';
import json
from . import dataset, db_session
from sqlalchemy.sql import text
import datetime

def _convert_pid(pid):
    """ 构建 zTree 过程中对于 pid 字段的修改
    Args:
        pid: 从数据库中返回的节点的 pid 属性
    Returns:
        pid: 修改后的 pid
    """
    if pid == None:
        return 0
    return pid


def _convert_name(pid, description, name):
    """ 构建 zTree 过程中对于 name 字段的修改
    Args:
        pid: 从数据库中返回的节点的 pid 属性
        description: 从数据库中返回的节点的 description 属性
        name: 从数据库中返回的节点的 name 属性
    Returns:
        name: zTree 中节点的 name 属性
    """
    if pid is None or description is None:
        return name
    return description + "[" + name + "]"


def _convert_parent(tbtype):
    """ 构建 zTree 过程中对于 isParent 字段的修改
    Args:
        tbtype: 从数据库中返回的节点的 tbtype 属性
    Returns:
        isParent: zTree 中节点的 isParent 属性
    """
    if tbtype == 1:
        return 0
    return 1

def _convert_data(data):
    """ 构建 form, table 过程中对于 datetime 字段的修改
    Args:
        data: 从数据库中返回的节点的所有属性
    Returns:
        data: 修改后的属性值
    """
    if isinstance(data, datetime.datetime):
        return data.__str__()
    else:
        return data


def is_json(myjson):
    """ 判断参数是否为 json 格式
    Args:
        myjson: 输入的待检测参数
    Returns:
        bool: 输入参数是否为json的布尔值
    """
    try:
        json.loads(myjson)
    except TypeError:
        return False
    except ValueError:
        return False
    return True


def _contruct_tree_dict(sid, pid, description, name, tbtype):
    """ 构建 zTree 所需的树形节点数据
    Args:
        sid, pid, description, name, tbtype: 从数据库返回的各个参数 
    Returns:
        _dict: 构建的字典格式参数
    """
    _dict = {
        "id": sid,
        "pId": _convert_pid(pid),
        "name": _convert_name(pid, description, name),
        "isParent": _convert_parent(tbtype),
    }
    return _dict

def _construct_sqlstring(type, sid= None):
    if type == "tree":
        if sid is None:
            return (
                "SELECT * FROM \"dbo.springTb\" WHERE \"pId\" IS NULL ORDER BY queue"
            )
        else:
            return (
                "SELECT * FROM \"dbo.springTb\" WHERE \"pId\" = '%s' ORDER BY queue"
                % (sid)
            )
    if type == "action":
        return text(
            "CALL \"dbo.springTb_Action\"(_userId=>:_userId, _userName=> :_userName, _info=> :_info,  _entity=>:_entity, _error=>:_error, _eInfo=>:_eInfo);"
        )
    elif type == "form":
        return text("select * from \"dbo.springTb\" where \"sId\"=:_sid ORDER BY queue;")
    elif type == "table1":
        return text("select * from \"dbo.springField\" where \"tbId\"=:_sid ORDER BY queue;")
    elif type == "table2":
        return text("select * from \"dbo.springTbUiTemplate\" where \"tbId\"=:_sid;")



def _exec_procedure(proc_name, params):
    sql_params = ",".join(
        ["{0}='{1}'".format(name, value) for name, value in params.items()]
    )
    sql_string = """
        CALL dbo.{proc_name} ({params});
    """.format(
        proc_name=proc_name, params=sql_params
    )

    return db_session.execute(sql_string).fetchall()

def _fetch_action_data(action_json):
    sql_string = ""
    sql_string = _construct_sqlstring("action")
    result = db_session.execute(
        sql_string,
        {
            "_userId": action_json["_userId"],
            "_userName": action_json["_userName"],
            "_info": action_json["_info"],
            "_entity": action_json["_entity"],
            "_error": action_json["_error"],
            "_eInfo": action_json["_eInfo"],
        },
    )
    db_session.commit()
    return result

def _fetch_tree_data(sid, isJson=False):
    sql_string = ""
    if isJson is False:
        sql_string = _construct_sqlstring("tree", sid)
    else:
        i = 0
        for each_sid in json.loads(sid):
            if i == 0:
                sql_string += "(" + _construct_sqlstring("tree", each_sid) + ")"
                i += 1
            else:
                sql_string += (
                    "union all ( " + _construct_sqlstring("tree", each_sid) + ") "
                )
    return db_session.execute(sql_string).fetchall()

def _fetch_form_data(form_json):
    sql_string = ""
    sql_string = _construct_sqlstring("form")
    result = db_session.execute(
        sql_string,
        {
            # "_db": row_json["_db"],
            "_sid": form_json["_sid"],
        },
    )
    return result

def _fetch_table_data(table_json, table):
    sql_string = ""
    sql_string = _construct_sqlstring(table)
    result = db_session.execute(
        sql_string,
        {
            "_sid": table_json["sid"],
        },
    )
    return result

def get_tree_data(sid):
    isJson = is_json(sid)
    groups = _fetch_tree_data(sid, isJson)
    result = {}
    for i in groups:
        pid = _convert_pid(i.pId)
        _dict = _contruct_tree_dict(i.sId, i.pId, i.description, i.name, i.tbType)
        if pid not in result.keys():
            result[pid] = []
        result[pid].append(_dict)
    return result

def get_action_data(action_json):
    action_json = json.loads(action_json)
    groups = _fetch_action_data(action_json)
    result = []
    for i in groups:
        _dict = {
            "info": i._info,
            "entity": i._entity,
            "error": i._error,
            "einfo": i._einfo,
        }
        result.append(_dict)
    return result

def get_form_data(form_json):
    form_json = json.loads(form_json)
    resultproxy = _fetch_form_data(form_json)
    result = {}
    for rowproxy in resultproxy:
        for column, value in rowproxy.items():
            result[column] = _convert_data(value)
    return result

def get_table_data(table_json,table):
    table_json = json.loads(table_json)
    resultproxy = _fetch_table_data(table_json, table)
    result = []
    for rowproxy in resultproxy:
        _dict = {}
        for column, value in rowproxy.items():
            if column == "sId":
                _dict['id'] = _convert_data(value)
            else:
                _dict[column] = _convert_data(value)
        result.append(_dict)
    return result
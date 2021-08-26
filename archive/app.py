import json
import datetime
from sys import setswitchinterval
from flask import Flask, render_template, request
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy import sql
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.sql import text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy_mptt import mptt_sessionmaker
from sqlalchemy_mptt.mixins import BaseNestedSets

Base = declarative_base()
engine = create_engine(
    "postgresql+psycopg2://postgres:19971004@198.13.60.74:5432/postgres",
    pool_size=50,
    max_overflow=20,
)
db_session = scoped_session(sessionmaker(bind=engine))
# class Tree(Base, BaseNestedSets):
#     __tablename__ = "dbo.springtb"
#     id = Column(String, primary_key=True)
#     name = Column(String)

#     def __repr__(self):
#         return "<Node (%s)>" % self.id

def _xpid(pid):
    if pid == None:
        return 0
    return pid


def _xname(pid, description, name):
    if pid is None or description is None:
        return name
    return description + "[" + name + "]"


def _xparent(tbtype):
    if tbtype == 1:
        return 0
    return 1


def _is_json(myjson):
    try:
        json.loads(myjson)
    except TypeError:
        return False
    except ValueError:
        return False
    return True


def _contruct_dict(sid, pid, description, name, tbtype):
    _dict = {
        "id": sid,
        "pId": _xpid(pid),
        "name": _xname(pid, description, name),
        "isParent": _xparent(tbtype),
    }
    return _dict


def _construct_select_sqlstring(sid):
    if sid is None:
        return (
            "SELECT * FROM \"dbo.springTb\" WHERE \"pId\" IS NULL ORDER BY queue"
        )
    else:
        return (
            "SELECT * FROM \"dbo.springTb\" WHERE \"pId\" = '%s' ORDER BY queue"
            % (sid)
        )


def _construct_sqlstring(type):
    if type == "call":
        return text(
            "CALL \"dbo.springTb_Action\"(_userId=>:_userId, _userName=> :_userName, _info=> :_info,  _entity=>:_entity, _error=>:_error, _eInfo=>:_eInfo);"
        )
    elif type == "row":
        return text("select * from \"dbo.springTb\" where \"sId\"=:_sid ORDER BY queue;")
    elif type == "table1":
        return text("select * from \"dbo.springField\" where \"tbId\"=:_sid ORDER BY queue;")
    elif type == "table2":
        return text("select * from \"dbo.springTbUiTemplate\" where \"tbId\"=:_sid;")


def _fetch_tree_data(sid, isJson=False):
    sql_string = ""
    if isJson is False:
        sql_string = _construct_select_sqlstring(sid)
    else:
        i = 0
        for each_sid in json.loads(sid):
            if i == 0:
                sql_string += "(" + _construct_select_sqlstring(each_sid) + ")"
                i += 1
            else:
                sql_string += (
                    "union all ( " + _construct_select_sqlstring(each_sid) + ") "
                )
    return db_session.execute(sql_string).fetchall()


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
    sql_string = _construct_sqlstring("call")
    # return db_session.execute(sql_string).fetchall()
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
    print(result)
    db_session.commit()
    return result


def _data_converter(data):
    if isinstance(data, datetime.datetime):
        return data.__str__()
    else:
        return data


def _fetch_row_data(row_json):
    sql_string = ""
    sql_string = _construct_sqlstring("row")
    result = db_session.execute(
        sql_string,
        {
            # "_db": row_json["_db"],
            "_sid": row_json["_sid"],
        },
    )
    return result

def _fetch_table_data(row_json, table):
    sql_string = ""
    sql_string = _construct_sqlstring(table)
    result = db_session.execute(
        sql_string,
        {
            "_sid": row_json["sid"],
        },
    )
    return result

# 创建flask的应用对象
# __name__表示当前的模块名称
# 模块名: flask以这个模块所在的目录为根目录，默认这个目录中的static为静态目录，templates为模板目录
app = Flask(__name__)


# @app.route("/getjson", methods=["GET", "POST"])  # 路由
# def get_single_json():
#     sid = request.args.get("sId")
#     groups = _fetch_tree_data(sid)
#     result = []
#     for i in groups:
#         _dict = _contruct_dict(i.sid, i.pid, i.description, i.name, i.tbtype)
#         result.append(_dict)
#     return json.dumps(result)


def get_action(action_json):
    # action_json = request.form.get("action_json")
    # isJson = _is_json(action_json)
    action_json = json.loads(action_json)
    groups = _fetch_action_data(action_json)
    # print(groups)
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


def get_rowdata(row_json):
    row_json = json.loads(row_json)
    resultproxy = _fetch_row_data(row_json)
    result = {}
    for rowproxy in resultproxy:
        for column, value in rowproxy.items():
            result[column] = _data_converter(value)
    return result

def get_table(table2_json,table):
    table2_json = json.loads(table2_json)
    resultproxy = _fetch_table_data(table2_json, table)
    result = []
    for rowproxy in resultproxy:
        _dict = {}
        for column, value in rowproxy.items():
            if column == "sId":
                _dict['id'] = _data_converter(value)
            else:
                _dict[column] = _data_converter(value)
        result.append(_dict)
    return result

@app.route("/dataset/tree", methods=["GET", "POST"])
def dataset_load():
    """ 加载 springtb 中的树形结构
    Args:
        arg: sid的列表，存储着需要遍历的节点列表
        {
            "sId":[
                "77721d6d-01fc-4b80-a316-7f6d07549542",
                "31b4ade8-5f03-46e4-bdad-262b0974f787"
            ]
        }
    Returns:
        json.dumps(result): 符合 ZTree 的树形数据结构
        {
            "f0eff541-4e35-4ef5-a5ae-7df2df3f05ea":[
                {
                    "id":"2082994e-eeca-4fc7-aec1-712cb2fec23e",
                    "pId":"f0eff541-4e35-4ef5-a5ae-7df2df3f05ea",
                    "name":"数据库信息[springDbInfo]",
                    "isParent":0
                },
                {
                    "id":"378ea5cb-0916-4cbc-a10c-8742d36e3d1c",
                    "pId":"f0eff541-4e35-4ef5-a5ae-7df2df3f05ea",
                    "name":"表[springTb]",
                    "isParent":0
                }
            ],
            "f0eff541-4e35-4ef5-a5ae-7df2df3f05eb":[
            ]
        }
    """
    sid = request.form.get("sId")
    isJson = _is_json(sid)
    groups = _fetch_tree_data(sid, isJson)
    result = {}
    for i in groups:
        pid = _xpid(i.pId)
        _dict = _contruct_dict(i.sId, i.pId, i.description, i.name, i.tbType)
        if pid not in result.keys():
            result[pid] = []
        result[pid].append(_dict)
    return json.dumps(result)


@app.route("/dataset/action", methods=["GET", "POST"])
def dataset_action():
    """ 一个动作组，用来执行对数据库的操作的增删改操作
    Args:
        action:
        {
            "_userId": "123",
            "_userName": "123",
            "_info":
            [
                {
                    "action":"update","sId":"378ea5cb-0916-4cbc-a10c-8742d36e3d1c",
                    "pId":"f0eff541-4e35-4ef5-a5ae-7df2df3f05ea",
                    "tbType":1,
                    "name":"springTb",
                    "shortName":"123",
                    "description":"表",
                    "descriptionEn":"",
                    "tbName":"springTb",
                    "fieldName":"",
                    "fieldNo":null,
                    "isFile":null,
                    "filePathNo":"",
                    "storedProcName":"springTb_Action",
                    "remark":""
                }
            ],
            "_entity": "123",
            "_error": "123",
            "_eInfo": "123"
        }
    Returns:
        json.dumps(result): 返回动作组执行结果
        [
            {"info": "i._info",
            "entity": "i._entity",
            "error": "i._error",
            "einfo": "i._einfo"
            }
        ]
    """
    action_json = request.form.get("action")
    isJson = _is_json(action_json)
    result = get_action(action_json)
    return json.dumps(result)


@app.route("/dataset/rowdata", methods=["GET", "POST"])
def dataset_rowdata():
    """ 在 springtb 中获取特定表的字段属性值
    Args:
        row:指定数据库 + 表格信息
        {
            "_db": "dbo.springtb",
            "_sid": "treeNode.id"
        }
    Returns:
        json.dumps(result): 表sid以及相关字段属性值
        {
            "sid":"f0eff541-4e35-4ef5-a5ae-7df2df3f05ea",
            "pid":null,
            "tbtype":0,
            "name":"数据模型",
            "shortname":"数据模型",
            "description":"数据模型",
            "descriptionen":"",
            "tbname":"",
            "fieldname":"",
            "fieldno":null,
            "isfile":0,
            "filepathno":"",
            "storedprocname":"",
            "remark":"",
            "queue":1,
            "createuser":"77dec868-d001-4790-b6a4-0fa8df9a39f9",
            "createtime":"2012-12-14 11:34:11.579009+00:00",
            "modifyuser":null,
            "modifytime":"2021-03-23 11:41:54.031940+00:00",
            "stamp":"0x0000000000339BF8"
        }
    """
    row_json = request.form.get("row")
    isJson = _is_json(row_json)
    result = get_rowdata(row_json)
    return json.dumps(result)


@app.route("/dataset/table1/<sid>", methods=["GET", "POST"])
def dataset_table1(sid):
    """Description
    Args:
        sid: 具体table的sid，在springField中以 tbid 显示
        page： 分页查询的页编号
        limit： 每页显示的最大数目
    Returns:
        json.dumps(result):
        {
            "code":0,
            "msg":"",
            "count":1000,
            "data":[
                {
                    "id":"00194a35-0e40-4583-bb19-407271dfe69e",
                    "isField":1,
                    "name":"sId",
                    "description":"主键",
                    "fdType":"varchar",
                    "length":"36",
                    "decimal":"0",
                    "descriptionEn":"主键",
                    "isNullable":0,
                    "isUseable":1,
                    "isForeignKey":0,
                    "fkTbId":null,
                    "fkFieldId":null,
                    "defaultValue":null,
                    "uiType":"TextBox",
                    "uiMask":null,
                    "uiVisible":0,
                    "uiReadOnly":1,
                    "uiWidth":"60",
                    "uiDefault":null,
                    "isAddField":1,
                    "isEditField":1,
                    "orderType":1,
                    "remark":null,
                    "createUser":"创建用户",
                    "createTime":"创建时间",
                    "modifyUser":"修改用户",
                    "modifyTime":"修改时间"
                }
            ]
        }
    """
    page = request.args.get("page")
    limit = request.args.get("limit")
    # print(sid)
    # print(page)
    # print(limit)
    table1_json = {
        "sid":sid,
        "page":page,
        "limit":limit,
    }
    table1_json = json.dumps(table1_json)
    result1 = get_table(table1_json, "table1")
    result = {
            "code":0,
            "msg":"",
            "count":1000,
            "data": result1
        }
    print(result)
    return json.dumps(result)

@app.route("/dataset/table2/<sid>", methods=["GET", "POST"])
def dataset_table2(sid):
    """Description
    Args:
        sid: 具体table的sid，在 springTbUiTemplate 中以 tbid 显示
        page： 分页查询的页编号
        limit： 每页显示的最大数目
    Returns:
        json.dumps(result):
        {
            "code":0,
            "msg":"",
            "count":1000,
            "data":[
                {
                    "id":"1b5f0d8d-b9d7-4446-b4bd-5e261185e169",
                    "type": 1,
                    "no": 99,
                    "name": "多数据集合",
                    "description": "描述",
                    "descriptionEn": "英文描述",
                    "remark": None,
                    "createUser": "创建用户",
                    "createTime": "创建时间",
                    "modifyUser": "修改用户",
                    "modifyTime": "修改时间"
                }
            ]
        }
    """
    page = request.args.get("page")
    limit = request.args.get("limit")
    # print(sid)
    # print(page)
    # print(limit)
    table2_json = {
        "sid":sid,
        "page":page,
        "limit":limit,
    }
    table2_json = json.dumps(table2_json)
    result1 = get_table(table2_json, "table2")
    result = {
            "code":0,
            "msg":"",
            "count":1000,
            "data": result1
        }
    print(result)
    return json.dumps(result)

# 定义url请求路径
@app.route("/")
def hello_world():
    """定义视图函数"""
    return render_template("index.html")


if __name__ == "__main__":
    # mptt_session = mptt_sessionmaker(sessionmaker(bind=engine))
    # get_simple_json()
    # 启动flask
    app.run(debug=True)
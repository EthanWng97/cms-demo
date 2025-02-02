from . import dataset, db_session
from . import utils
from flask import request, render_template
import json

from sys import setswitchinterval
from flask import Blueprint, Flask, render_template, request


# class Tree(Base, BaseNestedSets):
#     __tablename__ = "dbo.springtb"
#     id = Column(String, primary_key=True)
#     name = Column(String)

#     def __repr__(self):
#         return "<Node (%s)>" % self.id


# 定义url请求路径
@dataset.route("/")
def hello_world():
    """定义视图函数"""
    return render_template("index.html")

@dataset.route("/dataset/tree", methods=["GET", "POST"])
def dateset_tree():
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
    
    result = utils.get_tree_data(sid)
    return json.dumps(result)

@dataset.route("/dataset/action", methods=["GET", "POST"])
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
    isJson = utils.is_json(action_json)
    result = utils.get_action_data(action_json)
    return json.dumps(result)


@dataset.route("/dataset/form", methods=["GET", "POST"])
def dataset_form():
    """ 在 springtb 中获取特定表的字段属性值
    Args:
        form:指定数据库 + 表格信息
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
    form_json = request.form.get("form")
    isJson = utils.is_json(form_json)
    result = utils.get_form_data(form_json)
    return json.dumps(result)


@dataset.route("/dataset/table1/<sid>", methods=["GET", "POST"])
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
    tmp_result = utils.get_table_data(table1_json, "table1")
    result = {
            "code":0,
            "msg":"",
            "count":1000,
            "data": tmp_result
        }
    return json.dumps(result)

@dataset.route("/dataset/table2/<sid>", methods=["GET", "POST"])
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
    tmp_result = utils.get_table_data(table2_json, "table2")
    result = {
            "code":0,
            "msg":"",
            "count":1000,
            "data": tmp_result
        }
    return json.dumps(result)
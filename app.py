import json
from flask import Flask, render_template, request
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy_mptt import mptt_sessionmaker
from sqlalchemy_mptt.mixins import BaseNestedSets

Base = declarative_base()
engine = create_engine(
    "postgresql+psycopg2://postgres:postgres@198.13.60.74:5433/wangyifan",
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


def traverse_trees(tab=1, sid="NULL"):
    group = db_session.execute(
        "SELECT * FROM dbo.springtb WHERE dbo.springtb.pid = '%s' ORDER BY queue"
        % (sid)
    ).fetchall()
    if not group:
        return
    tab = tab + 1
    for i in group:
        if i.description:
            print("- " * tab + i.description + "[" + i.name + "]")
        else:
            print("- " * tab + i.name)
        traverse_trees(tab, i.sid)


def print_all_tree(tab=1):
    """
    :param int tab: format output via tab
    """
    traverse_trees()
    group = db_session.execute(
        "SELECT * FROM dbo.springtb WHERE dbo.springtb.pid IS NULL ORDER BY queue"
    ).fetchall()
    for i in group:
        print("- " + i.name)
        traverse_trees(sid=i.sid)


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
    if(sid is None):
        return "SELECT * FROM dbo.springtb WHERE dbo.springtb.pid IS NULL ORDER BY queue"
    else:
        return "SELECT * FROM dbo.springtb WHERE dbo.springtb.pid = '%s' ORDER BY queue" % (sid)

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
                sql_string += "union all ( "+ _construct_select_sqlstring(each_sid)  + ") "
    return db_session.execute(sql_string).fetchall()


# 创建flask的应用对象
# __name__表示当前的模块名称
# 模块名: flask以这个模块所在的目录为根目录，默认这个目录中的static为静态目录，templates为模板目录
app = Flask(__name__)


@app.route("/getjson", methods=["GET", "POST"])  # 路由
def get_single_json():
    sid = request.args.get("sId")
    groups = _fetch_tree_data(sid)
    result = []
    for i in groups:
        _dict = _contruct_dict(i.sid, i.pid, i.description, i.name, i.tbtype)
        result.append(_dict)
    return json.dumps(result)

# @app.route("/getjsontest", methods=["GET", "POST"])  # 路由
# def get_single_json():
#     sid = request.form.get("sId")
#     isJson = _is_json(sid)
#     groups = _fetch_tree_data(sid, isJson)
#     result = {}
#     for i in groups:
#         _dict = _contruct_dict(i.sid, i.pid, i.description, i.name, i.tbtype)
#         result.append(_dict)
#     return json.dumps(result)

@app.route("/getunionjson", methods=["GET", "POST"])
def get_union_json():
    sid = request.form.get("sId")
    isJson = _is_json(sid)
    groups = _fetch_tree_data(sid, isJson)
    result = {}
    for i in groups:
        pid = _xpid(i.pid)
        _dict = _contruct_dict(i.sid, i.pid, i.description, i.name, i.tbtype)
        if pid not in result.keys():
            result[pid] = []
        result[pid].append(_dict)
    return json.dumps(result)


# 定义url请求路径
@app.route("/")
def hello_world():
    """定义视图函数"""
    return render_template("index.html")


if __name__ == "__main__":
    mptt_session = mptt_sessionmaker(sessionmaker(bind=engine))
    # get_simple_json()
    # 启动flask
    app.run(debug=True)

from flask import Flask
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy_mptt import mptt_sessionmaker
from sqlalchemy_mptt.mixins import BaseNestedSets

Base = declarative_base()

class Tree(Base, BaseNestedSets):
    __tablename__ = "tree"
    id = Column(Integer, primary_key=True)
    name = Column(String(8))

    def __repr__(self):
        return "<Node (%s)>" % self.id


def print_tree(group_name, tab=1):
    """
    :param str group_name:要查找的树的根的名称
    :param int tab: 格式化用的-数量
    """
    group = db_session.query(Tree).filter_by(
        name=group_name).one_or_none()  # type: TreeGroup
    if not group:
        return
    # group found - print name and find children
    print('- ' * tab + group.name)
    for child_group in group.children:  # type: TreeGroup
        # new tabulation value for child record
        print_tree(child_group.name, tab * 2)


# 创建flask的应用对象
# __name__表示当前的模块名称
# 模块名: flask以这个模块所在的目录为根目录，默认这个目录中的static为静态目录，templates为模板目录
app = Flask(__name__)

# 定义url请求路径
@app.route('/')
def hello_world():
    """定义视图函数"""
    return 'Hello World!'


if __name__ == '__main__':
    engine = create_engine(
        'postgresql+psycopg2://postgres:postgres@198.13.60.74:5433/wangyifan')
    mptt_session = mptt_sessionmaker(sessionmaker(bind=engine))
    db_session = scoped_session(sessionmaker(bind=engine))
    rows = db_session.execute(
        "SELECT * FROM dbo.springtb").fetchall()
    for row in rows:
        print(row) 
        # print(f"{row.origin} to {flight.destination}, {flight.duration} minutes.")
    # 启动flask
    # app.run()

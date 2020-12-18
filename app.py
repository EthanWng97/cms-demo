from flask import Flask

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
    # 启动flask
    app.run()
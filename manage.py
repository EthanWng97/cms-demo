from app import create_app

app = create_app()
if __name__ == "__main__":
    # get_simple_json()
    # 启动flask
    app.run(debug=True)
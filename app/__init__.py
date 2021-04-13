from flask import Flask

def create_app():
    app = Flask(__name__)
    app.debug = True

    from .dataset import dataset as dataset_blueprint
    app.register_blueprint(dataset_blueprint)
        
    return app
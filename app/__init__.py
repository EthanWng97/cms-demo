from flask import Flask, render_template
from app.dataset import dataset

def create_app():
    app = Flask(__name__)
    app.debug = True

    from .dataset import dataset as dataset_blueprint
    app.register_blueprint(dataset_blueprint)
        
    return app
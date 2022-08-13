from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from endpoints import get_blueprints

def create_app() -> Flask:
    app = Flask("plant_api")

    # setup app confg
    # app.config['key'] = value

    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config['SQLALCHEMY_DATABASE_URI'] = None #'sqlite:////tmp/test.db' # TODO, when uqcloud gets setup

    for blueprint in get_blueprints():
        app.register_blueprint(blueprint)

    db = SQLAlchemy(app)
    db.init_app(app)

    return app

# Initial setup
app: Flask = create_app()
db: SQLAlchemy = SQLAlchemy(app)
db.init_app(app)

if __name__ == "__main__":
    app.run(debug=False, port=5000)
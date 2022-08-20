from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from endpoints import get_blueprints
from data.DB import CONNECTION_STRING, SESSION
from data import User, Plant, PlantType

def create_app() -> Flask:
    app = Flask("plant_api")

    # setup app confg
    # app.config['key'] = value

    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config['SQLALCHEMY_DATABASE_URI'] = CONNECTION_STRING #None #'sqlite:////tmp/test.db' # TODO, when uqcloud gets setup

    for blueprint in get_blueprints():
        app.register_blueprint(blueprint)

    db = SQLAlchemy(app)
    db.init_app(app)

    return app

# Initial setup
app: Flask = create_app()
db: SQLAlchemy = SQLAlchemy(app)
db.init_app(app)

@app.route("/")
def root():
    return "Welcome to our friendly Plants API. Check the Docs."

if __name__ == "__main__":
    # session = SESSION()
    # admin = User(username='bobbithy', email='bob@example.com')
    # session.add(admin)
    # session.commit()

    # plantType = PlantType(type='tester',commonName='Testing Plant', fullName='Read Leafed Testing Plant')
    # plant = Plant(name="Desmond Jones", desc="My favourite potted plant", plantTypeId=1, userId=1)

    # session.add_all([plantType, plant])
    # session.commit()

    app.run(debug=False, port=3000)
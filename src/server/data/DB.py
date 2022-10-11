
from sqlalchemy import create_engine, MetaData
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy_utils import database_exists, create_database
from sqlalchemy.orm import sessionmaker


# potentially do dot env stuff here, but it's less important since security issues aren't in scope for DECO3801

DBM = "mysql"
HST = "localhost"
DTB = "plants"
USR = "root"
PWD = "E415EEF018"
PRT = "3306"
CONNECTION_STRING = f"{DBM}://{USR}:{PWD}@{HST}:{PRT}/{DTB}"

# Setup the engine which allows SQLAlchemy to be used with MySQL
ENGINE = create_engine(CONNECTION_STRING, pool_recycle = 280)
BASE = declarative_base()
SESSION = sessionmaker(bind = ENGINE)

if not database_exists(ENGINE.url):
    create_database(ENGINE.url)

    # BASE.metadata.create_all(ENGINE)
    # Session = sessionmaker(bind=ENGINE)
    # db.session = Session()

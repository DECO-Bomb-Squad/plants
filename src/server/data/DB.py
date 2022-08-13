
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base


# potentially do dot env stuff here, but it's less important since security issues aren't in scope for DECO3801

# Set up DBM, host, name, port and create the connection string


CONNECTION_STRING = ""

# Setup the engine which allows SQLAlchemy to be used with MySQL
ENGINE = create_engine(CONNECTION_STRING)

# We initialise an SQLAlchemy Base for all models 
BASE = declarative_base()

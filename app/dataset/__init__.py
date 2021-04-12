# coding:utf8
 
from flask import Blueprint
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy import sql
from sqlalchemy.orm import scoped_session, sessionmaker


 
dataset = Blueprint("dataset",__name__)

Base = declarative_base()
engine = create_engine(
    "postgresql+psycopg2://postgres:19971004@198.13.60.74:5432/postgres",
    pool_size=50,
    max_overflow=20,
)
db_session = scoped_session(sessionmaker(bind=engine))

 
from . import views
from . import utils
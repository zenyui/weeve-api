import datetime
from server.models import db

class Tag(db.Model):
    __tablename__ = 'TAGS'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    tag = db.Column(db.String(30), primary_key=False, unique=True, nullable=False)
    created_date = db.Column(db.DateTime, nullable=False, default=datetime.datetime.now())

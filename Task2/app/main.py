from datetime import datetime
import os
import time
from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI, HTTPException, status
from pydantic import BaseModel, ConfigDict, Field, field_validator
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from database import Base, engine, get_db
from models import Message


APP_TITLE = os.getenv("APP_TITLE", "Kubernetes Guestbook API")
APP_VERSION = "1.0.0"


class MessageCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    content: str = Field(min_length=1)

    @field_validator("name", "content")
    @classmethod
    def reject_blank_values(cls, value):
        value = value.strip()
        if not value:
            raise ValueError("This field cannot be empty.")
        return value


class MessageResponse(BaseModel):
    id: int
    name: str
    content: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Wait for MySQL to become available before accepting requests.
    for attempt in range(30):
        try:
            with engine.connect() as connection:
                connection.execute(text("SELECT 1"))

            Base.metadata.create_all(bind=engine)
            print("Database connection established successfully.")
            break

        except SQLAlchemyError as error:
            print(f"Database connection attempt {attempt + 1}/30 failed: {error}")
            if attempt == 29:
                raise RuntimeError("Could not connect to MySQL.") from error
            time.sleep(2)

    yield

    engine.dispose()


app = FastAPI(
    title=APP_TITLE,
    version=APP_VERSION,
    lifespan=lifespan,
)


@app.get("/")
def root():
    return {
        "message": "Guestbook API is running",
        "docs": "/docs",
    }


@app.get("/api/info")
def get_info():
    return {
        "app_title": APP_TITLE,
        "version": APP_VERSION,
        "database": "MySQL",
    }


@app.get(
    "/api/messages",
    response_model=list[MessageResponse],
)
def get_messages(db: Session = Depends(get_db)):
    return (
        db.query(Message)
        .order_by(Message.created_at.desc(), Message.id.desc())
        .all()
    )


@app.post(
    "/api/messages",
    response_model=MessageResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_message(
    message: MessageCreate,
    db: Session = Depends(get_db),
):
    new_message = Message(
        name=message.name,
        content=message.content,
    )

    try:
        db.add(new_message)
        db.commit()
        db.refresh(new_message)
        return new_message

    except SQLAlchemyError as error:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Could not save the message.",
        ) from error

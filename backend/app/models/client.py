from typing import Optional

from sqlmodel import Field, Relationship

from .common import TimestampedModel


class Client(TimestampedModel, table=True):
    __tablename__ = "clients"

    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(max_length=255)
    client_type: str = Field(max_length=50)
    is_active: bool = Field(default=True)

    representatives: list["ClientRepresentative"] = Relationship(
        back_populates="client",
        sa_relationship_kwargs={"cascade": "all, delete-orphan"},
    )


class ClientRepresentative(TimestampedModel, table=True):
    __tablename__ = "client_representatives"

    id: Optional[int] = Field(default=None, primary_key=True)
    client_id: int = Field(foreign_key="clients.id")
    full_name: str = Field(max_length=255)
    person_type: str = Field(max_length=50)
    document_type: str = Field(max_length=50)
    document_number: str = Field(max_length=100)
    email: str | None = Field(default=None, max_length=255)
    phone: str | None = Field(default=None, max_length=64)
    address: str | None = Field(default=None, max_length=255)
    notes: str | None = Field(default=None, max_length=255)
    is_active: bool = Field(default=True)

    client: Client = Relationship(back_populates="representatives")

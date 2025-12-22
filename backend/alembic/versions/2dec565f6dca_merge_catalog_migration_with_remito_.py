"""Merge catalog migration with remito merma migration

Revision ID: 2dec565f6dca
Revises: 20250214_0004, 9d07e62a3ee7
Create Date: 2025-12-20 13:02:50.991253

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '2dec565f6dca'
down_revision: Union[str, None] = ('20250214_0004', '9d07e62a3ee7')
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass

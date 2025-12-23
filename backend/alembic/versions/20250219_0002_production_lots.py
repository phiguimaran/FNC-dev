"""add production lots and link stock movements

Revision ID: 20250219_0002
Revises: 20250219_0001_semi_conversion_rules
Create Date: 2025-02-19 00:02:00.000000
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.sql import func

# revision identifiers, used by Alembic.
revision: str = "20250219_0002"
down_revision: Union[str, None] = "20250219_0001_semi_conversion_rules"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "production_lots",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("lot_code", sa.String(length=64), nullable=False, unique=True),
        sa.Column("sku_id", sa.Integer(), sa.ForeignKey("skus.id"), nullable=False),
        sa.Column("deposit_id", sa.Integer(), sa.ForeignKey("deposits.id"), nullable=False),
        sa.Column("production_line_id", sa.Integer(), sa.ForeignKey("production_lines.id"), nullable=True),
        sa.Column("produced_quantity", sa.Numeric(14, 4), nullable=False),
        sa.Column("remaining_quantity", sa.Numeric(14, 4), nullable=False),
        sa.Column("produced_at", sa.Date(), nullable=False, server_default=func.current_date()),
        sa.Column("is_blocked", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("notes", sa.String(length=255), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=func.now()),
    )

    op.add_column("stock_movements", sa.Column("production_lot_id", sa.Integer(), nullable=True))
    op.create_foreign_key(
        "fk_stock_movements_production_lot",
        "stock_movements",
        "production_lots",
        ["production_lot_id"],
        ["id"],
    )


def downgrade() -> None:
    op.drop_constraint("fk_stock_movements_production_lot", "stock_movements", type_="foreignkey")
    op.drop_column("stock_movements", "production_lot_id")
    op.drop_table("production_lots")

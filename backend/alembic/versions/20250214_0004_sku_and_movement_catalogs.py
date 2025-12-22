"""Add administrable SKU and stock movement types

Revision ID: 20250214_0004
Revises: a25ec5cec522
Create Date: 2025-02-14
"""

from datetime import datetime

from alembic import op
import sqlalchemy as sa
from sqlalchemy.sql import table, column


# revision identifiers, used by Alembic.
revision = "20250214_0004"
down_revision = "a25ec5cec522"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # --------------------------------------------------------------------
    # SAFETY: ensure enum skutag accepts all codes we will use
    # --------------------------------------------------------------------
    bind = op.get_bind()

    bind.execute(sa.text("""
    DO $$
    DECLARE
        needed_values TEXT[] := ARRAY['CON','PAP','LIM','PACK','OTRO'];
        v TEXT;
    BEGIN
        FOREACH v IN ARRAY needed_values LOOP
            IF NOT EXISTS (
                SELECT 1 FROM pg_enum
                WHERE enumlabel = v
                AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'skutag')
            ) THEN
                EXECUTE format('ALTER TYPE skutag ADD VALUE %L', v);
            END IF;
        END LOOP;
    END$$;
    """))

    # --------------------------------------------------------------------
    # CREATE new tables
    # --------------------------------------------------------------------
    op.create_table(
        "sku_types",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("code", sa.String(length=16), nullable=False),
        sa.Column("label", sa.String(length=255), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.text("true")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.text("now()")),
        sa.UniqueConstraint("code", name="uq_sku_types_code"),
    )

    op.create_table(
        "stock_movement_types",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("code", sa.String(length=50), nullable=False),
        sa.Column("label", sa.String(length=255), nullable=False),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.text("true")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.text("now()")),
        sa.UniqueConstraint("code", name="uq_stock_movement_types_code"),
    )


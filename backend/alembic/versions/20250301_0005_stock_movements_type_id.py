"""Add movement_type_id to stock_movements

Revision ID: 20250301_0005
Revises: 20250214_0004
Create Date: 2025-03-01
"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "20250301_0005"
down_revision = "20250214_0004"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("stock_movements", sa.Column("movement_type_id", sa.Integer(), nullable=True))

    op.execute(
        sa.text(
            """
            INSERT INTO stock_movement_types (code, label, is_active, created_at, updated_at)
            VALUES
                ('PRODUCTION', 'Producción', TRUE, NOW(), NOW()),
                ('CONSUMPTION', 'Consumo / Receta', TRUE, NOW(), NOW()),
                ('ADJUSTMENT', 'Ajuste', TRUE, NOW(), NOW()),
                ('TRANSFER', 'Transferencia', TRUE, NOW(), NOW()),
                ('REMITO', 'Remito', TRUE, NOW(), NOW()),
                ('MERMA', 'Merma', TRUE, NOW(), NOW())
            ON CONFLICT (code) DO NOTHING
            """
        )
    )

    op.execute(
        sa.text(
            """
            UPDATE stock_movements sm
            SET movement_type_id = mt.id
            FROM stock_movement_types mt
            WHERE sm.movement_type_id IS NULL
              AND UPPER(sm.movement_type::text) = UPPER(mt.code)
            """
        )
    )

    op.alter_column("stock_movements", "movement_type_id", nullable=False)
    op.create_foreign_key(
        "stock_movements_movement_type_id_fkey",
        "stock_movements",
        "stock_movement_types",
        ["movement_type_id"],
        ["id"],
    )


def downgrade() -> None:
    op.drop_constraint("stock_movements_movement_type_id_fkey", "stock_movements", type_="foreignkey")
    op.drop_column("stock_movements", "movement_type_id")

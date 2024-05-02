# Generated by Django 3.1.7 on 2021-03-08 11:35

import django.contrib.postgres.indexes
from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("invoice", "0004_auto_20200810_1415"),
    ]

    operations = [
        migrations.AddIndex(
            model_name="invoice",
            index=django.contrib.postgres.indexes.GinIndex(
                fields=["private_metadata"], name="invoice_p_meta_idx"
            ),
        ),
        migrations.AddIndex(
            model_name="invoice",
            index=django.contrib.postgres.indexes.GinIndex(
                fields=["metadata"], name="invoice_meta_idx"
            ),
        ),
    ]

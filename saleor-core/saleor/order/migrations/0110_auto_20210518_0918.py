# Generated by Django 3.2.2 on 2021-05-18 09:18

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("order", "0109_undiscounted_prices"),
    ]

    operations = [
        migrations.AddField(
            model_name="fulfillment",
            name="shipping_refund_amount",
            field=models.DecimalField(
                blank=True, decimal_places=3, max_digits=12, null=True
            ),
        ),
        migrations.AddField(
            model_name="fulfillment",
            name="total_refund_amount",
            field=models.DecimalField(
                blank=True, decimal_places=3, max_digits=12, null=True
            ),
        ),
    ]
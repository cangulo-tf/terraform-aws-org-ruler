locals {
  auto_adjust_budgets = {
    "daily-autoadjusted-budget" = {
      name         = "${local.budget_prefix}-daily-autoadjusted-budget"
      budget_type  = "COST"
      limit_amount = var.budget_daily_limit_amount
      limit_unit   = "USD"
      time_unit    = "DAILY"
      auto_adjust_data = {
        "forecast" = {
          auto_adjust_type = "FORECAST"
        }
      }
      notifications = {
        "actual_100" = {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 100
          threshold_type             = "PERCENTAGE"
          notification_type          = "ACTUAL"
          subscriber_email_addresses = [var.budget_notification_email]
        }
      }
    }
  }
}

resource "aws_budgets_budget" "auto_adjust_budgets" {
  for_each = local.auto_adjust_budgets

  name         = each.value.name
  budget_type  = each.value.budget_type
  limit_amount = each.value.limit_amount
  limit_unit   = each.value.limit_unit
  time_unit    = each.value.time_unit

  dynamic "notification" {
    for_each = each.value.notifications
    content {
      comparison_operator        = notification.value.comparison_operator
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = notification.value.subscriber_email_addresses
    }
  }

  dynamic "auto_adjust_data" {
    for_each = try(each.value.auto_adjust_data, {})
    content {
      auto_adjust_type = auto_adjust_data.value.auto_adjust_type
    }
  }

  lifecycle {
    ignore_changes = [
      limit_amount # limit_amount is auto-adjusted
    ]
  }
}

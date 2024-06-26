locals {
  budget_prefix = "all-accounts"
  fix_budgets = {
    "daily-fix-budget" = {
      name         = "${local.budget_prefix}-daily-budget"
      budget_type  = "COST"
      limit_amount = var.budget_daily_limit_amount
      limit_unit   = "USD"
      time_unit    = "DAILY"
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
    "monthly-fix-budget" = {
      name         = "${local.budget_prefix}-monthly-budget"
      budget_type  = "COST"
      limit_amount = var.budget_monthly_limit_amount
      limit_unit   = "USD"
      time_unit    = "MONTHLY"
      notifications = {
        "actual_100" = {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 100
          threshold_type             = "PERCENTAGE"
          notification_type          = "ACTUAL"
          subscriber_email_addresses = [var.budget_notification_email]
        }
        "forecast_100" = {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 100
          threshold_type             = "PERCENTAGE"
          notification_type          = "FORECASTED"
          subscriber_email_addresses = [var.budget_notification_email]
        }
        "forecast_50" = {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 50
          threshold_type             = "PERCENTAGE"
          notification_type          = "FORECASTED"
          subscriber_email_addresses = [var.budget_notification_email]
        }
      }
    }
  }
}

resource "aws_budgets_budget" "fix_budgets" {
  for_each = local.fix_budgets

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
}

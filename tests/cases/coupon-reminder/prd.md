# Coupon Reminder Feature

## Background

Some users enter checkout with available coupons but still place orders without applying them. To improve conversion, the system should remind eligible users to use coupons at the right time.

This feature will launch first on the mobile app checkout flow. Other clients may follow later if the result is good.

## Goal

- Increase coupon usage rate for eligible users
- Reduce missed-discount orders

## Requirements

### Main Flow

- Support reminding users before order submission.
- Active users should receive the reminder in a proper way.
- If the coupon is valid, the page should show a more obvious reminder.
- Users should be able to continue placing the order even if they do not use the coupon.

### Special Handling

- For abnormal orders, the reminder strategy should be adjusted accordingly.
- If needed, the coupon reminder can be retried.
- The system should avoid disturbing users too much.

### Data And Monitoring

- Relevant teams should be able to monitor reminder effectiveness.
- The feature should support later analysis of conversion improvement.

## Notes

- Engineering should reuse the existing coupon capability where possible.
- PM will provide final UI copy later.

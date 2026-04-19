# Refund Ops Dashboard

## Background

The refund team currently checks abnormal refund cases through multiple internal tools and chat messages. This causes slow handling and inconsistent follow-up. A unified dashboard is needed so operations can review and process pending abnormal refunds more efficiently.

The first version is for internal web only.

## Goal

- Improve handling efficiency for abnormal refund cases
- Reduce missed or duplicated processing
- Support later review of operator actions

## Requirements

### List View

- Show all pending abnormal refund cases in one dashboard.
- Data should be updated in a timely manner.
- Operators should be able to filter by business line, refund status, and risk level.
- The list should support quick search when needed.

### Case Handling

- Operators can open a case and mark it as processed.
- Operators should be able to add handling remarks.
- High-risk cases should require extra confirmation before processing.
- The system should avoid repeated processing of the same case.

### Collaboration And Audit

- Ops and finance should both be able to use the dashboard.
- The system should keep a complete audit trail for later review.
- If necessary, the result list should support export.

## Notes

- Engineering should reuse existing refund data services where possible.
- PM will provide the final page layout later.

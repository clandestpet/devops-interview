## Troubleshooting exercise. No installs needed.

The team locked down the orders queue after a security scare. After the change
went to staging, two things broke:

  - POST /orders returns 500.
  - Nothing is being processed. Messages pile up in the queue and the
    orders_processor Lambda shows no invocations.

Evidence is in errors.txt. 

The queue and the two roles involved are in queue.tf
and roles.tf. 

Talk us through how you would work out what is wrong, what you
would check and in what order, and how you would fix it. Then tell us how you
would stop it happening again.

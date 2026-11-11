## Troubleshooting exercise

We just deployed the orders service to staging. Two things broke:

  - POST /orders returns 500.
  - Nothing is being processed. Messages pile up in the queue and the
    orders_processor Lambda shows no invocations.

The error text is in errors.txt. The queue and the two roles that use it, with
their permissions, are in orders.tf.

Talk us through how you would work out what is wrong, what you would check
first, and how you would fix it.

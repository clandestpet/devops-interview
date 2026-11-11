# DevOps Interview

This is a 30 minute session. You do not need to install, run or deploy anything. We want to hear how you think, so talk out loud.

## Walkthrough

1. **Get ready.** Share your screen and open this folder in a text editor you are comfortable in.
2. **Start with a chat.** We will ask a couple of questions about your past work.
3. **Open `deploy.yml`.** It is the pipeline for our orders service, and it is about to be merged. Tell us what is risky about it and why. About 5 minutes.
4. **Make it safer.** Tell us, or sketch in the file, how you would add tests, staged deploys and rollback. About 5 minutes.
5. **Ask us anything.** The last few minutes are yours.

## Context

- The pipeline deploys `orders_processor`, a Lambda that takes orders from a queue, writes them to a MySQL database and calls a payment API.
- The same pipeline runs the database migrations (Flyway).
- Every engineer and contractor can read this repo.
- Recently, a release went out with failing tests and we rolled it back by hand at night. Another release failed because the code needed a database column that was not there yet.

## Tips

- Explain your reasoning, not just the answer.
- Ask questions if something is unclear.
- You will not be expected to find everything. Prioritizing matters more than a long list.

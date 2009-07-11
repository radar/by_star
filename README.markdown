# Can Touch This

Can Touch This is a permissions system extracted from rboard.

## How can I touch this?

You need to `include CanTouchThis` in the model you want to have permissions on (in rboard, this is the User model).

You'll also need to create two tables: `groups` and `group_(your model's pluralized name)` (in rboard, group_users). Here's the schema until I can find a nicer way.
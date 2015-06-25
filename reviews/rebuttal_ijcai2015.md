Thanks to all reviewers for your comments.

## Reviewer 1:

This paper presents a significant extension to the ad hoc teamwork
problem. Ad hoc team research focuses on the problem where all agents
know the domain except the ad hoc agent, and those agents cannot be
modified. Therefore, we cannot change the other agents to have them
tell the new agents what to do. An example of this scenario is when a
new robot is deployed to a location where there are already older
robots working. The ad hoc agent can only influence them using the
actions in the world and thus cannot directly exchange the required
information. Also, the communication protocol itself is unknown.  Our
main contribution is the formulation of this complex problem in a way
that can be addressed by an efficient online method based on a
Bayesian filter.

## Reviewer 2:

We thank the reviewer for all the valuable insights that we can use
for a longer version of the paper and in future work.  It is true that
the difficulty in this domain arises from the agents' limited
observability, as our agent can quickly interpret the task and its
desired role when it can observe all the agents.  Our algorithm is
designed for scenarios with partial observability, where the ad hoc
agent must interpret the ambiguous messages of its teammates.

## Review 3:

An example of adhoc teamwork arises when a new robot is deployed to a
location where there are already older robots working.  The main
challenge is that solving for all of the variables simultaneously is
computationally expensive and if care is not taken it will be easy to
get stuck in local minima.

The difficulty of the problem does not come from delayed feedback;
even with instantaneous rewards the problem would exist. The
challenge is that the agent does not observe the reward and cannot
estimate it directly because it does not know which task needs to be
done.  

We used value iteration to compute the policies.  

We agree that theoretical results that would be interesting include
the impact of using approximate spaces of domains and using
approximate filtering methods to reduce computational complexity.
Future work will consider how to remove the assumption that predators
see each other.

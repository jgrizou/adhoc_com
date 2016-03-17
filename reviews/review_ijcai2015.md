## Reviewer 1

- Originality of ideas                          : 6
- Correctness                                   : 6
- Significance of results                       : 5
- Clarity and quality of presentation           : 6
- Confidence                                    : 6
- Overall recommendation                        : 5

### Comments to the author(s):

This paper presents a new method for achieving collaboration between agents in an ad-hoc framework. Unlike previous work, it tries to address uncertainty about tasks, roles, and communication protocols.

While the reviewers found the results interesting, their significance is greatly weakened by the restrictive assumption that a prior distribution is given over the unknown tasks, roles, and communication protocols. As a result, the technical contribution is extremely limited, as it merely requires an application of Bayes rule and then existing planning methods.

### Summary:
While the reviewers found the results interesting, their significance is greatly weakened by the restrictive assumption that a prior distribution is given over the unknown tasks, roles, and communication protocols. As a result, the technical contribution is extremely limited, as it merely requires an application of Bayes rule and then existing planning methods.

## Review from Reviewer 2

- Originality of ideas                          : 8
- Correctness                                   : 7
- Significance of results                       : 6
- Clarity and quality of presentation           : 7
- Confidence                                    : 6
- Overall recommendation                        : 7

### Comments to the author(s):

- The paper mentioned that “previous research has assumed that either the task, the role of each agent, or the communication protocol… is known before the interaction begins”, while this paper consider these three variables simultaneously, but it does not mention what is the challenge for doing so? One thing I can imagine is the modeling and computational complexity. However, the assumption of knowing the distribution of possible tasks, roles, and communication protocols, makes the problem sounds less difficult.

- The technical contribution is limited, the empirical results look interesting. It might be better, the framework can be grounded on some theory.

- On P2, the author mentioned “the main challenge is that the ad hoc agent does not have direct access to its performance”, which seems to be related to the issue of delayed feedback. It is not clear to me how this address in the multiagent learning problem considered in this paper.

- On P3, the author mentioned “using reinforcement learning dynamic programming methods [Sutton and Barto, 1998]”. It is not clear to me what kind of RL algorithm is used, TD, Monte Carlo?

- On P4, "the predators can still see each other" seems to be a very restrictive assumption. Why it need this assumption?

minor comments:

There are a few typos

- P3 left: “They actions” ->”Their actions”

- The left hand side of equation (7) is wrong

- P3 right: “Figure 1a and 1c” should be “Figure 1a and 1b”

- in P5, equation (8) The author assume the just distribution P(s'_prey, s_prey) = P(s’_prey)P(s_prey), which seems incorrect to encode the Markov process.

equation (10) seems wrong, the right hand side sums to one?

### Summary:
This paper studied a difficult problem of multi-agent interaction without pre-coordination, where tasks, roles and communication protocols are considered simultaneously. Although a few assumptions in this paper make the solution sounds trivial, the idea of this paper is interesting and well justified by experiments.

## Review from Reviewer 3

- Originality of ideas                          : 7
- Correctness                                   : 7
- Significance of results                       : 6
- Clarity and quality of presentation           : 8
- Confidence                                    : 7
- Overall recommendation                        : 7

### Comments to the author(s):

This paper present how an ad hoc agent can be integrated into a team to perform its role whilst communicating with other agents without knowing the task to accomplish. The paper is well written - grammatically correct and easy to read. The authors formulate how they represent the pursuit domain in detail using different scenarios regarding when agents have full knowledge and when one agent is removed (with and without full observability). The authors also consider some issues of ad hoc communications such as link failures or interference and introduce 20% artificial noise and error into their approach. From this perspective, I believe that the authors were not only trying to accomplish complex agent behaviour, but also trying to achieve more realistic agent behaviour as well. The authors accept that the proposed agent behaviour is complex, therefore resulting in computationally heavy processing and encounters high computational cost, which is an honest remark that adds to the objectivity of the presentation. Although the authors modified their approach to minimise this cost, it might be very interesting to see how this reflects on a MRS in one of their future studies. I also believe that the authors can make an interesting discussion in their presentation based on computational intensity, time and current resource capabilities.

I also like how the authors present their scenarios and results in this work: as expected ad hoc communications improve the performance dramatically as opposed to no communication using partial observability. It is interesting to see how small the difference is between the full observability with no communications and partial observation with ad hoc communications. This concludes that when agents have full observability, the environment is not challenging enough and might be modified in the future for more complex analysis as the proposed ad hoc technique does not show any improvement on this scenario. It is perhaps better to find more scenarios like random walk (R-FO) where the authors can compare their proposed approach based on the partial observability.

== Final remarks after author response and discussion ==

My main concern is the limited depth of the analysis. Since the algorithm is essentially "only" a Bayes filter, I would have liked to see a more challenging task setting. E.g., what happens if the correct task domain is not part of the hypotheses? How does this influence performance? What happens if the goal changes more drastically, e.g. instead of capturing the prey it needs to be followed or guided? A more extensive discussion of such settings and their impact on the performance would greatly strengthen the work.

### Summary:
The paper is well written - grammatically correct and easy to read. The work seems original, experiments are well described and results are interesting, although of a rather preliminary nature. More extensive experiments focussing on the robustness of the algorithm w.r.t. uncertainty or incomplete hypotheses space would strengthen the paper.


### Review from Reviewer 4

- Originality of ideas                          : 2
- Correctness                                   : 5
- Significance of results                       : 2
- Clarity and quality of presentation           : 4
- Confidence                                    : 6
- Overall recommendation                        : 2

### Comments to the author(s):

This paper presents a problem model for ad hoc teamwork, where an ad hoc agent is uncertain about the domain it will work on. This model assumes the agent can access to a known  of domains, which contains this domain. This paper proposes an algorithm to estimate which domain the ad hoc agent will work on from the observed state transitions and communication.

The problem of ad hoc collaboration with uncertainty on tasks, roles, and communication is interesting, but this paper is in a very preliminary stage for addressing this problem. First, the proposed model is not clearly defined and not well motivated. If all agents know the domain, why agents can be designed to be able to tell new ad hoc agents about the domain? This is just a simple robot design. Second, the extension to existing ad hoc teamwork is insignificant or trivial. This paper seemed to address a "harder" problem with uncertain tasks, roles, and communication protocols, but knowing the distribution of tasks, roles, and communication protocols makes the ad hoc collaboration problem almost the same as what previous work address. Finally, the algorithmic contribution is incremental. As the distribution of the domains is know, as done in this paper, we can simply employ the Bayes' rule so that we apply existing planning techniques to address the ad hoc collaboration problem. The
 refore, the contribution in terms of both model and algorithm is insignificant.

### Summary:

The ad hoc collaboration problem this paper studies looks interesting, but its problem model is not well motivated and the contribution of its algorithm is trivial.

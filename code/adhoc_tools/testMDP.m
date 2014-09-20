tic
a = ToroidalGridMDP(7,0.9);
a.add_obstacle_at_position([3,3])
a.add_obstacle_at_position([2,3])
a.add_obstacle_at_position([3,2])
a.add_obstacle_at_position([1,2])
a.set_unitary_sparse_reward_at_position([4,2])
a.build_MDP()

[Q, P] = VI(a);
toc

imagesc(P)

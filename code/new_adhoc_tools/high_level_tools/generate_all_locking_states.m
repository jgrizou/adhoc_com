function allLockingState = generate_all_locking_states(gridSize)
%GENERATE_ALL_LOCKING_STATES 

environment = ToroidalGridMDP(gridSize, 0);
allLockingState = environment.get_all_states();

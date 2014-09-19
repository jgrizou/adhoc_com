function allLockingState = generate_all_locking_states(gridSize)
%GENERATE_ALL_LOCKING_STATES 

environment = ToroidalGrid(gridSize);
allLockingState = environment.list_all_states();

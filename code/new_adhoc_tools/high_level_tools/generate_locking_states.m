function lockingStates = generate_locking_states(gridSize, nLockingStates)

allLockingState = generate_all_locking_states(gridSize);
permIdx = randperm(length(allLockingState));
lockingStates = allLockingState(permIdx(1:nLockingStates));


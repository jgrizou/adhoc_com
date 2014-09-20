function isMember = is_member_optimized_row_one_state_several_states(oneStates, severalStates)
%IS_MEMBER_OPTIMIZED_ROW_ONE_STATE_SEVERAL_STATES Summary of this function goes here

isMember = any(all(repmat(oneStates, size(severalStates, 1), 1) == severalStates, 2));


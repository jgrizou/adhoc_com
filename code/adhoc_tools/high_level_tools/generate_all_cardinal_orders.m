function allCardinalOrders = generate_all_cardinal_orders()

allCardinalOrders = perms(1:4);

% we want cells as ouput
allCardinalOrders = num2cell(allCardinalOrders, 2);


function cardinalOrders = generate_cardinal_orders(nCardinalOrder)

allCardinalOrders = generate_all_cardinal_orders();
permIdx = randperm(length(allCardinalOrders));
cardinalOrders = allCardinalOrders(permIdx(1:nCardinalOrder));
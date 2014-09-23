function allMappings = generate_mappings(gridSize, nMapping)

nElements = gridSize^2;

allMappings = zeros(nMapping, nElements);
for i = 1:nMapping
    newMapping = randperm(nElements);
    while ismember(newMapping, allMappings, 'rows')
        newMapping = randperm(nElements);
    end
    allMappings(i, :) = newMapping;
end

% we want cells as ouput
allMappings = num2cell(allMappings, 2);
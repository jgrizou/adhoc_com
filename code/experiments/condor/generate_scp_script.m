function generate_scp_script(scriptFilename, folderWithResults)

computerPath = '/home/jgrizou/Dropbox';
condorPath = '/projects/agents5/grizou';

condorFolderWithResults = strgsub(folderWithResults, computerPath, condorPath);
condorFolderMatFiles = fullfile(condorFolderWithResults, '*');

stringCell = {};
stringCell{end+1} = '#!/bin/bash';
stringCell{end+1} = '';
stringCell{end+1} = ['scp -r submit32.cs.utexas.edu:', condorFolderMatFiles, ' ', folderWithResults];


cell2file(scriptFilename, stringCell)


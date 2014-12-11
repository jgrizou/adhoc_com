function generate_rsync_script(scriptFilename, folderWithResults)

computerPath = '/home/jgrizou/Dropbox';
condorPath = '/projects/agents5/grizou';

condorFolderWithResults = strgsub(folderWithResults, computerPath, condorPath);
condorFolderMatFiles = fullfile(condorFolderWithResults, '*');

stringCell = {};
stringCell{end+1} = '#!/bin/bash';
stringCell{end+1} = '';
stringCell{end+1} = ['rsync -avr submit32.cs.utexas.edu:', condorFolderMatFiles, ' ', folderWithResults];


cell2file(scriptFilename, stringCell)


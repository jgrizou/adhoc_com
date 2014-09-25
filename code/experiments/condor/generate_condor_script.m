function generate_condor_script(condorFilename, folderWithJobs)
%GENERATE_CONDOR_SCRIPT

computerPath = '/home/jgrizou/Dropbox';
condorPath = '/projects/agents5/grizou';

runMatlabScriptPath = fullfile(condorPath, 'run_matlab_script.sh');
condorFolderWithJobs = strgsub(folderWithJobs, computerPath, condorPath);

condorJobsFileName = fullfile(condorFolderWithJobs, 'condor_$(Process).m');

waitingJobs = getfilenames(folderWithJobs, 'refiles', '*.m');
queueSize = length(waitingJobs);

stringCell = {};
stringCell{end+1} = '# executable and args';
stringCell{end+1} = 'Executable = /bin/bash';
stringCell{end+1} = ['Arguments = ', runMatlabScriptPath ,' ', condorJobsFileName];
stringCell{end+1} = 'Requirements = Precise && (Arch == "x86_64") ';
stringCell{end+1} = '';
stringCell{end+1} = 'GetEnv = True';
stringCell{end+1} = 'Universe = vanilla';
stringCell{end+1} = '';
stringCell{end+1} = '# output';
stringCell{end+1} = ['Error  = ', fullfile(condorPath , 'output/$(Process).err')];
stringCell{end+1} = ['Output = ', fullfile(condorPath , 'output/$(Process).out')];
stringCell{end+1} = ['Log    = ', fullfile(condorPath , 'output/$(Process).log')];
stringCell{end+1} = '';
stringCell{end+1} = '# CS Specific';
stringCell{end+1} = '+Group = "Grad"';
stringCell{end+1} = '+Project="AI_ROBOTICS"';
stringCell{end+1} = '+ProjectDescription="Research on ad hoc team agents"';
stringCell{end+1} = '';
stringCell{end+1} = ['Queue ', num2str(queueSize)];

cell2file(condorFilename, stringCell)
clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

jobFolder = fullfile(pathstr, 'condor_jobs');
ensure_new_folder(jobFolder)

%%
nJobs = 2000;

for i = 1:nJobs
    
    seedStr = num2str(i-1);
    
    stringCell = {};
    stringCell{end+1} = '[pathstr, ~, ~] = fileparts(mfilename(''fullpath''));';    
    stringCell{end+1} = 'addpath(genpath(fullfile(pathstr, ''..'')));'; 
    stringCell{end+1} = 'init'; 
    stringCell{end+1} = ['run_all_exp(', seedStr, ')'];
    
    filename = fullfile(jobFolder, ['condor_', seedStr, '.m']);
    cell2file(filename, stringCell)
    
end

%%
condorFilename = fullfile(pathstr, 'run.condor');
generate_condor_script(condorFilename, jobFolder)

%%
scriptFilename = fullfile(pathstr, 'copy_condor_results.sh');
resultFolder = fullfile(pathstr, 'results');
generate_rsync_script(scriptFilename, resultFolder)

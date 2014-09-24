clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

%% this deserve function
initFolder = fullfile(pathstr, 'init_jobs');
if ~exist(initFolder, 'dir')
    mkdir(initFolder)
end

jobFolder = fullfile(pathstr, 'wait_jobs');
if ~exist(jobFolder, 'dir')
    mkdir(jobFolder)
end

%%
nJobs = 1;

for i = 1:nJobs
    jobFile = generate_available_filename(jobFolder, '.m', 10);
    fid = fopen(jobFile, 'w');
    
    seed = i;
    rec = init_with_seed(seed);
    
    initFilename = generate_available_filename(initFolder, '.mat', 10);
    rec.save(initFilename)
    
    fprintf(fid, '%% adhoc \n');
    fprintf(fid, ['rec = run_adhoc_exp(''', initFilename, ''');\n']);
    fprintf(fid, 'rec.log_field(''expFolderName'', ''adhoc'')\n');
    fprintf(fid, 'save_rec\n');
    
    fprintf(fid, '\n');
    fprintf(fid, '%% team \n');
    fprintf(fid, ['rec = run_team_exp(''', initFilename, ''');\n']);
    fprintf(fid, 'rec.log_field(''expFolderName'', ''team'')\n');
    fprintf(fid, 'save_rec\n');

    fclose(fid);
end
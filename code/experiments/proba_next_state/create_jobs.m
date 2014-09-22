clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
jobFolder = fullfile(pathstr, 'wait_jobs');

if ~exist(jobFolder, 'dir')
    mkdir(jobFolder)
end

nJobs = 100;

preyTypes = {'escape', 'random'};

for iPreyType = 1:length(preyTypes)
    for i = 1:nJobs
        jobFile = generate_available_filename(jobFolder, '.m', 10);
        fid = fopen(jobFile, 'w');
        
        fprintf(fid, ['seed = ', num2str(i), ';\n']);
        
        fprintf(fid, ['main_', preyTypes{iPreyType} ,'\n']);
        
        str = ['rec.log_field(''expFolderName'', ''', preyTypes{iPreyType}, ''')'];
        fprintf(fid, [str ,'\n']);
        
        fprintf(fid, 'save_rec\n');
        
        fclose(fid);
    end
end

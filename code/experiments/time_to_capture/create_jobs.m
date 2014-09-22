clean
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
jobFolder = fullfile(pathstr, 'wait_jobs');

if ~exist(jobFolder, 'dir')
    mkdir(jobFolder)
end

nJobs = 500;
methods = {'withCom', 'noCom'};

preyTypes = {'escape', 'random'};

for iMethod = 1:length(methods)
    for iPreyType = 1:length(preyTypes)
        for i = 1:nJobs
            jobFile = generate_available_filename(jobFolder, '.m', 10);
            fid = fopen(jobFile, 'w');

            fprintf(fid, ['seed = ', num2str(i), ';\n']);
            
            fprintf(fid, 'start\n');

            methodName = [methods{iMethod}, '_', preyTypes{iPreyType}];
            str = ['rec.log_field(''expFolderName'', ''', methodName, ''')'];
            fprintf(fid, [str ,'\n']);

            fprintf(fid, ['add_predators_', methods{iMethod}, '\n']);
            
            fprintf(fid, ['add_prey_', preyTypes{iPreyType}, '\n']);
            
            fprintf(fid, 'main\n');

            fprintf(fid, 'save_rec\n');
            
            fclose(fid);
        end
    end
end

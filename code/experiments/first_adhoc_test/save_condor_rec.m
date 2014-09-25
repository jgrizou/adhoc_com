function save_condor_rec(rec, methodName)

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
recFolder = fullfile(pathstr, 'results', methodName);
ensure_new_folder(recFolder)

recFilename = fullfile(recFolder, ['condor_', num2str(rec.seed), '.mat']);
rec.save(recFilename)
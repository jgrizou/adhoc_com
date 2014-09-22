
%% saving
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
folder = fullfile(pathstr, 'results', rec.expFolderName);
if ~exist(folder, 'dir')
    mkdir(folder)
end
recFilename = generate_timestamped_filename(folder, 'mat');
rec.save(recFilename)
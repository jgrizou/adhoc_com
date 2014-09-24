init
[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
foldername = fullfile(pathstr, 'first_adhoc_test');
run_jobs_in_folder(foldername, 30)
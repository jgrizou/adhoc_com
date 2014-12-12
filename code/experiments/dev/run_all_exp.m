function run_all_exp(seed)

disp(['Running all settings with seed = ', num2str(seed)])    
disp('#####')
disp(' ')

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));

resultFolder = fullfile(pathstr, 'results');

settingFolder = fullfile(pathstr, 'specific_simuInfo');
settingScripts = getfilenames(settingFolder, 'refiles', '*.m');
for i = 1:length(settingScripts)  
    
    init_simuInfo();
    run(settingScripts{i})
    saveFilename = get_save_filename(resultFolder, simuInfo.settingName, seed);    

    disp(['Running ', simuInfo.settingName, '...'])    
    
    if ~exist(saveFilename, 'file')
        rec = init_hypothesis_with_seed(simuInfo, seed);
        rec = run_simulation(rec, simuInfo);
        save_condor_rec(rec, simuInfo, saveFilename);
    end
    
end

function saveFilename = get_save_filename(resultFolder, settingName, seed)

saveFolder = fullfile(resultFolder, settingName);
ensure_new_folder(saveFolder)
saveFilename = fullfile(saveFolder, ['condor_', num2str(seed), '.mat']);


function caseData = load_case_inputs(caseConfig)
%LOAD_CASE_INPUTS Load and validate case input data from data/.

dataDir = string(caseConfig.dataDir);
if ~isfolder(dataDir)
    error("ProjectName_utils:io:MissingDataDir", "Data directory was not found: %s", dataDir);
end

dataFiles = list_data_files(dataDir);

caseData = struct();
caseData.caseName = string(caseConfig.name);
caseData.status = "scaffold";
caseData.dataDir = dataDir;
caseData.inputFiles = dataFiles;
caseData.files = struct("dataDir", dataDir);
caseData.warnings = strings(0, 1);

if isempty(dataFiles)
    caseData.warnings(end + 1, 1) = "No case-specific input files found beyond placeholders.";
end
end

function dataFiles = list_data_files(dataDir)
entries = dir(dataDir);
names = strings(0, 1);
for k = 1:numel(entries)
    entry = entries(k);
    if entry.isdir || strcmp(entry.name, "README.md")
        continue
    end
    names(end + 1, 1) = string(fullfile(entry.folder, entry.name)); %#ok<AGROW>
end
dataFiles = names;
end

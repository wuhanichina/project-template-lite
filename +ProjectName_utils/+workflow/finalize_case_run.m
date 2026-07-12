function runSummary = finalize_case_run(caseConfig, runState, caseData, proposedResults, ...
        baselineResults, metrics, outputFiles, figureOutputs)
%FINALIZE_CASE_RUN Write the case run manifest and return root-entry summary.

completedAt = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));
runManifest = build_run_manifest(caseConfig, runState, caseData, proposedResults, ...
    baselineResults, metrics, outputFiles, figureOutputs, completedAt);
write_json_atomic(outputFiles.manifestFile, runManifest);

runSummary = ProjectName_utils.workflow.empty_run_summary();
runSummary.caseName = string(caseConfig.name);
runSummary.status = string(runManifest.status);
runSummary.claim = string(caseConfig.claim);
runSummary.evidenceId = string(caseConfig.evidenceId);
runSummary.startedAt = string(runState.startedAt);
runSummary.completedAt = completedAt;
runSummary.resultDir = string(caseConfig.resultDir);
runSummary.figureDir = string(caseConfig.figureDir);
runSummary.summaryFile = string(outputFiles.summaryFile);
runSummary.manifestFile = string(outputFiles.manifestFile);
runSummary.runManifestFile = string(outputFiles.manifestFile);
runSummary.inputStatus = string(caseData.status);
runSummary.proposedStatus = string(proposedResults.status);
runSummary.baselineStatus = string(baselineResults.status);
runSummary.metricsStatus = string(metrics.status);
runSummary.figureStatus = string(figureOutputs.status);
if runSummary.status == "failed"
    runSummary.message = "Workflow finalized with a failed stage status. This run is not paper evidence.";
elseif runSummary.status == "running"
    runSummary.message = "Workflow finalized with a nonterminal stage status. This run is incomplete and is not paper evidence.";
elseif runSummary.status == "scaffold"
    runSummary.message = "Scaffold workflow completed and run_manifest.json was written. Replace package skeletons with project computation before claiming paper evidence.";
else
    runSummary.message = "Workflow completed and run_manifest.json was written. Register the run before using it as paper evidence.";
end
end

function manifest = build_run_manifest(caseConfig, runState, caseData, proposedResults, ...
        baselineResults, metrics, outputFiles, figureOutputs, completedAt)
projectRoot = get_optional_string(caseConfig, "projectRoot", "");
entryFunction = get_optional_string(caseConfig, "entryFunction", string(caseConfig.name));
manifestFile = string(outputFiles.manifestFile);

manifest = struct();
manifest.schemaVersion = "research_template_lite_case_run_manifest_v2";
manifest.contractVersion = get_optional_string(caseConfig, "contractVersion", "2026.07.12");
manifest.generatedAt = completedAt;
manifest.caseName = string(caseConfig.name);
manifest.network = get_optional_string(caseConfig, "network", "");
manifest.description = get_optional_string(caseConfig, "description", "");
manifest.status = resolve_run_status(caseConfig, caseData, proposedResults, baselineResults, metrics, figureOutputs);
manifest.claim = string(caseConfig.claim);
manifest.evidenceId = string(caseConfig.evidenceId);
manifest.lifecycleStage = get_optional_string(caseConfig, "lifecycleStage", "zero-to-one-explore");
manifest.caseContract = get_optional_string(caseConfig, "caseContract", "");
manifest.figurePlanId = get_optional_string(caseConfig, "figurePlanId", "");
manifest.entryFunction = entryFunction;
manifest.command = entryFunction + "()";
manifest.projectRoot = projectRoot;
manifest.git = inspect_git(projectRoot);
manifest.environment = inspect_environment();
manifest.solverVisibility = inspect_solver_visibility(caseConfig);
manifest.config = caseConfig;
manifest.reproducibilityBoundary = struct( ...
    "dataPolicy", "Formal case runs must be able to start from code plus data/ after existing cache files are removed.", ...
    "cachePolicy", "cache/ stores derived intermediate artifacts and must not be a mandatory startup input.", ...
    "resultPolicy", "result/ stores outputs, logs, tables, figures, and this run manifest.");
manifest.timing = struct( ...
    "startedAt", string(runState.startedAt), ...
    "completedAt", completedAt);
manifest.randomState = struct( ...
    "seed", runState.rngSeed, ...
    "rngType", string(runState.rngType));
manifest.inputs = struct();
manifest.inputs.status = string(caseData.status);
manifest.inputs.dataDir = string(caseConfig.dataDir);
manifest.inputs.inputFiles = get_optional_strings(caseData, "inputFiles");
manifest.inputs.inputFileRecords = get_optional_value( ...
    caseData, "inputFileRecords", empty_input_file_records());
manifest.inputs.dataVersionFingerprint = get_optional_string( ...
    caseData, "dataVersionFingerprint", "");
manifest.inputs.dataVersion = get_optional_value( ...
    caseData, "dataVersion", empty_data_version());
manifest.inputs.warnings = get_optional_strings(caseData, "warnings");
manifest.cache = struct( ...
    "cacheDir", string(caseConfig.cacheDir), ...
    "snapshot", snapshot_directory(caseConfig.cacheDir));
manifest.outputs = struct( ...
    "resultDir", string(caseConfig.resultDir), ...
    "summaryFile", string(outputFiles.summaryFile), ...
    "runManifestFile", manifestFile, ...
    "files", [get_optional_strings(outputFiles, "files"); manifestFile], ...
    "warnings", get_optional_strings(outputFiles, "warnings"));
manifest.figures = struct( ...
    "status", string(figureOutputs.status), ...
    "figureDir", string(caseConfig.figureDir), ...
    "files", get_optional_strings(figureOutputs, "files"), ...
    "figureManifestFile", string(fullfile(caseConfig.figureDir, "figure_manifest.jsonl")), ...
    "figureCheckReportFile", string(fullfile(caseConfig.figureDir, "figure_check_report.md")), ...
    "warnings", get_optional_strings(figureOutputs, "warnings"));
manifest.stages = struct( ...
    "inputStatus", string(caseData.status), ...
    "proposedStatus", string(proposedResults.status), ...
    "baselineStatus", string(baselineResults.status), ...
    "metricsStatus", string(metrics.status), ...
    "figureStatus", string(figureOutputs.status));
manifest.stageArtifacts = struct( ...
    "caseDataFiles", get_optional_strings(caseData, "inputFiles"), ...
    "proposedFiles", collect_file_list(proposedResults), ...
    "baselineFiles", collect_file_list(baselineResults), ...
    "metricFiles", collect_file_list(metrics), ...
    "figureFiles", get_optional_strings(figureOutputs, "files"));
manifest.stageWarnings = struct( ...
    "runState", get_optional_strings(runState, "warnings"), ...
    "caseData", get_optional_strings(caseData, "warnings"), ...
    "proposed", get_optional_strings(proposedResults, "warnings"), ...
    "baseline", get_optional_strings(baselineResults, "warnings"), ...
    "metrics", get_optional_strings(metrics, "warnings"), ...
    "figures", get_optional_strings(figureOutputs, "warnings"), ...
    "outputs", get_optional_strings(outputFiles, "warnings"));
manifest.evidenceRegistration = struct( ...
    "evidenceMap", "01_IDEA/evidence_map.md", ...
    "requiredBeforePaperUse", true, ...
    "message", "Register this run, its result files, and its formal figures in 01_IDEA/evidence_map.md before using them as paper evidence.");
end

function status = resolve_run_status(caseConfig, caseData, proposedResults, baselineResults, metrics, figureOutputs)
stageStatuses = [
    string(caseData.status)
    string(proposedResults.status)
    string(baselineResults.status)
    string(metrics.status)
    string(figureOutputs.status)
];
if any(stageStatuses == "failed")
    status = "failed";
elseif any(stageStatuses == "running")
    status = "running";
elseif all(stageStatuses == "scaffold")
    status = "scaffold";
elseif isfield(caseConfig, "workflowStatus") && string(caseConfig.workflowStatus) ~= "scaffold"
    status = string(caseConfig.workflowStatus);
else
    status = "completed";
end
end

function value = get_optional_string(source, fieldName, defaultValue)
fieldName = char(fieldName);
if isfield(source, fieldName)
    value = string(source.(fieldName));
else
    value = string(defaultValue);
end
end

function values = get_optional_strings(source, fieldName)
fieldName = char(fieldName);
if isfield(source, fieldName)
    values = string(source.(fieldName));
    values = values(:);
else
    values = strings(0, 1);
end
end

function value = get_optional_value(source, fieldName, defaultValue)
fieldName = char(fieldName);
if isfield(source, fieldName)
    value = source.(fieldName);
else
    value = defaultValue;
end
end

function records = empty_input_file_records()
records = repmat(struct( ...
    "relativePath", "", ...
    "absolutePath", "", ...
    "bytes", 0, ...
    "mtime", "", ...
    "mtimeDatenum", 0, ...
    "sha256", ""), 0, 1);
end

function dataVersion = empty_data_version()
dataVersion = struct( ...
    "algorithm", "SHA-256", ...
    "fingerprint", "", ...
    "fileCount", 0, ...
    "byteCount", 0, ...
    "basis", "");
end

function files = collect_file_list(source)
files = strings(0, 1);
if ~isfield(source, "files")
    return
end

rawFiles = source.files;
if isstruct(rawFiles)
    fields = fieldnames(rawFiles);
    for k = 1:numel(fields)
        value = rawFiles.(fields{k});
        if ischar(value)
            files = [files; string(value)]; %#ok<AGROW>
        elseif isstring(value)
            files = [files; string(value(:))]; %#ok<AGROW>
        end
    end
elseif ischar(rawFiles)
    files = string(rawFiles);
elseif isstring(rawFiles)
    files = string(rawFiles(:));
end
files = files(strlength(files) > 0);
end

function info = inspect_environment()
info = struct();
info.matlabVersion = string(version);
info.matlabRelease = string(version('-release'));
info.computer = string(computer);
info.arch = string(computer('arch'));
info.ispc = ispc;
info.ismac = ismac;
info.isunix = isunix;
info.useJvm = usejava("jvm");
info.useDesktop = usejava("desktop");
end

function info = inspect_solver_visibility(caseConfig)
info = struct();
if isfield(caseConfig, "optimizerPriority")
    info.optimizerPriority = string(caseConfig.optimizerPriority);
else
    info.optimizerPriority = strings(0, 1);
end
info.cvxBegin = inspect_function_visibility("cvx_begin");
info.mosekopt = inspect_function_visibility("mosekopt");
info.gurobi = inspect_function_visibility("gurobi");
end

function info = inspect_function_visibility(functionName)
functionName = char(functionName);
existCode = exist(functionName, "file");
info = struct();
info.name = string(functionName);
info.available = existCode == 2 || existCode == 3 || existCode == 6;
info.existCode = existCode;
info.path = string(which(functionName));
end

function info = inspect_git(projectRoot)
info = struct();
info.available = false;
info.isRepository = false;
info.branch = "";
info.commit = "";
info.statusShort = "";

if strlength(projectRoot) == 0 || ~isfolder(projectRoot)
    return
end

[ok, commitText] = run_git(projectRoot, "rev-parse HEAD");
if ~ok
    return
end

info.available = true;
info.isRepository = true;
info.commit = commitText;
[~, branchText] = run_git(projectRoot, "branch --show-current");
info.branch = branchText;
[~, statusText] = run_git(projectRoot, "status --short");
info.statusShort = statusText;
end

function [ok, text] = run_git(projectRoot, args)
currentDir = pwd;
cleanupObj = onCleanup(@() cd(currentDir));
cd(char(projectRoot));

command = sprintf("git %s", args);
[statusCode, commandOutput] = system(char(command));
ok = statusCode == 0;
text = string(regexprep(commandOutput, '[\r\n]+$', ''));
end

function snapshot = snapshot_directory(dirPath)
snapshot = struct();
snapshot.path = string(dirPath);
snapshot.exists = isfolder(dirPath);
snapshot.fileCount = 0;
snapshot.byteCount = 0;
snapshot.capturedAt = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));

if ~snapshot.exists
    return
end

[fileCount, byteCount] = count_files(dirPath);
snapshot.fileCount = fileCount;
snapshot.byteCount = byteCount;
end

function [fileCount, byteCount] = count_files(dirPath)
fileCount = 0;
byteCount = 0;
entries = dir(dirPath);
for k = 1:numel(entries)
    entry = entries(k);
    if strcmp(entry.name, ".") || strcmp(entry.name, "..")
        continue
    end
    fullPath = fullfile(entry.folder, entry.name);
    if entry.isdir
        [childCount, childBytes] = count_files(fullPath);
        fileCount = fileCount + childCount;
        byteCount = byteCount + childBytes;
    else
        fileCount = fileCount + 1;
        byteCount = byteCount + entry.bytes;
    end
end
end

function write_json_atomic(filePath, value)
filePath = string(filePath);
if isfolder(filePath)
    error("ProjectName_utils:workflow:ManifestPathIsDirectory", ...
        "The run manifest target is an existing directory: %s", filePath);
end
[parentDir, ~, ~] = fileparts(filePath);
ProjectName_utils.io.ensure_dir(parentDir);

temporaryFile = string(tempname(parentDir)) + ".json.tmp";
temporaryCleanup = onCleanup(@() delete_if_exists(temporaryFile));

fid = fopen(temporaryFile, "w", "n", "UTF-8");
if fid < 0
    error("ProjectName_utils:workflow:OpenFailed", ...
        "Could not open temporary JSON file for manifest: %s", temporaryFile);
end

cleanupObj = onCleanup(@() close_if_open(fid));
fprintf(fid, "%s\n", jsonencode(value));
fclose(fid);
clear cleanupObj

[moveOk, moveMessage] = movefile(temporaryFile, filePath, "f");
if ~moveOk
    error("ProjectName_utils:workflow:ManifestMoveFailed", ...
        "Could not replace run manifest %s: %s", filePath, moveMessage);
end
clear temporaryCleanup
end

function close_if_open(fid)
if ~isempty(fopen(fid))
    fclose(fid);
end
end

function delete_if_exists(filePath)
if isfile(filePath)
    delete(filePath);
end
end

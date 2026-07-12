function manifestFile = finalize_failed_case_run(caseConfig, failedStage, runError, runContext)
%FINALIZE_FAILED_CASE_RUN Persist failure context before the case rethrows.

if nargin < 4
    runContext = struct();
end

failedAt = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));
projectRoot = get_optional_string(caseConfig, "projectRoot", "");
resultDir = get_optional_string(caseConfig, "resultDir", ...
    fullfile(projectRoot, "result", get_optional_string(caseConfig, "name", "unknown_case")));
figureDir = get_optional_string(caseConfig, "figureDir", fullfile(resultDir, "figures"));
manifestFile = string(fullfile(resultDir, "run_manifest.json"));

runState = get_context_struct(runContext, "runState");
caseData = get_context_struct(runContext, "caseData");
proposedResults = get_context_struct(runContext, "proposedResults");
baselineResults = get_context_struct(runContext, "baselineResults");
metrics = get_context_struct(runContext, "metrics");
outputFiles = get_context_struct(runContext, "outputFiles");
figureOutputs = get_context_struct(runContext, "figureOutputs");

manifest = struct();
manifest.schemaVersion = "research_template_lite_case_run_manifest_v1";
manifest.generatedAt = failedAt;
manifest.caseName = get_optional_string(caseConfig, "name", "");
manifest.network = get_optional_string(caseConfig, "network", "");
manifest.description = get_optional_string(caseConfig, "description", "");
manifest.status = "failed";
manifest.claim = get_optional_string(caseConfig, "claim", "");
manifest.evidenceId = get_optional_string(caseConfig, "evidenceId", "");
manifest.entryFunction = get_optional_string(caseConfig, "entryFunction", manifest.caseName);
manifest.command = manifest.entryFunction + "()";
manifest.projectRoot = projectRoot;
manifest.failedStage = normalize_failed_stage(failedStage);
manifest.failure = build_failure(runError, manifest.failedStage);
manifest.git = inspect_git(projectRoot);
manifest.environment = inspect_environment();
manifest.solverVisibility = inspect_solver_visibility(caseConfig);
manifest.config = sanitize_for_json(caseConfig);
manifest.reproducibilityBoundary = struct( ...
    "dataPolicy", "Formal case runs must be able to start from code plus data/ after existing cache files are removed.", ...
    "cachePolicy", "cache/ stores derived intermediate artifacts and must not be a mandatory startup input.", ...
    "resultPolicy", "result/ stores outputs, logs, tables, figures, and this run manifest.");
manifest.timing = struct( ...
    "invokedAt", get_optional_string(runContext, "invokedAt", ""), ...
    "startedAt", get_optional_string(runState, "startedAt", ""), ...
    "failedAt", failedAt);
manifest.randomState = struct( ...
    "seed", get_optional_value(runState, "rngSeed", get_optional_value(caseConfig, "seed", [])), ...
    "rngType", get_optional_string(runState, "rngType", ""));

dataDir = get_optional_string(caseConfig, "dataDir", fullfile(projectRoot, "data"));
manifest.inputs = struct();
manifest.inputs.status = known_stage_status(caseData, manifest.failedStage.index, 3);
manifest.inputs.dataDir = dataDir;
manifest.inputs.dataDirExists = isfolder(dataDir);
manifest.inputs.inputFiles = get_optional_strings(caseData, "inputFiles");
manifest.inputs.inputFileRecords = sanitize_for_json(get_optional_value( ...
    caseData, "inputFileRecords", empty_input_file_records()));
manifest.inputs.dataVersionFingerprint = get_optional_string( ...
    caseData, "dataVersionFingerprint", "");
manifest.inputs.dataVersion = sanitize_for_json(get_optional_value( ...
    caseData, "dataVersion", empty_data_version()));
manifest.inputs.directorySnapshot = snapshot_directory(dataDir);
manifest.inputs.warnings = get_optional_strings(caseData, "warnings");

cacheDir = get_optional_string(caseConfig, "cacheDir", fullfile(projectRoot, "cache", manifest.caseName));
manifest.cache = struct( ...
    "cacheDir", cacheDir, ...
    "snapshot", snapshot_directory(cacheDir));

defaultSummaryFile = string(fullfile(resultDir, "summary.txt"));
manifest.outputs = struct();
manifest.outputs.status = known_stage_status(outputFiles, manifest.failedStage.index, 7);
manifest.outputs.resultDir = resultDir;
manifest.outputs.summaryFile = get_optional_string(outputFiles, "summaryFile", defaultSummaryFile);
manifest.outputs.runManifestFile = manifestFile;
manifest.outputs.files = collect_file_list(outputFiles);
manifest.outputs.directorySnapshot = snapshot_directory(resultDir);
manifest.outputs.warnings = get_optional_strings(outputFiles, "warnings");

manifest.figures = struct();
manifest.figures.status = known_stage_status(figureOutputs, manifest.failedStage.index, 8);
manifest.figures.figureDir = figureDir;
manifest.figures.files = get_optional_strings(figureOutputs, "files");
manifest.figures.figureManifestFile = string(fullfile(figureDir, "figure_manifest.jsonl"));
manifest.figures.figureCheckReportFile = string(fullfile(figureDir, "figure_check_report.md"));
manifest.figures.directorySnapshot = snapshot_directory(figureDir);
manifest.figures.warnings = get_optional_strings(figureOutputs, "warnings");

manifest.stages = struct( ...
    "inputStatus", known_stage_status(caseData, manifest.failedStage.index, 3), ...
    "proposedStatus", known_stage_status(proposedResults, manifest.failedStage.index, 4), ...
    "baselineStatus", known_stage_status(baselineResults, manifest.failedStage.index, 5), ...
    "metricsStatus", known_stage_status(metrics, manifest.failedStage.index, 6), ...
    "outputStatus", known_stage_status(outputFiles, manifest.failedStage.index, 7), ...
    "figureStatus", known_stage_status(figureOutputs, manifest.failedStage.index, 8), ...
    "finalizationStatus", known_stage_status(struct(), manifest.failedStage.index, 9));
manifest.stageExecution = build_stage_execution(manifest.failedStage.index);
manifest.stageArtifacts = struct( ...
    "caseDataFiles", get_optional_strings(caseData, "inputFiles"), ...
    "proposedFiles", collect_file_list(proposedResults), ...
    "baselineFiles", collect_file_list(baselineResults), ...
    "metricFiles", collect_file_list(metrics), ...
    "outputFiles", collect_file_list(outputFiles), ...
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
    "message", "A failed run is diagnostic provenance and must not be registered as paper evidence.");

write_json_atomic(manifestFile, manifest);
end

function failedStage = normalize_failed_stage(source)
failedStage = struct();
failedStage.index = double(get_optional_value(source, "index", 0));
failedStage.name = get_optional_string(source, "name", "workflow initialization");
failedStage.status = "failed";
end

function failure = build_failure(runError, failedStage)
failure = struct();
failure.failedStage = failedStage;
failure.identifier = string(runError.identifier);
failure.message = string(runError.message);
failure.stack = exception_stack(runError);
failure.causes = exception_causes(runError);
end

function stack = exception_stack(runError)
stack = repmat(struct("file", "", "name", "", "line", 0), numel(runError.stack), 1);
for k = 1:numel(runError.stack)
    stack(k) = struct( ...
        "file", string(runError.stack(k).file), ...
        "name", string(runError.stack(k).name), ...
        "line", runError.stack(k).line);
end
end

function causes = exception_causes(runError)
causes = repmat(struct("identifier", "", "message", ""), numel(runError.cause), 1);
for k = 1:numel(runError.cause)
    causes(k) = struct( ...
        "identifier", string(runError.cause{k}.identifier), ...
        "message", string(runError.cause{k}.message));
end
end

function stages = build_stage_execution(failedIndex)
stageNames = [
    "Define case configuration"
    "Prepare directories, seed, and run state"
    "Load and validate data inputs"
    "Run the proposed method"
    "Run SOTA or baseline methods"
    "Evaluate case metrics"
    "Write tables and summary"
    "Export formal case figures"
    "Finalize run and write manifest"
];
stages = repmat(struct("index", 0, "name", "", "status", "not_started"), numel(stageNames), 1);
for k = 1:numel(stageNames)
    stages(k).index = k;
    stages(k).name = stageNames(k);
    if k < failedIndex
        stages(k).status = "completed";
    elseif k == failedIndex
        stages(k).status = "failed";
    end
end
end

function status = known_stage_status(source, failedIndex, stageIndex)
if isfield(source, "status")
    status = string(source.status);
elseif failedIndex == stageIndex
    status = "failed";
elseif failedIndex > stageIndex
    status = "completed";
else
    status = "not_started";
end
end

function source = get_context_struct(context, fieldName)
fieldName = char(fieldName);
if isfield(context, fieldName) && isstruct(context.(fieldName))
    source = context.(fieldName);
else
    source = struct();
end
end

function value = get_optional_string(source, fieldName, defaultValue)
fieldName = char(fieldName);
if isstruct(source) && isfield(source, fieldName)
    value = string(source.(fieldName));
else
    value = string(defaultValue);
end
end

function values = get_optional_strings(source, fieldName)
fieldName = char(fieldName);
if isstruct(source) && isfield(source, fieldName)
    values = string(source.(fieldName));
    values = values(:);
else
    values = strings(0, 1);
end
end

function value = get_optional_value(source, fieldName, defaultValue)
fieldName = char(fieldName);
if isstruct(source) && isfield(source, fieldName)
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
if ~isstruct(source) || ~isfield(source, "files")
    return
end

rawFiles = source.files;
if isstruct(rawFiles)
    fields = fieldnames(rawFiles);
    for k = 1:numel(fields)
        value = rawFiles.(fields{k});
        if ischar(value) || isstring(value)
            files = [files; string(value(:))]; %#ok<AGROW>
        end
    end
elseif ischar(rawFiles) || isstring(rawFiles)
    files = string(rawFiles(:));
end
files = files(strlength(files) > 0);
end

function info = inspect_environment()
info = struct();
info.matlabVersion = string(version);
info.matlabRelease = string(version("-release"));
info.computer = string(computer);
info.arch = string(computer("arch"));
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

[snapshot.fileCount, snapshot.byteCount] = count_files(dirPath);
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

function safeValue = sanitize_for_json(value)
if isstruct(value)
    safeValue = value;
    fields = fieldnames(value);
    for index = 1:numel(value)
        for fieldIndex = 1:numel(fields)
            fieldName = fields{fieldIndex};
            safeValue(index).(fieldName) = sanitize_for_json(value(index).(fieldName));
        end
    end
elseif iscell(value)
    safeValue = cell(size(value));
    for index = 1:numel(value)
        safeValue{index} = sanitize_for_json(value{index});
    end
elseif isa(value, "function_handle")
    safeValue = string(func2str(value));
elseif isdatetime(value) || isduration(value) || iscategorical(value)
    safeValue = string(value);
elseif ischar(value) || isstring(value) || isnumeric(value) || islogical(value)
    safeValue = value;
else
    try
        safeValue = string(value);
    catch
        safeValue = "<" + string(class(value)) + ">";
    end
end
end

function write_json_atomic(filePath, value)
filePath = string(filePath);
if isfolder(filePath)
    error("ProjectName_utils:workflow:FailureManifestPathIsDirectory", ...
        "The failed-run manifest target is an existing directory: %s", filePath);
end
[parentDir, ~, ~] = fileparts(filePath);
ProjectName_utils.io.ensure_dir(parentDir);

temporaryFile = string(tempname(parentDir)) + ".json.tmp";
temporaryCleanup = onCleanup(@() delete_if_exists(temporaryFile));

fid = fopen(temporaryFile, "w", "n", "UTF-8");
if fid < 0
    error("ProjectName_utils:workflow:FailureManifestOpenFailed", ...
        "Could not open temporary failure manifest: %s", temporaryFile);
end
fileCleanup = onCleanup(@() close_if_open(fid));
fprintf(fid, "%s\n", jsonencode(sanitize_for_json(value)));
fclose(fid);
clear fileCleanup

[moveOk, moveMessage] = movefile(temporaryFile, filePath, "f");
if ~moveOk
    error("ProjectName_utils:workflow:FailureManifestMoveFailed", ...
        "Could not replace failure run manifest %s: %s", filePath, moveMessage);
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

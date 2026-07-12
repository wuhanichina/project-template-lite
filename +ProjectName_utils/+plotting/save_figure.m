function outputs = save_figure(figHandle, outDirOrBase, figName, options)
%SAVE_FIGURE Export a paper-facing MATLAB figure bundle.
%
% Formal figures should live under result/<case>/figures and must be exported
% from MATLAB, not from screenshots or external plotting tools.
%
% Example:
%   fig = ProjectName_utils.plotting.create_figure("single-column");
%   ax = axes(fig);
%   ProjectName_utils.plotting.plot_method_line(ax, x, y, "baseline");
%   meta = struct( ...
%       "figNo", "Fig01", ...
%       "contractVersion", "2026.07.12", ...
%       "figurePlanId", "FP-C1", ...
%       "claimId", "C1", ...
%       "sciQuestion", "What engineering question does this figure answer?", ...
%       "physicsReproduction", "Which actual or reference physical behavior does this case-study result reproduce?", ...
%       "evidenceRole", "physical-reproduction", ...
%       "dataFiles", "result/case33bw/results.mat", ...
%       "dataDescription", "Fields, units, dimensions, and preprocessing status.", ...
%       "visualEncoding", ProjectName_utils.plotting.methodStyle(), ...
%       "targetLayout", "single-column", ...
%       "command", "ProjectName_case33bw", ...
%       "keyParams", struct("case", "case33bw"), ...
%       "randomSeed", 33);
%   ProjectName_utils.plotting.save_figure(fig, caseConfig.figureDir, ...
%       "Fig01_case33bw_main", "Metadata", meta, "PlotData", plotTable);

arguments
    figHandle = []
    outDirOrBase = ""
    figName = ""
    options.Metadata struct = struct()
    options.PlotData = []
    options.Script = ""
    options.Command = ""
    options.IsDiagnostic (1,1) logical = false
    options.AllowSotaBeforePhysical (1,1) logical = false
    options.OverrideReason (1,1) string = ""
    options.ManifestFile = ""
    options.CheckReportFile = ""
    options.CloseFigure (1,1) logical = true
    options.ExtraFormats string = strings(1, 0)
    options.FigureProfile (1,1) string = "ieee"
    options.ApplyProfileSize (1,1) logical = true
    options.FontSizePt (1,1) double = NaN
    options.UseProfileExtraFormats (1,1) logical = true
    options.LockTimeoutSeconds (1,1) double {mustBePositive} = 30
    options.StaleLockSeconds (1,1) double {mustBePositive} = 3600
    options.TestCommitFailureAfter (1,1) double = Inf
end

if isempty(figHandle)
    figHandle = gcf;
end
figureCleanup = onCleanup(@() close_figure_if_requested(figHandle, options.CloseFigure));
if strlength(string(outDirOrBase)) == 0
    error("ProjectName_utils:plotting:MissingOutput", ...
        "Output directory or base file path is required.");
end

[outDir, figName] = resolve_output_target(outDirOrBase, figName);

targetLayout = metadata_target_layout(options.Metadata);
[fontName, profile] = ProjectName_utils.plotting.apply_figure_profile(figHandle, ...
    "Profile", options.FigureProfile, ...
    "TargetLayout", targetLayout, ...
    "ApplySize", options.ApplyProfileSize, ...
    "FontSizePt", options.FontSizePt);
enforce_single_formal_axes(figHandle, options.IsDiagnostic);
drawnow;

dpi = profile.previewDpi;
if options.IsDiagnostic
    dpi = profile.diagnosticDpi;
end
extraFormats = resolve_extra_formats(options.ExtraFormats, profile, options.UseProfileExtraFormats);
validate_extra_formats(extraFormats);

outputs = build_output_paths(outDir, figName, options.PlotData, extraFormats, ...
    resolve_optional_path(options.ManifestFile, outDir, "figure_manifest.jsonl"), ...
    resolve_optional_path(options.CheckReportFile, outDir, "figure_check_report.md"));
validate_unique_output_paths(outputs);
validate_output_target_types(outputs);
validate_transaction_options(options.TestCommitFailureAfter);
obsoletePaths = obsolete_optional_paths(outputs);

manifest = build_manifest(figHandle, figName, fontName, profile, options, outputs);
[locks, transactionId] = acquire_export_locks(outputs, ...
    options.LockTimeoutSeconds, options.StaleLockSeconds);
lockCleanup = onCleanup(@() release_export_locks(locks));
[narrativeOk, overrideUsed] = enforce_evidence_narrative( ...
    outputs.manifestFile, manifest, options.AllowSotaBeforePhysical);
manifest.evidenceNarrativeOrdered = narrativeOk;
manifest.narrativeOverrideUsed = overrideUsed;
manifest = orderfields(manifest);

stageRoot = create_staging_directory(outputs.outDir, transactionId);
stageArtifactDir = fullfile(stageRoot, "artifacts");
ProjectName_utils.io.ensure_dir(stageArtifactDir);
stagedOutputs = build_output_paths(stageArtifactDir, figName, options.PlotData, ...
    extraFormats, transaction_sibling_path(outputs.manifestFile, "stage", transactionId), ...
    transaction_sibling_path(outputs.checkReportFile, "stage", transactionId));
stageCleanup = onCleanup(@() cleanup_staged_bundle(stagedOutputs, stageRoot));

export_figure_bundle(figHandle, stagedOutputs, options.PlotData, extraFormats, dpi);
refresh_export_locks(locks);
checks = run_quality_checks(stagedOutputs, manifest, narrativeOk);
stage_metadata_files(outputs, stagedOutputs, manifest, figName, checks);
refresh_export_locks(locks);
commit_staged_bundle(stagedOutputs, outputs, obsoletePaths, transactionId, ...
    options.TestCommitFailureAfter);

outputs.checks = checks;
cleanup_staged_bundle(stagedOutputs, stageRoot);
clear stageCleanup lockCleanup figureCleanup
end

function [outDir, figName] = resolve_output_target(outDirOrBase, figName)
outDirOrBase = string(outDirOrBase);
figName = string(figName);

if strlength(figName) == 0
    if exist(char(outDirOrBase), "dir") == 7
        error("ProjectName_utils:plotting:MissingFigureName", ...
            "Figure name is required when the output target is a directory.");
    end
    [parentDir, baseName, ~] = fileparts(outDirOrBase);
    if strlength(baseName) == 0
        error("ProjectName_utils:plotting:MissingFigureName", ...
            "Figure name is required when the output target is a directory.");
    end
    if strlength(parentDir) == 0
        parentDir = string(pwd);
    end
    outDir = parentDir;
    figName = baseName;
else
    outDir = outDirOrBase;
end

figName = regexprep(figName, '[<>:"/\\|?*]', "_");
figName = regexprep(figName, "\s+", "_");
if strlength(figName) == 0
    error("ProjectName_utils:plotting:InvalidFigureName", ...
        "Figure name must contain at least one valid MATLAB name character.");
end
end

function filePath = resolve_optional_path(userPath, outDir, defaultName)
userPath = string(userPath);
if strlength(userPath) == 0
    filePath = fullfile(outDir, defaultName);
else
    filePath = userPath;
end
end

function outputs = build_output_paths(outDir, figName, plotData, extraFormats, ...
        manifestFile, checkReportFile)
outputs = struct();
outputs.outDir = string(outDir);
outputs.figName = string(figName);
outputs.figFile = fullfile(outDir, figName + ".fig");
outputs.pngFile = fullfile(outDir, figName + ".png");
outputs.svgFile = fullfile(outDir, figName + ".svg");
outputs.plotDataFile = "";
if ~isempty(plotData)
    outputs.plotDataFile = fullfile(outDir, figName + "_plot_data.csv");
end
outputs.manifestFile = string(manifestFile);
outputs.checkReportFile = string(checkReportFile);
outputs.extraFiles = extra_format_paths(outDir, figName, extraFormats);
end

function paths = extra_format_paths(outDir, figName, extraFormats)
paths = strings(1, 0);
for k = 1:numel(extraFormats)
    switch lower(string(extraFormats(k)))
        case "pdf"
            extension = ".pdf";
        case "eps"
            extension = ".eps";
        case {"tif", "tiff"}
            extension = ".tiff";
        otherwise
            extension = "." + lower(string(extraFormats(k)));
    end
    paths(end + 1) = fullfile(outDir, figName + extension); %#ok<AGROW>
end
end

function enforce_single_formal_axes(figHandle, isDiagnostic)
if isDiagnostic
    return
end

axesList = findall(figHandle, "Type", "axes");
mainAxesCount = 0;
for k = 1:numel(axesList)
    tag = string(get(axesList(k), "Tag"));
    if any(tag == ["legend", "Colorbar"])
        continue
    end
    mainAxesCount = mainAxesCount + 1;
end

if mainAxesCount > 1
    error("ProjectName_utils:plotting:CompositeFormalFigure", ...
        "Formal figures must be exported as independent subfigures, not subplot/tiledlayout-style composites.");
end
end

function targetLayout = metadata_target_layout(metadata)
targetLayout = "";
if isfield(metadata, "targetLayout")
    targetLayout = string(metadata.targetLayout);
end
end

function extraFormats = resolve_extra_formats(extraFormats, profile, useProfileExtraFormats)
extraFormats = string(extraFormats);
if isempty(extraFormats) && useProfileExtraFormats
    extraFormats = string(profile.defaultExtraFormats);
end
extraFormats = unique(lower(extraFormats), "stable");
extraFormats(extraFormats == "") = [];
end

function validate_extra_formats(extraFormats)
supported = ["pdf", "eps", "tif", "tiff"];
unsupported = extraFormats(~ismember(lower(extraFormats), supported));
if ~isempty(unsupported)
    error("ProjectName_utils:plotting:UnsupportedFormat", ...
        "Unsupported extra figure format: %s", strjoin(unsupported, ", "));
end
end

function validate_unique_output_paths(outputs)
paths = bundle_paths(outputs);
normalized = strings(size(paths));
for k = 1:numel(paths)
    normalized(k) = canonical_comparison_path(paths(k));
end
if numel(unique(normalized)) ~= numel(normalized)
    error("ProjectName_utils:plotting:OutputPathCollision", ...
        "Figure artifacts, manifest, and check report must use distinct output paths.");
end
end

function validate_output_target_types(outputs)
paths = bundle_paths(outputs);
for k = 1:numel(paths)
    if exist(char(paths(k)), "dir") == 7
        error("ProjectName_utils:plotting:OutputTargetIsDirectory", ...
            "Figure output target is an existing directory, not a file path: %s", paths(k));
    end
end
end

function validate_transaction_options(testCommitFailureAfter)
isValidInteger = isfinite(testCommitFailureAfter) && ...
    testCommitFailureAfter >= 0 && fix(testCommitFailureAfter) == testCommitFailureAfter;
if ~(isValidInteger || (isinf(testCommitFailureAfter) && testCommitFailureAfter > 0))
    error("ProjectName_utils:plotting:InvalidCommitFailurePoint", ...
        "TestCommitFailureAfter must be a nonnegative integer or positive Inf.");
end
end

function paths = obsolete_optional_paths(outputs)
candidates = [ ...
    fullfile(outputs.outDir, outputs.figName + "_plot_data.csv"), ...
    fullfile(outputs.outDir, outputs.figName + ".pdf"), ...
    fullfile(outputs.outDir, outputs.figName + ".eps"), ...
    fullfile(outputs.outDir, outputs.figName + ".tiff")];
desired = bundle_paths(outputs);
desiredCanonical = strings(size(desired));
for k = 1:numel(desired)
    desiredCanonical(k) = canonical_comparison_path(desired(k));
end
paths = strings(1, 0);
for k = 1:numel(candidates)
    candidateCanonical = canonical_comparison_path(candidates(k));
    if ~ismember(candidateCanonical, desiredCanonical)
        paths(end + 1) = candidates(k); %#ok<AGROW>
    end
end
end

function canonicalPath = canonical_output_path(filePath)
if ~usejava("jvm")
    error("ProjectName_utils:plotting:PathCanonicalizationUnavailable", ...
        "Safe figure export requires the MATLAB JVM to canonicalize output paths before writing files.");
end
try
    fileObject = javaObject("java.io.File", char(string(filePath)));
    canonicalPath = string(char(fileObject.getCanonicalPath()));
catch cause
    error("ProjectName_utils:plotting:PathCanonicalizationFailed", ...
        "Could not canonicalize figure output path %s: %s", filePath, cause.message);
end
canonicalPath = replace(canonicalPath, "\", "/");
end

function canonicalPath = canonical_comparison_path(filePath)
canonicalPath = canonical_output_path(filePath);
if ispc || ismac
    canonicalPath = lower(canonicalPath);
end
end

function [locks, transactionId] = acquire_export_locks(outputs, timeoutSeconds, staleSeconds)
transactionId = create_transaction_id();
targets = [string(outputs.figFile), string(outputs.manifestFile), ...
    string(outputs.checkReportFile)];
lockPaths = strings(size(targets));
sortKeys = strings(size(targets));
for k = 1:numel(targets)
    canonicalTarget = canonical_output_path(targets(k));
    lockPaths(k) = canonicalTarget + ".ProjectName-lock";
    sortKeys(k) = canonical_comparison_path(lockPaths(k));
end
[~, uniqueIndices] = unique(sortKeys, "stable");
lockPaths = lockPaths(uniqueIndices);
sortKeys = sortKeys(uniqueIndices);
[~, order] = sort(sortKeys);
lockPaths = lockPaths(order);

locks = struct("path", {}, "token", {});
started = tic;
try
    for k = 1:numel(lockPaths)
        lockPath = lockPaths(k);
        ensure_parent_directory(lockPath);
        while true
            if exist(char(lockPath), "file") == 2
                error("ProjectName_utils:plotting:LockPathConflict", ...
                    "Figure lock path is an existing file: %s", lockPath);
            end

            lockObject = javaObject('java.io.File', char(lockPath));
            acquired = logical(lockObject.mkdir());
            if acquired
                try
                    write_lock_owner(lockPath, transactionId, current_lock_timestamp());
                catch cause
                    try
                        rmdir(char(lockPath), "s");
                    catch
                    end
                    rethrow(cause)
                end
                locks(end + 1) = struct( ...
                    "path", lockPath, "token", transactionId); %#ok<AGROW>
                break
            end

            if try_recover_stale_lock(lockPath, staleSeconds)
                continue
            end
            if toc(started) >= timeoutSeconds
                error("ProjectName_utils:plotting:LockTimeout", ...
                    "Timed out after %.3g seconds waiting for figure lock %s.", ...
                    timeoutSeconds, lockPath);
            end
            pause(0.05);
        end
    end
catch cause
    release_export_locks(locks);
    rethrow(cause)
end
end

function transactionId = create_transaction_id()
if ~usejava('jvm')
    error("ProjectName_utils:plotting:TransactionIdUnavailable", ...
        "Figure transactions require the MATLAB JVM.");
end
transactionId = string(char(javaMethod('randomUUID', 'java.util.UUID')));
end

function write_lock_owner(lockPath, token, timestamp)
ownerFile = fullfile(lockPath, "owner.txt");
fid = fopen(char(ownerFile), 'w', 'n', 'UTF-8');
if fid < 0
    error("ProjectName_utils:plotting:LockOwnerWriteFailed", ...
        "Could not write figure lock owner file: %s", ownerFile);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, "%s\n%.17g\n", token, timestamp);
clear cleanup
end

function [token, timestamp] = read_lock_owner(lockPath)
token = "";
timestamp = NaN;
ownerFile = fullfile(lockPath, "owner.txt");
if exist(char(ownerFile), "file") ~= 2
    return
end
try
    lines = splitlines(read_utf8_text(ownerFile));
    if ~isempty(lines)
        token = strtrim(lines(1));
    end
    if numel(lines) >= 2
        timestamp = str2double(strtrim(lines(2)));
    end
catch
    token = "";
    timestamp = NaN;
end
end

function timestamp = current_lock_timestamp()
timestamp = posixtime(datetime("now", "TimeZone", "UTC"));
end

function ageSeconds = lock_age_seconds(lockPath)
[~, timestamp] = read_lock_owner(lockPath);
if isfinite(timestamp)
    ageSeconds = max(0, current_lock_timestamp() - timestamp);
    return
end

ownerFile = fullfile(lockPath, "owner.txt");
info = dir(char(ownerFile));
if isempty(info)
    [parentDir, lockName, lockExt] = fileparts(lockPath);
    info = dir(char(fullfile(parentDir, lockName + lockExt)));
end
if isempty(info)
    ageSeconds = 0;
else
    modifiedTime = datetime(info(1).datenum, ...
        "ConvertFrom", "datenum", "TimeZone", "local");
    ageSeconds = max(0, seconds(datetime("now", "TimeZone", "local") - modifiedTime));
end
end

function recovered = try_recover_stale_lock(lockPath, staleSeconds)
recovered = false;
if exist(char(lockPath), "dir") ~= 7 || lock_age_seconds(lockPath) <= staleSeconds
    return
end

quarantinePath = lockPath + ".stale." + create_transaction_id();
sourceObject = javaObject('java.io.File', char(lockPath));
quarantineObject = javaObject('java.io.File', char(quarantinePath));
if ~logical(sourceObject.renameTo(quarantineObject))
    return
end
recovered = true;
try
    rmdir(char(quarantinePath), "s");
catch cause
    warning("ProjectName_utils:plotting:StaleLockCleanupFailed", ...
        "Recovered stale lock but could not remove quarantine directory %s: %s", ...
        quarantinePath, cause.message);
end
end

function refresh_export_locks(locks)
for k = 1:numel(locks)
    [ownerToken, ~] = read_lock_owner(locks(k).path);
    if ownerToken ~= locks(k).token
        error("ProjectName_utils:plotting:LockOwnershipLost", ...
            "Figure transaction no longer owns lock %s.", locks(k).path);
    end
    write_lock_owner(locks(k).path, locks(k).token, current_lock_timestamp());
end
end

function release_export_locks(locks)
for k = numel(locks):-1:1
    lockPath = locks(k).path;
    if exist(char(lockPath), "dir") ~= 7
        continue
    end
    [ownerToken, ~] = read_lock_owner(lockPath);
    if ownerToken ~= locks(k).token
        warning("ProjectName_utils:plotting:LockOwnershipMismatch", ...
            "Did not remove lock with a different owner token: %s", lockPath);
        continue
    end
    [removed, removeMessage] = rmdir(char(lockPath), "s");
    if ~removed
        warning("ProjectName_utils:plotting:LockReleaseFailed", ...
            "Could not release figure lock %s: %s", lockPath, removeMessage);
    end
end
end

function stageRoot = create_staging_directory(outDir, transactionId)
ProjectName_utils.io.ensure_dir(outDir);
canonicalOutDir = canonical_output_path(outDir);
stageRoot = fullfile(canonicalOutDir, ...
    ".ProjectName-figure-stage-" + transactionId);
stageObject = javaObject('java.io.File', char(stageRoot));
if ~logical(stageObject.mkdir())
    error("ProjectName_utils:plotting:StageCreateFailed", ...
        "Could not create unique figure staging directory %s.", stageRoot);
end
end

function stagedPath = transaction_sibling_path(finalPath, kind, transactionId)
canonicalFinalPath = canonical_output_path(finalPath);
[parentDir, baseName, extension] = fileparts(canonicalFinalPath);
stagedName = "." + baseName + extension + ".ProjectName-" + kind + "-" + transactionId;
stagedPath = fullfile(parentDir, stagedName);
end

function export_figure_bundle(figHandle, outputs, plotData, extraFormats, dpi)
savefig(figHandle, char(outputs.figFile));
exportgraphics(figHandle, char(outputs.pngFile), "Resolution", dpi);

try
    exportgraphics(figHandle, char(outputs.svgFile), "ContentType", "vector");
catch
    print(figHandle, char(outputs.svgFile), "-dsvg");
end

if strlength(outputs.plotDataFile) > 0
    write_plot_data(plotData, outputs.plotDataFile);
end

exportedExtraFiles = export_extra_formats( ...
    figHandle, outputs.outDir, outputs.figName, extraFormats, dpi);
if ~isequal(string(exportedExtraFiles), string(outputs.extraFiles))
    error("ProjectName_utils:plotting:StagingPathMismatch", ...
        "Staged extra-format paths do not match the planned output paths.");
end
end

function stage_metadata_files(outputs, stagedOutputs, manifest, figName, checks)
stage_manifest_registry(outputs.manifestFile, stagedOutputs.manifestFile, manifest);
stage_check_report_registry(outputs.checkReportFile, ...
    stagedOutputs.checkReportFile, figName, checks, manifest);
end

function stage_manifest_registry(sourceFile, stagedFile, manifest)
rows = read_manifest_rows(sourceFile);
fid = fopen(char(stagedFile), 'w', 'n', 'UTF-8');
if fid < 0
    error("ProjectName_utils:plotting:ManifestOpenFailed", ...
        "Could not open staged manifest file: %s", stagedFile);
end
cleanup = onCleanup(@() fclose(fid));
currentWritten = false;
for k = 1:numel(rows)
    if manifest_rows_match(rows{k}, manifest)
        if ~currentWritten
            fprintf(fid, "%s\n", jsonencode(manifest));
            currentWritten = true;
        end
    else
        fprintf(fid, "%s\n", jsonencode(rows{k}));
    end
end
if ~currentWritten
    fprintf(fid, "%s\n", jsonencode(manifest));
end
clear cleanup
end

function stage_check_report_registry(sourceFile, stagedFile, figName, checks, manifest)
existingText = "";
if exist(char(sourceFile), "file") == 2
    existingText = read_utf8_text(sourceFile);
    existingText = remove_check_report_entry(existingText, figName);
end
fid = fopen(char(stagedFile), 'w', 'n', 'UTF-8');
if fid < 0
    error("ProjectName_utils:plotting:ReportOpenFailed", ...
        "Could not open staged check report file: %s", stagedFile);
end
cleanup = onCleanup(@() fclose(fid));
if strlength(existingText) > 0
    fprintf(fid, "%s", char(existingText));
end
clear cleanup
ensure_file_ends_with_newline(stagedFile);
write_check_report(stagedFile, figName, checks, manifest);
end

function text = remove_check_report_entry(text, figName)
escapedName = regexptranslate('escape', char(figName));
pattern = ['(?ms)^##[ \t]+' escapedName ...
    '[ \t]*\r?\n.*?(?=^##[ \t]+|\z)'];
text = string(regexprep(char(text), pattern, ''));
end

function commit_staged_bundle(stagedOutputs, outputs, obsoletePaths, ...
        transactionId, testCommitFailureAfter)
stagedPaths = bundle_paths(stagedOutputs);
finalPaths = bundle_paths(outputs);
if numel(stagedPaths) ~= numel(finalPaths)
    error("ProjectName_utils:plotting:CommitPathMismatch", ...
        "Staged and final figure bundles do not contain the same number of files.");
end
for k = 1:numel(stagedPaths)
    if exist(char(stagedPaths(k)), "file") ~= 2
        error("ProjectName_utils:plotting:MissingStagedArtifact", ...
            "Expected staged figure artifact is missing: %s", stagedPaths(k));
    end
end

transactionPaths = [finalPaths, string(obsoletePaths)];
replacementPaths = [stagedPaths, strings(size(obsoletePaths))];
requiresReplacement = [true(size(finalPaths)), false(size(obsoletePaths))];
backupPaths = strings(size(transactionPaths));
hadOriginal = false(size(transactionPaths));
committed = false(size(transactionPaths));
replacementAttempted = false(size(transactionPaths));
commitCount = 0;

try
    for k = 1:numel(transactionPaths)
        finalPath = transactionPaths(k);
        if requiresReplacement(k) && exist(char(finalPath), "dir") == 7
            error("ProjectName_utils:plotting:OutputTargetIsDirectory", ...
                "Figure output target became a directory during commit: %s", finalPath);
        end
        if requiresReplacement(k) && commitCount >= testCommitFailureAfter
            error("ProjectName_utils:plotting:InjectedCommitFailure", ...
                "Injected figure commit failure after %d committed files.", commitCount);
        end

        ensure_parent_directory(finalPath);
        backupPaths(k) = transaction_sibling_path(finalPath, "backup", transactionId);
        if exist(char(backupPaths(k)), "file") == 2 || ...
                exist(char(backupPaths(k)), "dir") == 7
            error("ProjectName_utils:plotting:BackupPathConflict", ...
                "Figure backup path already exists: %s", backupPaths(k));
        end
        if exist(char(finalPath), "file") == 2
            [backedUp, backupMessage] = movefile( ...
                char(finalPath), char(backupPaths(k)), "f");
            if ~backedUp
                error("ProjectName_utils:plotting:BackupFailed", ...
                    "Could not back up existing output %s: %s", ...
                    finalPath, backupMessage);
            end
            hadOriginal(k) = true;
        end

        if requiresReplacement(k)
            replacementAttempted(k) = true;
            [moved, moveMessage] = movefile( ...
                char(replacementPaths(k)), char(finalPath), "f");
            if ~moved || exist(char(finalPath), "file") ~= 2
                error("ProjectName_utils:plotting:CommitFailed", ...
                    "Could not commit staged output %s to %s: %s", ...
                    replacementPaths(k), finalPath, moveMessage);
            end
            committed(k) = true;
            commitCount = commitCount + 1;
        end
    end
catch cause
    try
        [rollbackOk, rollbackDetails, preservedBackups] = rollback_committed_bundle( ...
            transactionPaths, backupPaths, hadOriginal, committed, replacementAttempted);
    catch rollbackCause
        preservedBackups = existing_backup_paths(backupPaths);
        error("ProjectName_utils:plotting:RollbackFailed", ...
            ["Figure commit failed (%s): %s Rollback raised %s: %s. " ...
            "Preserved backup files: %s"], ...
            string(cause.identifier), string(cause.message), ...
            string(rollbackCause.identifier), string(rollbackCause.message), ...
            strjoin(preservedBackups, ", "));
    end
    if ~rollbackOk
        error("ProjectName_utils:plotting:RollbackFailed", ...
            ["Figure commit failed (%s): %s Rollback could not restore the prior bundle. " ...
            "Preserved backup files: %s. Recovery details: %s"], ...
            string(cause.identifier), string(cause.message), ...
            strjoin(preservedBackups, ", "), strjoin(rollbackDetails, " | "));
    end
    rethrow(cause)
end

for k = 1:numel(backupPaths)
    if exist(char(backupPaths(k)), "file") == 2
        try
            delete(char(backupPaths(k)));
        catch cause
            warning("ProjectName_utils:plotting:BackupCleanupFailed", ...
                "Committed bundle retained backup file %s: %s", ...
                backupPaths(k), cause.message);
        end
    end
end
end

function [ok, details, preservedBackups] = rollback_committed_bundle( ...
        finalPaths, backupPaths, hadOriginal, committed, replacementAttempted)
ok = true;
details = strings(1, 0);
for k = numel(finalPaths):-1:1
    finalPath = finalPaths(k);
    shouldRemoveFinal = committed(k) || hadOriginal(k) || replacementAttempted(k);
    if shouldRemoveFinal && exist(char(finalPath), "dir") == 7
        ok = false;
        details(end + 1) = "Target is a directory and was not removed: " + finalPath; %#ok<AGROW>
        continue
    end
    if shouldRemoveFinal && exist(char(finalPath), "file") == 2
        try
            delete(char(finalPath));
        catch cause
            ok = false;
            details(end + 1) = "Could not remove replacement " + finalPath + ...
                ": " + string(cause.message); %#ok<AGROW>
            continue
        end
        if exist(char(finalPath), "file") == 2
            ok = false;
            details(end + 1) = "Replacement remained after delete: " + finalPath; %#ok<AGROW>
            continue
        end
    end
    if hadOriginal(k)
        if exist(char(backupPaths(k)), "file") ~= 2
            ok = false;
            details(end + 1) = "Backup is missing: " + backupPaths(k); %#ok<AGROW>
            continue
        end
        try
            ensure_parent_directory(finalPath);
            [restored, restoreMessage] = movefile( ...
                char(backupPaths(k)), char(finalPath), "f");
        catch cause
            ok = false;
            details(end + 1) = "Could not start restore for " + finalPath + ...
                ": " + string(cause.message); %#ok<AGROW>
            continue
        end
        if ~restored || exist(char(finalPath), "file") ~= 2 || ...
                exist(char(backupPaths(k)), "file") == 2
            ok = false;
            details(end + 1) = "Could not restore " + finalPath + ...
                ": " + string(restoreMessage); %#ok<AGROW>
        end
    end
end
preservedBackups = existing_backup_paths(backupPaths);
end

function paths = existing_backup_paths(backupPaths)
paths = strings(1, 0);
for k = 1:numel(backupPaths)
    if exist(char(backupPaths(k)), "file") == 2
        paths(end + 1) = backupPaths(k); %#ok<AGROW>
    end
end
end

function paths = bundle_paths(outputs)
paths = [string(outputs.figFile), string(outputs.pngFile), string(outputs.svgFile)];
if strlength(string(outputs.plotDataFile)) > 0
    paths(end + 1) = string(outputs.plotDataFile);
end
paths = [paths, string(outputs.extraFiles), string(outputs.manifestFile), ...
    string(outputs.checkReportFile)];
end

function ensure_parent_directory(filePath)
[parentDir, ~, ~] = fileparts(string(filePath));
if strlength(parentDir) > 0
    ProjectName_utils.io.ensure_dir(parentDir);
end
end

function cleanup_staged_bundle(stagedOutputs, stageRoot)
stagedPaths = bundle_paths(stagedOutputs);
for k = 1:numel(stagedPaths)
    if exist(char(stagedPaths(k)), "file") == 2
        try
            delete(char(stagedPaths(k)));
        catch
        end
    end
end
cleanup_staging_directory(stageRoot);
end

function cleanup_staging_directory(stageRoot)
if strlength(string(stageRoot)) == 0 || exist(char(stageRoot), "dir") ~= 7
    return
end
try
    rmdir(char(stageRoot), "s");
catch
    % The staging path is outside the formal result bundle and may be retried later.
end
end

function close_figure_if_requested(figHandle, closeFigure)
if closeFigure && isgraphics(figHandle, "figure")
    close(figHandle);
end
end

function write_plot_data(plotData, csvFile)
if istable(plotData)
    writetable(plotData, char(csvFile));
elseif istimetable(plotData)
    writetimetable(plotData, char(csvFile));
elseif isnumeric(plotData) || islogical(plotData)
    writematrix(plotData, char(csvFile));
elseif isstruct(plotData)
    try
        writetable(struct2table(plotData), char(csvFile));
    catch cause
        error("ProjectName_utils:plotting:UnsupportedPlotData", ...
            "Struct plot data must be convertible with struct2table: %s", cause.message);
    end
else
    error("ProjectName_utils:plotting:UnsupportedPlotData", ...
        "PlotData must be a table, timetable, numeric/logical matrix, or scalar struct.");
end
end

function extraFiles = export_extra_formats(figHandle, outDir, figName, extraFormats, dpi)
extraFiles = strings(1, 0);
for k = 1:numel(extraFormats)
    fmt = lower(string(extraFormats(k)));
    switch fmt
        case "pdf"
            outFile = fullfile(outDir, figName + ".pdf");
            exportgraphics(figHandle, char(outFile), "ContentType", "vector");
        case "eps"
            outFile = fullfile(outDir, figName + ".eps");
            print(figHandle, char(outFile), "-depsc");
        case {"tif", "tiff"}
            outFile = fullfile(outDir, figName + ".tiff");
            exportgraphics(figHandle, char(outFile), "Resolution", dpi);
        otherwise
            error("ProjectName_utils:plotting:UnsupportedFormat", ...
                "Unsupported extra figure format: %s", fmt);
    end
    extraFiles(end + 1) = outFile; %#ok<AGROW>
end
end

function manifest = build_manifest(figHandle, figName, fontName, profile, options, outputs)
metadata = options.Metadata;
metadata = set_default_field(metadata, "figNo", figName);
metadata.figName = figName;
if ~isfield(metadata, "claimId")
    metadata.claimId = "";
end
metadata = set_default_field(metadata, "script", infer_caller_script());
metadata = set_default_field(metadata, "command", string(options.Command));
metadata = set_default_field(metadata, "keyParams", struct());
metadata = set_default_field(metadata, "excludedPoints", "none");
metadata = set_default_field(metadata, "logAxisThreshold", "not_applicable");
metadata.matlabVersion = string(version);
metadata.font = fontName;
metadata.figureProfile = profile.name;
metadata.figureProfileSource = profile.source;
metadata.profileDefaultLayout = profile.defaultLayout;
metadata.profileFontSizePt = profile.fontSizePt;
metadata.profileDefaultFontSizePt = profile.defaultFontSizePt;
metadata.profileMinimumFontSizePt = profile.minFontSizePt;
metadata.appliedFontSizePt = profile.appliedFontSizePt;
metadata.profileLegendRule = profile.legendRule;
metadata.profileNarrativeRule = profile.narrativeRule;
metadata.profileTickDir = profile.tickDir;
metadata.profilePreviewDpi = profile.previewDpi;
metadata.profileRasterColorGrayDpi = profile.rasterColorGrayDpi;
metadata.profileRasterLineArtDpi = profile.rasterLineArtDpi;
metadata.profileAcceptedSubmissionFormats = profile.acceptedSubmissionFormats;
metadata.profileSingleColumnWidthCm = profile.singleColumnWidthCm;
metadata.profileDoubleColumnWidthCm = profile.doubleColumnWidthCm;
metadata.profileMaxWidthCm = profile.maxWidthCm;
metadata.colormap = summarize_colormap(figHandle);
metadata.isDiagnostic = options.IsDiagnostic;
metadata.allowSotaBeforePhysical = options.AllowSotaBeforePhysical;
metadata.overrideReason = strtrim(string(options.OverrideReason));
metadata.timestamp = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));
metadata.outputFiles = struct( ...
    "fig", outputs.figFile, ...
    "png", outputs.pngFile, ...
    "svg", outputs.svgFile, ...
    "plotData", outputs.plotDataFile, ...
    "extra", outputs.extraFiles);

if strlength(strtrim(string(options.Script))) > 0
    metadata.script = strtrim(string(options.Script));
end
if strlength(strtrim(string(options.Command))) > 0
    metadata.command = strtrim(string(options.Command));
end

if options.AllowSotaBeforePhysical && is_blank(metadata.overrideReason)
    error("ProjectName_utils:plotting:MissingOverrideReason", ...
        "AllowSotaBeforePhysical=true requires a nonempty OverrideReason that records the approved reason from 01_IDEA/figure_plan.md.");
end

requiredFields = ["script", "sciQuestion", "physicsReproduction", "evidenceRole", ...
    "dataFiles", "dataDescription", ...
    "visualEncoding", "targetLayout", "command", "keyParams", "randomSeed"];
if ~options.IsDiagnostic
    requiredFields = ["contractVersion", "figurePlanId", "claimId", requiredFields];
end
missingFields = strings(1, 0);
for k = 1:numel(requiredFields)
    fieldName = requiredFields(k);
    if ~isfield(metadata, fieldName) || is_blank(metadata.(fieldName))
        missingFields(end + 1) = fieldName; %#ok<AGROW>
    end
end
if ~isempty(missingFields)
    error("ProjectName_utils:plotting:MissingMetadata", ...
        "Missing figure metadata: %s. Do not export formal figures until the claim id, scientific question, physical reproduction target, evidence role, data source, data fields/units, visual encoding, target layout, command, key parameters, and random seed/status are explicit.", ...
        strjoin(missingFields, ", "));
end

metadata.claimId = strtrim(string(metadata.claimId));
if ~options.IsDiagnostic && ~is_valid_claim_id(metadata.claimId)
    error("ProjectName_utils:plotting:InvalidClaimId", ...
        "Formal figure claimId '%s' is empty or a non-binding sentinel. Use a registered conclusion id, or set IsDiagnostic=true for an unbound diagnostic figure.", ...
        metadata.claimId);
end

validRoles = canonical_evidence_roles();
role = lower(strtrim(string(metadata.evidenceRole)));
if ~isscalar(role) || ~ismember(role, validRoles)
    error("ProjectName_utils:plotting:InvalidEvidenceRole", ...
        "evidenceRole '%s' is not allowed. Figures must use one of: %s. See .cursor/rules/04-case-figure-and-metric-plan.mdc and 01_IDEA/figure_plan.md.", ...
        strjoin(role, ", "), strjoin(validRoles, ", "));
end
metadata.evidenceRole = role;

manifest = orderfields(metadata);
end

function value = infer_caller_script()
stack = dbstack("-completenames");
value = "interactive-or-evaluated-call";
if isempty(stack)
    return
end
saveFigureFile = string(stack(1).file);
for k = 2:numel(stack)
    if ~strcmpi(string(stack(k).file), saveFigureFile)
        value = string(stack(k).file);
        return
    end
end
end

function metadata = set_default_field(metadata, fieldName, value)
fieldName = char(fieldName);
if ~isfield(metadata, fieldName) || is_blank(metadata.(fieldName))
    metadata.(fieldName) = value;
end
end

function tf = is_blank(value)
if isempty(value)
    tf = true;
elseif isstring(value) || ischar(value)
    tf = all(strlength(strtrim(string(value))) == 0);
elseif isstruct(value)
    tf = isempty(fieldnames(value));
else
    tf = false;
end
end

function tf = is_valid_claim_id(claimId)
claimId = string(claimId);
if ~isscalar(claimId) || is_blank(claimId)
    tf = false;
    return
end
normalized = lower(regexprep(strtrim(claimId), '[\s_\-\./]+', ""));
sentinels = ["na", "none", "null", "nil", "notapplicable", ...
    "notavailable", "notassigned", "unbound", "tbd", "todo", "unknown"];
tf = ~ismember(normalized, sentinels);
end

function summary = summarize_colormap(figHandle)
try
    cmap = figHandle.Colormap;
    summary = sprintf("figure colormap, %d rows", size(cmap, 1));
catch
    summary = "not_available";
end
end

function roles = canonical_evidence_roles()
roles = ["scenario-setup", "physical-reproduction", "sota-comparison", ...
    "sensitivity-ablation"];
end

function [narrativeOk, overrideUsed] = enforce_evidence_narrative( ...
        manifestFile, manifest, allowSotaBeforePhysical)
narrativeOk = true;
overrideUsed = false;
if manifest.isDiagnostic
    return
end
role = string(manifest.evidenceRole);
if ~ismember(role, ["sota-comparison", "sensitivity-ablation"])
    return
end

claimId = string(manifest.claimId);
existing = read_existing_manifest(manifestFile, manifest);
hasPhysical = false;
for k = 1:numel(existing)
    if existing(k).isDiagnostic || ...
            existing(k).evidenceRole ~= "physical-reproduction"
        continue
    end
    if existing(k).claimId == claimId
        hasPhysical = true;
        break
    end
end

if ~hasPhysical
    narrativeOk = false;
    if ~allowSotaBeforePhysical
        error("ProjectName_utils:plotting:NarrativeOrder", ...
            "Evidence role '%s' for claim '%s' requires a prior 'physical-reproduction' figure for the same claim in %s. Register a case-study physical-reproduction figure first, or set AllowSotaBeforePhysical to true with a recorded reason in 01_IDEA/figure_plan.md.", ...
            role, claimId, manifestFile);
    end
    overrideUsed = true;
end
end

function info = read_existing_manifest(manifestFile, currentManifest)
info = struct("evidenceRole", {}, "claimId", {}, "isDiagnostic", {});
rows = read_manifest_rows(manifestFile);
for k = 1:numel(rows)
    row = rows{k};
    if manifest_rows_match(row, currentManifest)
        continue
    end
    role = "";
    if isfield(row, "evidenceRole")
        role = lower(strtrim(string(row.evidenceRole)));
    end
    claim = "";
    if isfield(row, "claimId")
        claim = strtrim(string(row.claimId));
    end
    isDiagnostic = false;
    if isfield(row, "isDiagnostic")
        isDiagnostic = logical_scalar(row.isDiagnostic);
    end
    info(end + 1) = struct( ...
        "evidenceRole", role, ...
        "claimId", claim, ...
        "isDiagnostic", isDiagnostic); %#ok<AGROW>
end
end

function rows = read_manifest_rows(manifestFile)
rows = cell(0, 1);
if exist(char(manifestFile), "file") ~= 2
    return
end
lines = splitlines(read_utf8_text(manifestFile));
lines = lines(strlength(strtrim(lines)) > 0);
for k = 1:numel(lines)
    try
        row = jsondecode(char(lines(k)));
    catch cause
        error("ProjectName_utils:plotting:InvalidManifestLine", ...
            "Manifest %s contains invalid JSON at nonblank line %d: %s", ...
            manifestFile, k, cause.message);
    end
    if ~isstruct(row) || ~isscalar(row)
        error("ProjectName_utils:plotting:InvalidManifestRow", ...
            "Manifest %s line %d must decode to one JSON object.", manifestFile, k);
    end
    rows{end + 1, 1} = row; %#ok<AGROW>
end
end

function tf = manifest_rows_match(existingRow, currentManifest)
existingFigPath = manifest_fig_path(existingRow);
currentFigPath = manifest_fig_path(currentManifest);
if strlength(existingFigPath) > 0 && strlength(currentFigPath) > 0
    tf = canonical_comparison_path(existingFigPath) == ...
        canonical_comparison_path(currentFigPath);
    return
end
tf = isfield(existingRow, "figName") && isfield(currentManifest, "figName") && ...
    string(existingRow.figName) == string(currentManifest.figName);
end

function figPath = manifest_fig_path(row)
figPath = "";
if isfield(row, "outputFiles") && isstruct(row.outputFiles) && ...
        isscalar(row.outputFiles) && isfield(row.outputFiles, "fig")
    value = string(row.outputFiles.fig);
    if isscalar(value)
        figPath = value;
    end
end
end

function text = read_utf8_text(filePath)
fid = fopen(char(filePath), 'r', 'n', 'UTF-8');
if fid < 0
    error("ProjectName_utils:plotting:TextReadFailed", ...
        "Could not read UTF-8 text file: %s", filePath);
end
cleanup = onCleanup(@() fclose(fid));
text = string(fread(fid, Inf, '*char')');
clear cleanup
end

function ensure_file_ends_with_newline(filePath)
if exist(char(filePath), "file") ~= 2
    return
end
info = dir(char(filePath));
if isempty(info) || info(1).bytes == 0
    return
end
fid = fopen(char(filePath), 'rb');
if fid < 0
    error("ProjectName_utils:plotting:TextReadFailed", ...
        "Could not inspect text-file boundary: %s", filePath);
end
cleanup = onCleanup(@() fclose(fid));
fseek(fid, -1, 'eof');
lastByte = fread(fid, 1, '*uint8');
clear cleanup
if ~ismember(lastByte, uint8([10, 13]))
    fid = fopen(char(filePath), 'ab');
    if fid < 0
        error("ProjectName_utils:plotting:TextAppendFailed", ...
            "Could not add a line boundary to text file: %s", filePath);
    end
    cleanup = onCleanup(@() fclose(fid));
    fwrite(fid, uint8(10), 'uint8');
    clear cleanup
end
end

function value = logical_scalar(rawValue)
if islogical(rawValue) && isscalar(rawValue)
    value = rawValue;
elseif isnumeric(rawValue) && isscalar(rawValue)
    value = rawValue ~= 0;
elseif (ischar(rawValue) || isstring(rawValue)) && isscalar(string(rawValue))
    value = ismember(lower(strtrim(string(rawValue))), ["true", "1", "yes"]);
else
    value = false;
end
end

function checks = run_quality_checks(outputs, manifest, narrativeOk)
checks = struct();
checks.figGenerated = file_exists(outputs.figFile);
checks.pngGenerated = file_exists(outputs.pngFile);
checks.svgGenerated = file_exists(outputs.svgFile);
checks.pngNonblank = png_nonblank(outputs.pngFile);
checks.svgReadable = svg_readable(outputs.svgFile);
checks.plotDataExported = strlength(outputs.plotDataFile) == 0 || file_exists(outputs.plotDataFile);
checks.manifestComplete = manifest_complete(manifest);
checks.figureProfileRecorded = isfield(manifest, "figureProfile") && ~is_blank(manifest.figureProfile);
checks.claimBound = manifest.isDiagnostic || ...
    (isfield(manifest, "claimId") && is_valid_claim_id(manifest.claimId));
checks.figurePlanLinked = manifest.isDiagnostic || ...
    (isfield(manifest, "contractVersion") && ~is_blank(manifest.contractVersion) && ...
    isfield(manifest, "figurePlanId") && ~is_blank(manifest.figurePlanId));
checks.evidenceNarrativeOrdered = narrativeOk;
checks.narrativeOverrideUsed = manifest.narrativeOverrideUsed;
checks.overrideReasonRecorded = ~manifest.allowSotaBeforePhysical || ...
    ~is_blank(manifest.overrideReason);
checks.manualReadabilityReviewRequired = true;
checks.manualLegendReviewRequired = true;
checks.manualAxisLabelDensityReviewRequired = true;
checks.manualStructuredLabelReviewRequired = true;
checks.manualMethodStyleReviewRequired = true;
checks.manualGrayscaleReviewRequired = true;
checks.manualLogAxisAndExcludedPointReviewRequired = true;
end

function tf = file_exists(filePath)
tf = strlength(string(filePath)) > 0 && exist(char(filePath), "file") == 2;
end

function tf = png_nonblank(pngFile)
tf = false;
if ~file_exists(pngFile)
    return
end
try
    img = imread(char(pngFile));
    tf = ~isempty(img) && any(img(:) ~= img(1));
catch
    tf = false;
end
end

function tf = svg_readable(svgFile)
tf = false;
if ~file_exists(svgFile)
    return
end
try
    txt = fileread(char(svgFile));
    tf = contains(txt, "<svg", "IgnoreCase", true);
catch
    tf = false;
end
end

function tf = manifest_complete(manifest)
requiredFields = ["figNo", "figName", "claimId", "sciQuestion", "physicsReproduction", ...
    "evidenceRole", "dataFiles", ...
    "dataDescription", "visualEncoding", "targetLayout", "script", ...
    "command", "keyParams", "randomSeed", "matlabVersion", "font", ...
    "figureProfile", "profilePreviewDpi", ...
    "colormap", "isDiagnostic", "excludedPoints", "logAxisThreshold", ...
    "allowSotaBeforePhysical", "overrideReason", ...
    "evidenceNarrativeOrdered", "narrativeOverrideUsed", "timestamp"];
tf = true;
for k = 1:numel(requiredFields)
    fieldName = requiredFields(k);
    tf = tf && isfield(manifest, fieldName);
end
valueFields = ["figNo", "figName", "sciQuestion", "physicsReproduction", ...
    "evidenceRole", "dataFiles", "dataDescription", "visualEncoding", ...
    "targetLayout", "script", "command", "keyParams", "randomSeed", ...
    "matlabVersion", "font", "figureProfile", "colormap", "timestamp"];
for k = 1:numel(valueFields)
    fieldName = valueFields(k);
    tf = tf && isfield(manifest, fieldName) && ~is_blank(manifest.(fieldName));
end
if isfield(manifest, "isDiagnostic") && ~manifest.isDiagnostic
    tf = tf && isfield(manifest, "claimId") && is_valid_claim_id(manifest.claimId) && ...
        isfield(manifest, "contractVersion") && ~is_blank(manifest.contractVersion) && ...
        isfield(manifest, "figurePlanId") && ~is_blank(manifest.figurePlanId);
end
end

function write_check_report(reportFile, figName, checks, manifest)
ensure_file_ends_with_newline(reportFile);
fid = fopen(char(reportFile), 'a', 'n', 'UTF-8');
if fid < 0
    error("ProjectName_utils:plotting:ReportOpenFailed", ...
        "Could not open check report file: %s", reportFile);
end
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, "## %s\n\n", figName);
fprintf(fid, "- PASS/FAIL items are checked automatically from exported files.\n");
fprintf(fid, "- REVIEW_REQUIRED items must be checked by the figure author before manuscript use.\n\n");

fprintf(fid, "| Check | Status |\n");
fprintf(fid, "| --- | --- |\n");
fprintf(fid, "| .fig generated | %s |\n", status_text(checks.figGenerated));
fprintf(fid, "| .png generated | %s |\n", status_text(checks.pngGenerated));
fprintf(fid, "| .svg generated | %s |\n", status_text(checks.svgGenerated));
fprintf(fid, "| PNG nonblank | %s |\n", status_text(checks.pngNonblank));
fprintf(fid, "| SVG readable | %s |\n", status_text(checks.svgReadable));
fprintf(fid, "| Plot data CSV exported when provided | %s |\n", status_text(checks.plotDataExported));
fprintf(fid, "| Manifest fields complete | %s |\n", status_text(checks.manifestComplete));
fprintf(fid, "| Figure profile recorded in manifest | %s |\n", status_text(checks.figureProfileRecorded));
fprintf(fid, "| Formal figure bound to a real claim id, or marked diagnostic | %s |\n", status_text(checks.claimBound));
fprintf(fid, "| Formal figure linked to contract version and figure plan | %s |\n", status_text(checks.figurePlanLinked));
fprintf(fid, "| Evidence-role narrative ordered (physical reproduction before SOTA/sensitivity) | %s |\n", status_text(checks.evidenceNarrativeOrdered));
fprintf(fid, "| Narrative override reason recorded when enabled | %s |\n", status_text(checks.overrideReasonRecorded));
fprintf(fid, "| Narrative override used | %s |\n", yes_no_text(checks.narrativeOverrideUsed));
fprintf(fid, "| Data was not changed for visual effect; any filtering or transform is declared | REVIEW_REQUIRED |\n");
fprintf(fid, "| Text, axes, legend, lines, and markers readable at target size | REVIEW_REQUIRED |\n");
fprintf(fid, "| Target journal instructions checked against the active figure profile | REVIEW_REQUIRED |\n");
fprintf(fid, "| Final submission format and raster resolution satisfy the target venue | REVIEW_REQUIRED |\n");
fprintf(fid, "| Metric is claim-relevant, defined in symbols/derivation, and a recognized or derived quantity | REVIEW_REQUIRED |\n");
fprintf(fid, "| Legend is in-axes when suitable and does not cover key curves, bars, peaks, or uncertainty bands | REVIEW_REQUIRED |\n");
fprintf(fid, "| X-axis labels are not too dense | REVIEW_REQUIRED |\n");
fprintf(fid, "| Structured labels use domain-readable forms | REVIEW_REQUIRED |\n");
fprintf(fid, "| Method color, line style, and marker match methodStyle | REVIEW_REQUIRED |\n");
fprintf(fid, "| Formal figure uses an independent exported subfigure layout | REVIEW_REQUIRED |\n");
fprintf(fid, "| Methods remain distinguishable in grayscale | REVIEW_REQUIRED |\n");
fprintf(fid, "| Log-axis zero handling and excluded points are declared | REVIEW_REQUIRED |\n\n");
if manifest.allowSotaBeforePhysical
    reason = markdown_inline_text(manifest.overrideReason);
    fprintf(fid, "- Narrative override reason: %s\n\n", reason);
end
end

function text = status_text(tf)
if tf
    text = "PASS";
else
    text = "FAIL";
end
end

function text = yes_no_text(tf)
if tf
    text = "YES";
else
    text = "NO";
end
end

function text = markdown_inline_text(value)
text = strtrim(string(value));
text = regexprep(text, '[\r\n]+', ' ');
text = replace(text, "|", "\|");
end

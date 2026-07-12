function smoke_figure_contracts()
%SMOKE_FIGURE_CONTRACTS Check transactional export and evidence-role gates.

projectRoot = fileparts(fileparts(mfilename("fullpath")));
addpath(projectRoot);

testRoot = string(tempname);
mkdir(testRoot);
testCleanup = onCleanup(@() remove_test_directory(testRoot));
plotData = table((1:4)', [1.0; 1.4; 1.8; 2.1], ...
    'VariableNames', {'sampleIndex', 'metricPu'});

metadata = base_metadata("C_FIGURE_CONTRACT");
successDir = fullfile(testRoot, "success");
fig = make_test_figure();
outputs = ProjectName_utils.plotting.save_figure(fig, successDir, ...
    "FigContractPhysical", ...
    "Metadata", metadata, ...
    "PlotData", plotData);
assert(~isgraphics(fig), "CloseFigure=true should close a successful export figure.");
assert_complete_bundle(outputs);
physicalRow = last_manifest_row(outputs.manifestFile);
assert(string(physicalRow.contractVersion) == "2026.07.12" && ...
        string(physicalRow.figurePlanId) == "FP-SMOKE-CONTRACT", ...
    "Formal figure manifest must retain the handoff contract and plan link.");
scriptPath = replace(string(physicalRow.script), "\", "/");
assert(endsWith(scriptPath, "/tests/smoke_figure_contracts.m"), ...
    "Manifest script provenance should identify the real calling test file.");
assert(~physicalRow.isDiagnostic, "The successful formal figure should not be diagnostic.");

sotaMetadata = metadata;
sotaMetadata.figNo = "FigContractSota";
sotaMetadata.evidenceRole = "sota-comparison";
fig = make_test_figure();
sotaOutputs = ProjectName_utils.plotting.save_figure(fig, successDir, ...
    "FigContractSota", ...
    "Metadata", sotaMetadata, ...
    "PlotData", plotData);
assert_complete_bundle(sotaOutputs);
sotaRow = last_manifest_row(sotaOutputs.manifestFile);
assert(sotaRow.evidenceNarrativeOrdered, ...
    "A prior formal physical-reproduction row should unlock SOTA for the same claim.");
assert(~sotaRow.narrativeOverrideUsed, ...
    "A normally ordered SOTA figure should not record an override.");

strip_trailing_line_breaks(outputs.manifestFile);
strip_trailing_line_breaks(outputs.checkReportFile);
oldPlotDataFile = outputs.plotDataFile;
oldPdfFile = outputs.extraFiles(endsWith(outputs.extraFiles, ".pdf"));
assert(exist(char(oldPlotDataFile), "file") == 2, ...
    "The first export should provide plot data for the re-export cleanup test.");
assert(isscalar(oldPdfFile) && exist(char(oldPdfFile), "file") == 2, ...
    "The first export should provide one PDF for the re-export cleanup test.");
fig = make_test_figure();
replacementOutputs = ProjectName_utils.plotting.save_figure(fig, successDir, ...
    "FigContractPhysical", ...
    "Metadata", metadata, ...
    "UseProfileExtraFormats", false);
assert(exist(char(oldPlotDataFile), "file") ~= 2, ...
    "A same-name re-export without plot data should remove the old CSV.");
assert(exist(char(oldPdfFile), "file") ~= 2, ...
    "A same-name re-export without extra formats should remove the old PDF.");
assert(file_ends_with_line_break(replacementOutputs.manifestFile), ...
    "Manifest upsert should restore a terminating line break.");
assert(file_ends_with_line_break(replacementOutputs.checkReportFile), ...
    "Check-report upsert should restore a terminating line break.");
registryRows = read_manifest_rows(replacementOutputs.manifestFile);
assert(numel(registryRows) == 2, ...
    "Same-name re-export should replace its manifest row instead of retaining history that points to overwritten files.");
replacementRow = manifest_row_by_name(registryRows, "FigContractPhysical");
assert(strlength(string(replacementRow.outputFiles.plotData)) == 0, ...
    "The current manifest row should not register removed plot data.");
assert(isempty(replacementRow.outputFiles.extra), ...
    "The current manifest row should not register removed extra formats.");
reportText = string(fileread(char(replacementOutputs.checkReportFile)));
assert(count(reportText, "## FigContractPhysical") == 1, ...
    "Same-name re-export should replace the prior check-report entry.");

rollbackPaths = [replacementOutputs.figFile, replacementOutputs.pngFile, ...
    replacementOutputs.svgFile, replacementOutputs.manifestFile, ...
    replacementOutputs.checkReportFile];
rollbackBytes = cell(size(rollbackPaths));
for k = 1:numel(rollbackPaths)
    rollbackBytes{k} = read_file_bytes(rollbackPaths(k));
end
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, successDir, "FigContractPhysical", ...
    "Metadata", metadata, "PlotData", plotData, ...
    "TestCommitFailureAfter", 1), ...
    "ProjectName_utils:plotting:InjectedCommitFailure");
assert(~isgraphics(fig), "Injected commit failure should honor CloseFigure=true.");
for k = 1:numel(rollbackPaths)
    assert(isequal(read_file_bytes(rollbackPaths(k)), rollbackBytes{k}), ...
        "Rollback did not restore existing bundle file: %s", rollbackPaths(k));
end
assert(exist(char(oldPlotDataFile), "file") ~= 2 && ...
    exist(char(oldPdfFile), "file") ~= 2, ...
    "Rollback should not leave newly staged optional files.");
assert(isempty(dir(char(fullfile(successDir, ".*.ProjectName-backup-*")))), ...
    "Successful rollback should not leave backup files.");
assert(isempty(dir(char(fullfile(successDir, ".ProjectName-figure-stage-*")))), ...
    "Successful rollback should remove the staging directory.");

missingDir = fullfile(testRoot, "missing_metadata");
missingMetadata = rmfield(metadata, "dataDescription");
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, missingDir, "FigMissingMetadata", ...
    "Metadata", missingMetadata, "PlotData", plotData), ...
    "ProjectName_utils:plotting:MissingMetadata");
assert(~isgraphics(fig), "CloseFigure=true should close a figure after validation failure.");
assert_no_bundle_files(missingDir, "FigMissingMetadata");

stagedFailureDir = fullfile(testRoot, "staged_failure");
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, stagedFailureDir, "FigStagedFailure", ...
    "Metadata", metadata, "PlotData", {1, 2}), ...
    "ProjectName_utils:plotting:UnsupportedPlotData");
assert(~isgraphics(fig), "A staging failure should honor CloseFigure=true.");
assert_no_bundle_files(stagedFailureDir, "FigStagedFailure");

openFailureDir = fullfile(testRoot, "open_failure");
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, openFailureDir, "FigOpenFailure", ...
    "Metadata", missingMetadata, "PlotData", plotData, ...
    "CloseFigure", false), ...
    "ProjectName_utils:plotting:MissingMetadata");
assert(isgraphics(fig, "figure"), ...
    "CloseFigure=false should preserve a figure after validation failure.");
close(fig);
assert_no_bundle_files(openFailureDir, "FigOpenFailure");

sentinelDir = fullfile(testRoot, "sentinel_claim");
sentinelMetadata = metadata;
sentinelMetadata.claimId = "not_applicable";
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, sentinelDir, "FigSentinelClaim", ...
    "Metadata", sentinelMetadata, "PlotData", plotData), ...
    "ProjectName_utils:plotting:InvalidClaimId");
assert(~isgraphics(fig), "Sentinel-claim rejection should honor CloseFigure=true.");
assert_no_bundle_files(sentinelDir, "FigSentinelClaim");

aliasDir = fullfile(testRoot, "path_alias_collision");
aliasManifest = string(aliasDir) + filesep + "." + filesep + "FigAlias.fig";
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, aliasDir, "FigAlias", ...
    "Metadata", metadata, ...
    "PlotData", plotData, ...
    "ManifestFile", aliasManifest), ...
    "ProjectName_utils:plotting:OutputPathCollision");
assert(~isgraphics(fig), "Path-collision rejection should honor CloseFigure=true.");
assert_no_bundle_files(aliasDir, "FigAlias");

directoryTargetDir = fullfile(testRoot, "directory_target");
directoryReportTarget = fullfile(directoryTargetDir, "report.md");
mkdir(directoryReportTarget);
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, directoryTargetDir, "FigDirectoryTarget", ...
    "Metadata", metadata, "PlotData", plotData, ...
    "CheckReportFile", directoryReportTarget), ...
    "ProjectName_utils:plotting:OutputTargetIsDirectory");
assert(~isgraphics(fig), "Directory-target rejection should honor CloseFigure=true.");
assert_no_figure_artifacts(directoryTargetDir, "FigDirectoryTarget");

lockDir = fullfile(testRoot, "lock_contract");
mkdir(lockDir);
manifestPath = fullfile(lockDir, "figure_manifest.jsonl");
manifestLockPath = string(manifestPath) + ".ProjectName-lock";
write_test_lock(manifestLockPath, "external-owner", current_posix_time());
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, lockDir, "FigLockContract", ...
    "Metadata", metadata, "PlotData", plotData, ...
    "LockTimeoutSeconds", 0.2, "StaleLockSeconds", 3600), ...
    "ProjectName_utils:plotting:LockTimeout");
assert(~isgraphics(fig), "Lock timeout should honor CloseFigure=true.");
assert_no_figure_artifacts(lockDir, "FigLockContract");
write_test_lock(manifestLockPath, "external-owner", current_posix_time() - 7200);
fig = make_test_figure();
lockOutputs = ProjectName_utils.plotting.save_figure(fig, lockDir, ...
    "FigLockContract", ...
    "Metadata", metadata, "PlotData", plotData, ...
    "LockTimeoutSeconds", 2, "StaleLockSeconds", 1);
assert_complete_bundle(lockOutputs);
assert(exist(char(manifestLockPath), "dir") ~= 7, ...
    "A recovered stale manifest lock should be removed after commit.");

diagnosticDir = fullfile(testRoot, "diagnostic_gate");
diagnosticMetadata = metadata;
diagnosticMetadata.figNo = "FigDiagnosticPhysical";
diagnosticMetadata.claimId = "C_DIAGNOSTIC_MUST_NOT_UNLOCK";
fig = make_test_figure();
diagnosticOutputs = ProjectName_utils.plotting.save_figure(fig, diagnosticDir, ...
    "FigDiagnosticPhysical", ...
    "Metadata", diagnosticMetadata, ...
    "PlotData", plotData, ...
    "IsDiagnostic", true);
diagnosticRow = last_manifest_row(diagnosticOutputs.manifestFile);
assert(diagnosticRow.isDiagnostic, ...
    "A claim-linked diagnostic figure should retain isDiagnostic=true in the manifest.");
assert(string(diagnosticRow.claimId) == "C_DIAGNOSTIC_MUST_NOT_UNLOCK", ...
    "The diagnostic exclusion test requires the same claim id as the locked SOTA figure.");
manifestBefore = fileread(char(diagnosticOutputs.manifestFile));
reportBefore = fileread(char(diagnosticOutputs.checkReportFile));

lockedSotaMetadata = metadata;
lockedSotaMetadata.figNo = "FigLockedSota";
lockedSotaMetadata.claimId = "C_DIAGNOSTIC_MUST_NOT_UNLOCK";
lockedSotaMetadata.evidenceRole = "sota-comparison";
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, diagnosticDir, "FigLockedSota", ...
    "Metadata", lockedSotaMetadata, "PlotData", plotData), ...
    "ProjectName_utils:plotting:NarrativeOrder");
assert_no_figure_artifacts(diagnosticDir, "FigLockedSota");
assert(strcmp(fileread(char(diagnosticOutputs.manifestFile)), manifestBefore), ...
    "A rejected SOTA figure must not append to the manifest.");
assert(strcmp(fileread(char(diagnosticOutputs.checkReportFile)), reportBefore), ...
    "A rejected SOTA figure must not append to the check report.");

overrideDir = fullfile(testRoot, "override");
overrideMetadata = lockedSotaMetadata;
overrideMetadata.figNo = "FigOverride";
fig = make_test_figure();
assert_throws(@() ProjectName_utils.plotting.save_figure( ...
    fig, overrideDir, "FigOverride", ...
    "Metadata", overrideMetadata, "PlotData", plotData, ...
    "AllowSotaBeforePhysical", true), ...
    "ProjectName_utils:plotting:MissingOverrideReason");
assert_no_bundle_files(overrideDir, "FigOverride");

overrideReason = "The figure plan records an approved preliminary comparison.";
fig = make_test_figure();
overrideOutputs = ProjectName_utils.plotting.save_figure(fig, overrideDir, ...
    "FigOverride", ...
    "Metadata", overrideMetadata, ...
    "PlotData", plotData, ...
    "AllowSotaBeforePhysical", true, ...
    "OverrideReason", overrideReason);
assert_complete_bundle(overrideOutputs);
overrideRow = last_manifest_row(overrideOutputs.manifestFile);
assert(overrideRow.allowSotaBeforePhysical, ...
    "The manifest should record that the narrative override was enabled.");
assert(overrideRow.narrativeOverrideUsed, ...
    "The manifest should record that the narrative override was used.");
assert(string(overrideRow.overrideReason) == overrideReason, ...
    "The manifest should preserve the explicit override reason.");
reportText = string(fileread(char(overrideOutputs.checkReportFile)));
assert(contains(reportText, overrideReason), ...
    "The check report should preserve the explicit override reason.");

clear testCleanup
end

function metadata = base_metadata(claimId)
metadata = struct( ...
    "figNo", "FigContractPhysical", ...
    "contractVersion", "2026.07.12", ...
    "figurePlanId", "FP-SMOKE-CONTRACT", ...
    "claimId", string(claimId), ...
    "sciQuestion", "Does the figure export preserve its evidence contract?", ...
    "physicsReproduction", "The plotted values reproduce a declared test reference.", ...
    "evidenceRole", "physical-reproduction", ...
    "dataFiles", "generated in tests/smoke_figure_contracts.m", ...
    "dataDescription", "sampleIndex is unitless; metricPu is per-unit.", ...
    "visualEncoding", ProjectName_utils.plotting.methodStyle(), ...
    "targetLayout", "single-column", ...
    "command", "tests/smoke_figure_contracts", ...
    "keyParams", struct("profile", "ieee"), ...
    "randomSeed", "not_applicable");
end

function fig = make_test_figure()
fig = ProjectName_utils.plotting.create_figure("single-column", ...
    "Profile", "ieee", "AspectRatio", 0.65);
ax = axes(fig);
plot(ax, 1:4, [1.0, 1.4, 1.8, 2.1], "-o");
xlabel(ax, "Sample index");
ylabel(ax, "Metric (p.u.)");
end

function assert_throws(action, expectedIdentifier)
didThrow = false;
try
    action();
catch cause
    didThrow = true;
    assert(string(cause.identifier) == string(expectedIdentifier), ...
        "Expected error '%s', received '%s': %s", ...
        expectedIdentifier, cause.identifier, cause.message);
end
assert(didThrow, "Expected error '%s' was not raised.", expectedIdentifier);
end

function assert_complete_bundle(outputs)
assert(exist(char(outputs.figFile), "file") == 2, "FIG export is missing.");
assert(exist(char(outputs.pngFile), "file") == 2, "PNG export is missing.");
assert(exist(char(outputs.svgFile), "file") == 2, "SVG export is missing.");
assert(exist(char(outputs.plotDataFile), "file") == 2, "Plot-data CSV export is missing.");
assert(any(endsWith(outputs.extraFiles, ".pdf")), "Default IEEE PDF export is missing.");
assert(exist(char(outputs.manifestFile), "file") == 2, "Figure manifest is missing.");
assert(exist(char(outputs.checkReportFile), "file") == 2, "Figure check report is missing.");
end

function assert_no_bundle_files(outDir, figName)
assert_no_figure_artifacts(outDir, figName);
assert(exist(char(fullfile(outDir, "figure_manifest.jsonl")), "file") ~= 2, ...
    "A rejected figure must not create a manifest.");
assert(exist(char(fullfile(outDir, "figure_check_report.md")), "file") ~= 2, ...
    "A rejected figure must not create a check report.");
end

function assert_no_figure_artifacts(outDir, figName)
extensions = [".fig", ".png", ".svg", ".pdf", ".eps", ".tiff"];
for k = 1:numel(extensions)
    artifact = fullfile(outDir, figName + extensions(k));
    assert(exist(char(artifact), "file") ~= 2, ...
        "Rejected figure left an artifact: %s", artifact);
end
plotDataFile = fullfile(outDir, figName + "_plot_data.csv");
assert(exist(char(plotDataFile), "file") ~= 2, ...
    "Rejected figure left plot data: %s", plotDataFile);
end

function row = last_manifest_row(manifestFile)
lines = splitlines(string(fileread(char(manifestFile))));
lines = lines(strlength(strtrim(lines)) > 0);
row = jsondecode(char(lines(end)));
end

function rows = read_manifest_rows(manifestFile)
lines = splitlines(string(fileread(char(manifestFile))));
lines = lines(strlength(strtrim(lines)) > 0);
rows = cell(numel(lines), 1);
for k = 1:numel(lines)
    rows{k} = jsondecode(char(lines(k)));
end
end

function row = manifest_row_by_name(rows, figName)
matched = false(numel(rows), 1);
for k = 1:numel(rows)
    matched(k) = isfield(rows{k}, "figName") && ...
        string(rows{k}.figName) == string(figName);
end
assert(sum(matched) == 1, ...
    "Expected one current manifest row for figure %s.", figName);
row = rows{find(matched, 1, 'first')};
end

function strip_trailing_line_breaks(filePath)
bytes = read_file_bytes(filePath);
while ~isempty(bytes) && ismember(bytes(end), uint8([10, 13]))
    bytes(end) = [];
end
fid = fopen(char(filePath), 'wb');
assert(fid >= 0, "Could not rewrite file boundary for test: %s", filePath);
cleanup = onCleanup(@() fclose(fid));
fwrite(fid, bytes, 'uint8');
clear cleanup
end

function tf = file_ends_with_line_break(filePath)
bytes = read_file_bytes(filePath);
tf = ~isempty(bytes) && ismember(bytes(end), uint8([10, 13]));
end

function bytes = read_file_bytes(filePath)
fid = fopen(char(filePath), 'rb');
assert(fid >= 0, "Could not read test file: %s", filePath);
cleanup = onCleanup(@() fclose(fid));
bytes = fread(fid, Inf, '*uint8');
clear cleanup
end

function write_test_lock(lockPath, token, timestamp)
if exist(char(lockPath), "dir") ~= 7
    [created, message] = mkdir(char(lockPath));
    assert(created, "Could not create test lock %s: %s", lockPath, message);
end
ownerFile = fullfile(lockPath, "owner.txt");
fid = fopen(char(ownerFile), 'w', 'n', 'UTF-8');
assert(fid >= 0, "Could not write test lock owner: %s", ownerFile);
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, "%s\n%.17g\n", token, timestamp);
clear cleanup
end

function timestamp = current_posix_time()
timestamp = posixtime(datetime("now", "TimeZone", "UTC"));
end

function remove_test_directory(testRoot)
if exist(char(testRoot), "dir") == 7
    rmdir(char(testRoot), "s");
end
end

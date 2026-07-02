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
    options.ManifestFile = ""
    options.CheckReportFile = ""
    options.CloseFigure (1,1) logical = true
    options.ExtraFormats string = strings(1, 0)
    options.FigureProfile (1,1) string = "ieee"
    options.ApplyProfileSize (1,1) logical = true
    options.FontSizePt (1,1) double = NaN
    options.UseProfileExtraFormats (1,1) logical = true
end

if isempty(figHandle)
    figHandle = gcf;
end
if strlength(string(outDirOrBase)) == 0
    error("ProjectName_utils:plotting:MissingOutput", ...
        "Output directory or base file path is required.");
end

[outDir, figName] = resolve_output_target(outDirOrBase, figName);
ProjectName_utils.io.ensure_dir(outDir);

targetLayout = metadata_target_layout(options.Metadata);
[fontName, profile] = ProjectName_utils.plotting.apply_figure_profile(figHandle, ...
    "Profile", options.FigureProfile, ...
    "TargetLayout", targetLayout, ...
    "ApplySize", options.ApplyProfileSize, ...
    "FontSizePt", options.FontSizePt);
enforce_single_formal_axes(figHandle, options.IsDiagnostic);
drawnow;

outputs = struct();
outputs.outDir = outDir;
outputs.figName = figName;
outputs.figFile = fullfile(outDir, figName + ".fig");
outputs.pngFile = fullfile(outDir, figName + ".png");
outputs.svgFile = fullfile(outDir, figName + ".svg");
outputs.plotDataFile = "";
outputs.manifestFile = resolve_optional_path(options.ManifestFile, outDir, "figure_manifest.jsonl");
outputs.checkReportFile = resolve_optional_path(options.CheckReportFile, outDir, "figure_check_report.md");
outputs.extraFiles = strings(1, 0);
if ~isempty(options.PlotData)
    outputs.plotDataFile = fullfile(outDir, figName + "_plot_data.csv");
end

savefig(figHandle, char(outputs.figFile));

dpi = profile.previewDpi;
if options.IsDiagnostic
    dpi = profile.diagnosticDpi;
end
exportgraphics(figHandle, char(outputs.pngFile), "Resolution", dpi);

try
    exportgraphics(figHandle, char(outputs.svgFile), "ContentType", "vector");
catch
    print(figHandle, char(outputs.svgFile), "-dsvg");
end

if strlength(outputs.plotDataFile) > 0
    write_plot_data(options.PlotData, outputs.plotDataFile);
end

extraFormats = resolve_extra_formats(options.ExtraFormats, profile, options.UseProfileExtraFormats);
outputs.extraFiles = export_extra_formats(figHandle, outDir, figName, extraFormats, dpi);
manifest = build_manifest(figHandle, figName, fontName, profile, options, outputs);
narrativeOk = enforce_evidence_narrative(outputs.manifestFile, manifest, options.AllowSotaBeforePhysical);
append_jsonl(outputs.manifestFile, manifest);

checks = run_quality_checks(outputs, manifest, narrativeOk);
write_check_report(outputs.checkReportFile, figName, checks);
outputs.checks = checks;

if options.CloseFigure && isvalid(figHandle)
    close(figHandle);
end
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
[parentDir, ~, ~] = fileparts(filePath);
if strlength(string(parentDir)) > 0
    ProjectName_utils.io.ensure_dir(parentDir);
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
metadata.timestamp = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));
metadata.outputFiles = struct( ...
    "fig", outputs.figFile, ...
    "png", outputs.pngFile, ...
    "svg", outputs.svgFile, ...
    "plotData", outputs.plotDataFile, ...
    "extra", outputs.extraFiles);

if strlength(string(options.Script)) > 0
    metadata.script = string(options.Script);
end
if strlength(string(options.Command)) > 0
    metadata.command = string(options.Command);
end

requiredFields = ["claimId", "sciQuestion", "physicsReproduction", "evidenceRole", ...
    "dataFiles", "dataDescription", ...
    "visualEncoding", "targetLayout", "command", "keyParams", "randomSeed"];
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

if ~options.IsDiagnostic
    validRoles = canonical_evidence_roles();
    role = string(metadata.evidenceRole);
    if ~ismember(role, validRoles)
        error("ProjectName_utils:plotting:InvalidEvidenceRole", ...
            "evidenceRole '%s' is not allowed. Formal figures must use one of: %s. See .cursor/rules/04-case-figure-and-metric-plan.mdc and 01_IDEA/figure_plan.md.", ...
            role, strjoin(validRoles, ", "));
    end
end

manifest = orderfields(metadata);
end

function value = infer_caller_script()
stack = dbstack("-completenames");
if numel(stack) >= 3
    value = string(stack(3).file);
elseif numel(stack) >= 2
    value = string(stack(2).file);
else
    value = "";
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
    tf = all(strlength(string(value)) == 0);
elseif isstruct(value)
    tf = isempty(fieldnames(value));
else
    tf = false;
end
end

function summary = summarize_colormap(figHandle)
try
    cmap = figHandle.Colormap;
    summary = sprintf("figure colormap, %d rows", size(cmap, 1));
catch
    summary = "not_available";
end
end

function append_jsonl(manifestFile, manifest)
fid = fopen(char(manifestFile), "a");
if fid < 0
    error("ProjectName_utils:plotting:ManifestOpenFailed", ...
        "Could not open manifest file: %s", manifestFile);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, "%s\n", jsonencode(manifest));
end

function roles = canonical_evidence_roles()
roles = ["scenario-setup", "physical-reproduction", "sota-comparison", ...
    "sensitivity-ablation"];
end

function narrativeOk = enforce_evidence_narrative(manifestFile, manifest, allowSotaBeforePhysical)
narrativeOk = true;
if manifest.isDiagnostic
    return
end
role = string(manifest.evidenceRole);
if ~ismember(role, ["sota-comparison", "sensitivity-ablation"])
    return
end

claimId = string(manifest.claimId);
existing = read_existing_manifest(manifestFile);
hasPhysical = false;
for k = 1:numel(existing)
    if existing(k).evidenceRole ~= "physical-reproduction"
        continue
    end
    if strlength(claimId) == 0 || existing(k).claimId == "" || existing(k).claimId == claimId
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
end
end

function info = read_existing_manifest(manifestFile)
info = struct("evidenceRole", {}, "claimId", {});
if exist(char(manifestFile), "file") ~= 2
    return
end
lines = splitlines(string(fileread(char(manifestFile))));
lines = lines(strlength(strtrim(lines)) > 0);
for k = 1:numel(lines)
    try
        row = jsondecode(char(lines(k)));
    catch
        continue
    end
    role = "";
    if isfield(row, "evidenceRole")
        role = string(row.evidenceRole);
    end
    claim = "";
    if isfield(row, "claimId")
        claim = string(row.claimId);
    end
    info(end + 1) = struct("evidenceRole", role, "claimId", claim); %#ok<AGROW>
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
checks.claimBound = isfield(manifest, "claimId") && ~is_blank(manifest.claimId);
checks.evidenceNarrativeOrdered = narrativeOk;
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
    "timestamp"];
tf = true;
for k = 1:numel(requiredFields)
    fieldName = requiredFields(k);
    tf = tf && isfield(manifest, fieldName);
end
end

function write_check_report(reportFile, figName, checks)
fid = fopen(char(reportFile), "a");
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
fprintf(fid, "| Figure bound to a claim id | %s |\n", status_text(checks.claimBound));
fprintf(fid, "| Evidence-role narrative ordered (physical reproduction before SOTA/sensitivity) | %s |\n", status_text(checks.evidenceNarrativeOrdered));
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
end

function text = status_text(tf)
if tf
    text = "PASS";
else
    text = "FAIL";
end
end

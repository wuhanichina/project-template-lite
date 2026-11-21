function projectSummary = ProjectName(paperId)
%% ProjectName
% Project-level entry for registered case workflows and cross-case outputs.
%
% This root entry keeps project-level orchestration small. The case entries
% run case-specific formal workflows, and package functions handle reusable
% computation, result export, and plotting logic.

arguments
    paperId (1,1) string = ""
end

projectRoot = fileparts(mfilename("fullpath"));
addpath(projectRoot);
[resultDir, paperId] = ProjectName_utils.workflow.resolve_paper_result_dir(projectRoot, paperId);
caseListFile = fullfile(projectRoot, "02_PAPER", paperId, "config", "case_list.json");
caseEntries = load_case_entries(caseListFile, projectRoot, string(mfilename) + "_case");

fprintf("Running cases for %s\n", paperId);
fprintf("Project root: %s\n", projectRoot);

caseSummaries = repmat(ProjectName_utils.workflow.empty_run_summary(), 1, numel(caseEntries));
for caseIdx = 1:numel(caseEntries)
    caseSummaries(caseIdx) = feval(caseEntries{caseIdx}, projectRoot, paperId);
end

projectConfig = struct();
projectConfig.projectRoot = string(projectRoot);
projectConfig.resultDir = resultDir;
projectConfig.figureDir = fullfile(projectConfig.resultDir, "project", "figures");
projectConfig.summaryFile = fullfile(projectConfig.resultDir, "project_summary.txt");
projectConfig.caseNames = [caseSummaries.caseName];
projectConfig.workflowStatus = "scaffold";

ProjectName_utils.io.ensure_dir(projectConfig.resultDir);
projectFigureOutputs = ProjectName_utils.plotting.export_project_figures(projectConfig, caseSummaries);

projectSummary = struct();
projectSummary.project = "ProjectName";
projectSummary.paperId = paperId;
projectSummary.status = "scaffold";
projectSummary.caseEntries = string(caseEntries(:).');
projectSummary.caseNames = projectConfig.caseNames;
projectSummary.caseSummaryFiles = [caseSummaries.summaryFile];
projectSummary.caseRunManifestFiles = [caseSummaries.runManifestFile];
projectSummary.projectFigureStatus = projectFigureOutputs.status;
projectSummary.projectFigureDir = projectFigureOutputs.figureDir;
projectSummary.summaryFile = string(projectConfig.summaryFile);
projectSummary.completedAt = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));

ProjectName_utils.io.write_summary(projectConfig.summaryFile, projectSummary);

fprintf("Project summary: %s\n", projectConfig.summaryFile);
fprintf("Project-level figures: %s\n", projectFigureOutputs.figureDir);
end

function caseEntries = load_case_entries(caseListFile, projectRoot, casePrefix)
% 在运行首个算例之前核对整份清单及入口文件。
assert(isfile(caseListFile), 'ProjectName:MissingCaseList', ...
    'Create the case list for this paper: %s.', caseListFile);
caseEntries = jsondecode(fileread(caseListFile));
assert(iscell(caseEntries) && isvector(caseEntries) && ~isempty(caseEntries) && ...
    all(cellfun(@ischar, caseEntries)), ...
    'ProjectName:InvalidCaseList', ...
    'List at least one case function name in a JSON array in %s.', caseListFile);
assert(numel(unique(lower(string(caseEntries)))) == numel(caseEntries), ...
    'ProjectName:DuplicateCaseEntry', 'Case function names repeat in %s.', caseListFile);

for caseIdx = 1:numel(caseEntries)
    entryName = caseEntries{caseIdx};
    assert(isvarname(entryName) && startsWith(entryName, casePrefix) && ...
        strlength(entryName) > strlength(casePrefix), ...
        'ProjectName:InvalidCaseEntry', 'Invalid case function name "%s" in %s.', ...
        entryName, caseListFile);
    entryPath = fullfile(projectRoot, string(entryName) + ".m");
    resolvedPath = which(entryName);
    if ispc
        matchesEntryPath = strcmpi(resolvedPath, entryPath);
    else
        matchesEntryPath = strcmp(resolvedPath, entryPath);
    end
    assert(matchesEntryPath, 'ProjectName:UnresolvedCaseEntry', ...
        'Case function "%s" listed in %s must resolve to %s. MATLAB resolved "%s".', ...
        entryName, caseListFile, entryPath, resolvedPath);
end
end

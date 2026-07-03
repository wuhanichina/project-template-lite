function projectSummary = ProjectName()
%% ProjectName
% Project-level entry for registered case workflows and cross-case outputs.
%
% This root entry keeps project-level orchestration small. The case entries
% run case-specific formal workflows, and package functions handle reusable
% computation, result export, and plotting logic.

projectRoot = fileparts(mfilename("fullpath"));
addpath(projectRoot);

fprintf("Running ProjectName project workflow\n");
fprintf("Project root: %s\n", projectRoot);

% Registered case entries. Add a new case by appending its entry handle here.
caseEntries = {@ProjectName_case33bw, @ProjectName_case123};

caseSummaries = repmat(ProjectName_utils.workflow.empty_run_summary(), 1, numel(caseEntries));
for caseIdx = 1:numel(caseEntries)
    caseSummaries(caseIdx) = caseEntries{caseIdx}();
end

projectConfig = struct();
projectConfig.projectRoot = string(projectRoot);
projectConfig.resultDir = fullfile(projectRoot, "result");
projectConfig.figureDir = fullfile(projectConfig.resultDir, "project", "figures");
projectConfig.summaryFile = fullfile(projectConfig.resultDir, "project_summary.txt");
projectConfig.caseNames = [caseSummaries.caseName];
projectConfig.workflowStatus = "scaffold";

ProjectName_utils.io.ensure_dir(projectConfig.resultDir);
projectFigureOutputs = ProjectName_utils.plotting.export_project_figures(projectConfig, caseSummaries);

projectSummary = struct();
projectSummary.project = "ProjectName";
projectSummary.status = "scaffold";
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
fprintf("Done. Check result/case33bw, result/case123, and result/project_summary.txt.\n");
end

function projectSummary = ProjectName()
%% ProjectName
% Project-level entry for registered case workflows and cross-case outputs.
%
% This root entry keeps project-level orchestration small. The case entries
% run case-specific formal workflows, and package functions handle reusable
% computation, result export, and plotting logic.

projectRoot = fileparts(mfilename("fullpath"));
cd(projectRoot);

fprintf("Running ProjectName project workflow\n");
fprintf("Project root: %s\n", projectRoot);

caseSummaries = repmat(ProjectName_utils.workflow.empty_run_summary(), 1, 2);
caseSummaries(1) = ProjectName_case33bw();
caseSummaries(2) = ProjectName_case123();

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
projectSummary.projectFigureStatus = projectFigureOutputs.status;
projectSummary.projectFigureDir = projectFigureOutputs.figureDir;
projectSummary.summaryFile = string(projectConfig.summaryFile);
projectSummary.completedAt = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));

ProjectName_utils.io.write_summary(projectConfig.summaryFile, projectSummary);

fprintf("Project summary: %s\n", projectConfig.summaryFile);
fprintf("Project-level figures: %s\n", projectFigureOutputs.figureDir);
fprintf("Done. Check result/case33bw, result/case123, and result/project_summary.txt.\n");
end

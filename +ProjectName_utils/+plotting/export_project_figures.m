function projectFigureOutputs = export_project_figures(projectConfig, caseSummaries)
%EXPORT_PROJECT_FIGURES Scaffold for cross-case project figures.

ProjectName_utils.io.ensure_dir(projectConfig.figureDir);

projectFigureOutputs = struct();
projectFigureOutputs.status = "scaffold";
projectFigureOutputs.figureDir = string(projectConfig.figureDir);
projectFigureOutputs.caseNames = [caseSummaries.caseName];
projectFigureOutputs.files = strings(0, 1);
projectFigureOutputs.warnings = "No cross-case figures are exported by the template scaffold.";
end

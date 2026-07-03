function outputFiles = write_case_outputs(caseConfig, caseData, proposedResults, baselineResults, metrics)
%WRITE_CASE_OUTPUTS Write scaffold case summary and reserve manifest path.

summaryFile = fullfile(caseConfig.resultDir, "summary.txt");
manifestFile = fullfile(caseConfig.resultDir, "run_manifest.json");

summary = struct();
summary.case = string(caseConfig.name);
summary.network = string(caseConfig.network);
summary.description = string(caseConfig.description);
summary.claim = string(caseConfig.claim);
summary.evidenceId = string(caseConfig.evidenceId);
summary.status = "scaffold";
summary.dataStatus = string(caseData.status);
summary.proposedStatus = string(proposedResults.status);
summary.baselineStatus = string(baselineResults.status);
summary.metricsStatus = string(metrics.status);
summary.figureDir = string(caseConfig.figureDir);
summary.message = "Package skeleton ran. Fill package functions with real computation before using this case as paper evidence.";

ProjectName_utils.io.write_summary(summaryFile, summary);

outputFiles = struct();
outputFiles.summaryFile = string(summaryFile);
outputFiles.manifestFile = string(manifestFile);
outputFiles.status = "scaffold";
outputFiles.files = string(summaryFile);
outputFiles.warnings = strings(0, 1);
end

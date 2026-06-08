function runSummary = finalize_case_run(caseConfig, runState, caseData, proposedResults, ...
        baselineResults, metrics, outputFiles, figureOutputs)
%FINALIZE_CASE_RUN Build the case-level run summary returned by root entries.

runSummary = ProjectName_utils.workflow.empty_run_summary();
runSummary.caseName = string(caseConfig.name);
runSummary.status = "scaffold";
runSummary.claim = string(caseConfig.claim);
runSummary.evidenceId = string(caseConfig.evidenceId);
runSummary.startedAt = string(runState.startedAt);
runSummary.completedAt = string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss"));
runSummary.resultDir = string(caseConfig.resultDir);
runSummary.figureDir = string(caseConfig.figureDir);
runSummary.summaryFile = string(outputFiles.summaryFile);
runSummary.manifestFile = string(outputFiles.manifestFile);
runSummary.inputStatus = string(caseData.status);
runSummary.proposedStatus = string(proposedResults.status);
runSummary.baselineStatus = string(baselineResults.status);
runSummary.metricsStatus = string(metrics.status);
runSummary.figureStatus = string(figureOutputs.status);
runSummary.message = "Scaffold workflow completed. Replace package skeletons with project computation before claiming paper evidence.";
end

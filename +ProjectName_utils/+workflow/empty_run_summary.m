function runSummary = empty_run_summary()
%EMPTY_RUN_SUMMARY Return the canonical shape for case run summaries.

runSummary = struct();
runSummary.caseName = "";
runSummary.status = "";
runSummary.claim = "";
runSummary.evidenceId = "";
runSummary.startedAt = "";
runSummary.completedAt = "";
runSummary.resultDir = "";
runSummary.figureDir = "";
runSummary.summaryFile = "";
runSummary.manifestFile = "";
runSummary.runManifestFile = "";
runSummary.inputStatus = "";
runSummary.proposedStatus = "";
runSummary.baselineStatus = "";
runSummary.metricsStatus = "";
runSummary.figureStatus = "";
runSummary.message = "";
end

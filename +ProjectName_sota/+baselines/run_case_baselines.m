function baselineResults = run_case_baselines(caseConfig, caseData, proposedResults)
%RUN_CASE_BASELINES Scaffold for registered SOTA and baseline computations.

baselineResults = struct();
baselineResults.caseName = string(caseConfig.name);
baselineResults.status = "scaffold";
baselineResults.inputStatus = string(caseData.status);
baselineResults.proposedStatus = string(proposedResults.status);
baselineResults.baselines = strings(0, 1);
baselineResults.files = struct();
baselineResults.warnings = "Replace +ProjectName_sota/+baselines/run_case_baselines.m with baseline computations.";
end

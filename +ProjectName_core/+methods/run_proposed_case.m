function proposedResults = run_proposed_case(caseConfig, caseData)
%RUN_PROPOSED_CASE Scaffold for the proposed-method case computation.

proposedResults = struct();
proposedResults.caseName = string(caseConfig.name);
proposedResults.status = "scaffold";
proposedResults.method = "proposed";
proposedResults.inputStatus = string(caseData.status);
proposedResults.files = struct();
proposedResults.warnings = "Replace +ProjectName_core/+methods/run_proposed_case.m with the project method.";
end

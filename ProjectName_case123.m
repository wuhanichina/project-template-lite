function runSummary = ProjectName_case123()
%% ProjectName_case123
% Formal case workflow for the case123 network.
%
% This root entry orchestrates the full case123 formal workflow. Package
% functions implement data loading, proposed-method computation, baselines,
% metrics, output writing, and figure export.
%
% Workflow steps:
% 1. Define case configuration.
% 2. Prepare directories, seed, and run state.
% 3. Load and validate data inputs.
% 4. Run the proposed method.
% 5. Run SOTA or baseline methods.
% 6. Evaluate case metrics.
% 7. Write tables, summary, and run manifest.
% 8. Export formal case figures.
% 9. Finalize the run and report evidence registration status.

projectRoot = fileparts(mfilename("fullpath"));

caseConfig = local_case_config(projectRoot);
tracker = ProjectName_utils.workflow.create_step_tracker(9, caseConfig.name);
trackerCleanup = onCleanup(@() tracker.close());

tracker.update(1, "Define case configuration");

tracker.update(2, "Prepare directories, seed, and run state");
runState = ProjectName_utils.workflow.prepare_case_run(caseConfig);

tracker.update(3, "Load and validate data inputs");
caseData = ProjectName_utils.io.load_case_inputs(caseConfig);

tracker.update(4, "Run the proposed method");
proposedResults = ProjectName_core.methods.run_proposed_case(caseConfig, caseData);

tracker.update(5, "Run SOTA or baseline methods");
baselineResults = ProjectName_sota.baselines.run_case_baselines(caseConfig, caseData, proposedResults);

tracker.update(6, "Evaluate case metrics");
metrics = ProjectName_core.metrics.evaluate_case_metrics(caseConfig, proposedResults, baselineResults);

tracker.update(7, "Write tables, summary, and run manifest");
outputFiles = ProjectName_utils.io.write_case_outputs( ...
    caseConfig, caseData, proposedResults, baselineResults, metrics);

tracker.update(8, "Export formal case figures");
figureOutputs = ProjectName_utils.plotting.export_case_figures(caseConfig, metrics);

tracker.update(9, "Finalize run and report evidence registration status");
runSummary = ProjectName_utils.workflow.finalize_case_run( ...
    caseConfig, runState, caseData, proposedResults, baselineResults, ...
    metrics, outputFiles, figureOutputs);

tracker.close();
clear trackerCleanup

fprintf("Evidence reminder: register %s in 01_IDEA/evidence_map.md when results become formal.\n", ...
    caseConfig.evidenceId);
end

function caseConfig = local_case_config(projectRoot)
caseConfig = struct();
caseConfig.projectRoot = string(projectRoot);
caseConfig.name = "case123";
caseConfig.network = "case123";
caseConfig.description = "Proposed method and registered baselines on the case123 network";
caseConfig.seed = 123;
caseConfig.dataDir = fullfile(projectRoot, "data");
caseConfig.cacheDir = fullfile(projectRoot, "cache", caseConfig.name);
caseConfig.resultDir = fullfile(projectRoot, "result", caseConfig.name);
caseConfig.figureDir = fullfile(caseConfig.resultDir, "figures");
caseConfig.claim = "C2";
caseConfig.evidenceId = "E02";
caseConfig.optimizerPriority = ["cvx_mosek", "gurobi", "mosek_direct"];
caseConfig.showTaskWaitbar = usejava("desktop");
caseConfig.workflowStatus = "scaffold";
end

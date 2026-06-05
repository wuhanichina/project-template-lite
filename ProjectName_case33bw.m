%% ProjectName_case33bw
% Proposed-method entry for the case33bw network.
% Keep this file as the readable map from the case33bw evidence claim to code.

clear; clc;

projectRoot = fileparts(mfilename('fullpath'));

caseConfig = struct();
caseConfig.name = "case33bw";
caseConfig.network = "case33bw";
caseConfig.description = "Proposed method on the case33bw network";
caseConfig.seed = 33;
caseConfig.dataDir = fullfile(projectRoot, "data");
caseConfig.cacheDir = fullfile(projectRoot, "cache", caseConfig.name);
caseConfig.resultDir = fullfile(projectRoot, "result", caseConfig.name);
caseConfig.figureDir = fullfile(caseConfig.resultDir, "figures");
caseConfig.claim = "C1";
caseConfig.evidenceId = "E01";
caseConfig.optimizerPriority = ["cvx_mosek", "gurobi", "mosek_direct"];

ProjectName_utils.mc.init_seed(caseConfig.seed);
ProjectName_utils.io.ensure_dir(caseConfig.cacheDir);
ProjectName_utils.io.ensure_dir(caseConfig.resultDir);
ProjectName_utils.io.ensure_dir(caseConfig.figureDir);

fprintf("Running %s\n", caseConfig.name);
fprintf("Result directory: %s\n", caseConfig.resultDir);
fprintf("Figure directory: %s\n", caseConfig.figureDir);

% TODO: replace this minimal scaffold with the actual case33bw workflow.
% Suggested order:
% 1. load all formal case33bw input data from data/
% 2. call +ProjectName_core functions to build the proposed-method model
% 3. solve the model and cache reusable intermediate artifacts under cache/case33bw
%    cache misses should trigger recomputation from data/, not a missing-input failure
% 4. export tables under result/case33bw and formal figures under
%    result/case33bw/figures with ProjectName_utils.plotting.save_figure.
%    Formal figure metadata must include the scientific question, data files,
%    field/unit/dimension description, visual encoding, target layout, command,
%    key parameters, and random seed/status.
% 5. register the formal result in 01_IDEA/evidence_map.md

summaryFile = fullfile(caseConfig.resultDir, "summary.txt");
summary = struct();
summary.case = caseConfig.name;
summary.network = caseConfig.network;
summary.description = caseConfig.description;
summary.claim = caseConfig.claim;
summary.evidenceId = caseConfig.evidenceId;
summary.figureDir = caseConfig.figureDir;
summary.status = "scaffold only; fill in the actual case33bw computation.";
ProjectName_utils.io.write_summary(summaryFile, summary);

fprintf("Done. Wrote %s\n", summaryFile);

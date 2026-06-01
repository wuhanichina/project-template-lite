%% ProjectName_case123
% Proposed-method entry for the case123 network.
% Use this case to test whether the method scales beyond the smaller feeder.

clear; clc;

projectRoot = fileparts(mfilename('fullpath'));

caseConfig = struct();
caseConfig.name = "case123";
caseConfig.network = "case123";
caseConfig.description = "Proposed method on the case123 network";
caseConfig.seed = 123;
caseConfig.dataDir = fullfile(projectRoot, "data");
caseConfig.cacheDir = fullfile(projectRoot, "cache", caseConfig.name);
caseConfig.resultDir = fullfile(projectRoot, "result", caseConfig.name);
caseConfig.figureDir = fullfile(caseConfig.resultDir, "figures");
caseConfig.claim = "C2";
caseConfig.evidenceId = "E02";
caseConfig.optimizerPriority = ["cvx_mosek", "gurobi", "mosek_direct"];

ProjectName_utils.mc.init_seed(caseConfig.seed);
ProjectName_utils.io.ensure_dir(caseConfig.cacheDir);
ProjectName_utils.io.ensure_dir(caseConfig.resultDir);
ProjectName_utils.io.ensure_dir(caseConfig.figureDir);

fprintf("Running %s\n", caseConfig.name);
fprintf("Result directory: %s\n", caseConfig.resultDir);
fprintf("Figure directory: %s\n", caseConfig.figureDir);

% TODO: replace this minimal scaffold with the actual case123 workflow.
% Suggested order:
% 1. load case123 input data from data/
% 2. call +ProjectName_core functions to build the proposed-method model
% 3. solve the model and cache reusable intermediate artifacts under cache/case123
% 4. export tables under result/case123 and formal figures under
%    result/case123/figures with ProjectName_utils.plotting.save_figure
% 5. register the formal result in 01_IDEA/evidence_map.md

summaryFile = fullfile(caseConfig.resultDir, "summary.txt");
summary = struct();
summary.case = caseConfig.name;
summary.network = caseConfig.network;
summary.description = caseConfig.description;
summary.claim = caseConfig.claim;
summary.evidenceId = caseConfig.evidenceId;
summary.figureDir = caseConfig.figureDir;
summary.status = "scaffold only; fill in the actual case123 computation.";
ProjectName_utils.io.write_summary(summaryFile, summary);

fprintf("Done. Wrote %s\n", summaryFile);

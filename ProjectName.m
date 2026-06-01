%% ProjectName
% Unified paper-facing entry.
% Run proposed-method cases and reserve the SOTA comparison hook used by paper figures.

clear; clc;

projectRoot = fileparts(mfilename('fullpath'));
cd(projectRoot);

fprintf("Running ProjectName unified entry\n");
fprintf("Project root: %s\n", projectRoot);

ProjectName_case33bw;
ProjectName_case123;

fprintf("SOTA comparison hook: add calls to +ProjectName_sota functions after the case outputs are ready.\n");
fprintf("Done. Check result/case33bw, result/case123, and each case's figures/ folder.\n");

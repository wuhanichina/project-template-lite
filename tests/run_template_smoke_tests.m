function run_template_smoke_tests()
%RUN_TEMPLATE_SMOKE_TESTS Run the complete template contract smoke suite.

projectRoot = fileparts(fileparts(mfilename("fullpath")));
addpath(projectRoot);
addpath(fullfile(projectRoot, "tests"));

smoke_figure_profile();
smoke_figure_contracts();
smoke_run_contracts();
smoke_handoff_contracts();

fprintf("TEMPLATE_SMOKE_TESTS_OK\n");
end

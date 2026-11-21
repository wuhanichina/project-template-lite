function [resultDir, paperId] = resolve_paper_result_dir(projectRoot, paperId)
%RESOLVE_PAPER_RESULT_DIR 根据论文目录名确定结果目录。

arguments
    projectRoot (1,1) string
    paperId (1,1) string = ""
end

if paperId == ""
    paperId = "01_voltage_violations";
end
assert(~ismissing(paperId) && ~isempty(regexp(char(paperId), ...
    '^[0-9]{2,}_[a-z][a-z0-9]*(?:_[a-z0-9]+)*$', 'once')), ...
    'ProjectName:InvalidPaperDirectory', 'Use a paper directory name such as 01_voltage_violations.');

paperDir = fullfile(projectRoot, "02_PAPER", paperId);
assert(isfolder(paperDir), 'ProjectName:MissingPaperDirectory', ...
    'Create the paper directory before running its cases: %s.', paperDir);
resultDir = fullfile(projectRoot, "result", paperId);
end

function write_summary(summaryFile, entries)
%WRITE_SUMMARY Write a simple key-value summary text file.

summaryFile = string(summaryFile);
[parentDir, ~, ~] = fileparts(summaryFile);
if strlength(parentDir) > 0
    ProjectName_utils.io.ensure_dir(parentDir);
end

fid = fopen(summaryFile, "w");
if fid < 0
    error("ProjectName_utils:io:OpenFailed", "Could not open summary file: %s", summaryFile);
end

cleanupObj = onCleanup(@() fclose(fid));
fields = fieldnames(entries);
for k = 1:numel(fields)
    key = fields{k};
    value = local_format_value(entries.(key));
    fprintf(fid, "%s: %s\n", key, value);
end
end

function valueText = local_format_value(value)
if isstring(value)
    valueText = strjoin(value, ", ");
elseif ischar(value)
    valueText = string(value);
elseif isnumeric(value) || islogical(value)
    valueText = string(mat2str(value));
elseif iscellstr(value)
    valueText = strjoin(string(value), ", ");
else
    valueText = string(evalc("disp(value)"));
    valueText = strtrim(valueText);
end
end

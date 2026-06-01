function ensure_dir(dirPath)
%ENSURE_DIR Create a directory if it does not already exist.

dirPath = string(dirPath);
if strlength(dirPath) == 0
    error("ProjectName_utils:io:EmptyDir", "Directory path is empty.");
end

if ~exist(dirPath, "dir")
    mkdir(dirPath);
end
end

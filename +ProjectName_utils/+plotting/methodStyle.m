function s = methodStyle(name)
%METHODSTYLE Project-level visual encoding for paper figures.
%
% Replace the template method names before generating formal manuscript
% figures. Calling methodStyle() without an input returns the full registry.

registry = default_registry();

if nargin < 1 || isempty(name) || strlength(string(name)) == 0
    s = registry;
    return
end

key = char(lower(string(name)));
if isfield(registry, key)
    s = registry.(key);
else
    error("ProjectName_utils:plotting:UnknownMethodStyle", ...
        "Unregistered method style: %s. Add it to methodStyle before plotting.", name);
end
end

function registry = default_registry()
registry = struct();
registry.baseline = struct("color", [0 0 0], "ls", "-", "mk", "o");
registry.method1 = struct("color", [0.85 0.10 0.10], "ls", "-", "mk", "s");
registry.method2 = struct("color", [0.00 0.20 0.70], "ls", "--", "mk", "^");
registry.method3 = struct("color", [0.10 0.55 0.20], "ls", ":", "mk", "d");
registry.method4 = struct("color", [0.90 0.50 0.00], "ls", "-.", "mk", "x");
end

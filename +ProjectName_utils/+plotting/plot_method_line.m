function h = plot_method_line(ax, x, y, methodName, varargin)
%PLOT_METHOD_LINE Plot one method with global style and sparse markers.

if nargin < 1 || isempty(ax)
    ax = gca;
end
if nargin < 4 || strlength(string(methodName)) == 0
    error("ProjectName_utils:plotting:MissingMethod", ...
        "methodName is required and must be registered in methodStyle.");
end

s = ProjectName_utils.plotting.methodStyle(methodName);
displayName = string(methodName);
if isfield(s, "label") && strlength(string(s.label)) > 0
    displayName = string(s.label);
end
n = numel(x);
markerIndices = unique(round(linspace(1, n, min(30, n))));

h = plot(ax, x, y, ...
    "LineStyle", s.ls, ...
    "Color", s.color, ...
    "Marker", s.mk, ...
    "LineWidth", 1.8, ...
    varargin{:});

if ~has_name_value(varargin, "DisplayName")
    try
        set(h, "DisplayName", displayName);
    catch
    end
end

if n > 0
    for k = 1:numel(h)
        try
            h(k).MarkerIndices = markerIndices;
        catch
        end
    end
end
end

function tf = has_name_value(args, name)
tf = false;
for k = 1:2:numel(args)
    try
        if strcmpi(string(args{k}), name)
            tf = true;
            return
        end
    catch
    end
end
end

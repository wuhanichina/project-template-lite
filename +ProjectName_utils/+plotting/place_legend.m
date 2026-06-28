function legendHandle = place_legend(ax, options)
%PLACE_LEGEND Place a compact in-axes legend for formal paper figures.

arguments
    ax = []
    options.Location (1,1) string = "best"
    options.Box (1,1) string = "off"
    options.NumColumns (1,1) double {mustBeInteger, mustBePositive} = 1
    options.Orientation (1,1) string = "vertical"
    options.AutoUpdate (1,1) string = "off"
end

if isempty(ax)
    ax = gca;
end

location = normalize_location(options.Location);
legendHandle = legend(ax, "show", ...
    "Location", char(location), ...
    "Box", char(options.Box), ...
    "Interpreter", "none", ...
    "AutoUpdate", char(options.AutoUpdate));

try
    legendHandle.NumColumns = options.NumColumns;
catch
end
try
    legendHandle.Orientation = char(options.Orientation);
catch
end
end

function location = normalize_location(location)
location = lower(strrep(string(location), "_", ""));
if location == "auto"
    location = "best";
end
end

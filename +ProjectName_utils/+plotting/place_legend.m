function legendHandle = place_legend(ax, options)
%PLACE_LEGEND 创建无边框、透明背景的图例，优先放在图内空白区域。

arguments
    ax = []
    options.Location (1,1) string = "best"
    options.Box (1,1) string {mustBeMember(options.Box, "off")} = "off"
    options.NumColumns (1,1) double {mustBeReal, mustBeFinite, mustBeInteger, mustBePositive} = 1
    options.Orientation (1,1) string {mustBeMember(options.Orientation, ["vertical", "horizontal"])} = "vertical"
    options.AutoUpdate (1,1) string {mustBeMember(options.AutoUpdate, ["on", "off"])} = "off"
    options.FontSizePt (1,1) double {mustBeReal, mustBeFinite, mustBeGreaterThanOrEqual(options.FontSizePt, 8)} = 10
    options.FontName (1,1) string {mustBeMember(options.FontName, ["Times New Roman", "Microsoft YaHei"])} = "Times New Roman"
    options.Interpreter (1,1) string {mustBeMember(options.Interpreter, ["none", "tex"])} = "none"
end

if isempty(ax)
    ax = gca;
end

location = normalize_location(options.Location);
legendHandle = legend(ax, "show", ...
    "Location", char(location), ...
    "Box", char(options.Box), ...
    "Color", "none", ...
    "TextColor", [0 0 0], ...
    "FontSize", options.FontSizePt, ...
    "FontName", options.FontName, ...
    "Interpreter", options.Interpreter, ...
    "AutoUpdate", char(options.AutoUpdate));

legendHandle.NumColumns = options.NumColumns;
legendHandle.Orientation = char(options.Orientation);
end

function location = normalize_location(location)
location = lower(strrep(string(location), "_", ""));
if location == "auto"
    location = "best";
end
end

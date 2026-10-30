function [fontName, profile] = apply_figure_profile(figHandle, options)
%APPLY_FIGURE_PROFILE Apply journal profile defaults to an existing figure.

arguments
    figHandle = []
    options.Profile (1,1) string = "ieee"
    options.TargetLayout (1,1) string = ""
    options.ApplySize (1,1) logical = false
    options.FontSizePt (1,1) double {mustBeReal} = NaN
end

if isempty(figHandle)
    figHandle = gcf;
end

profile = ProjectName_utils.plotting.figure_profile(options.Profile);
profile.appliedFontSizePt = resolve_font_size(profile, options.FontSizePt);
fontName = choose_font(profile.fontCandidates);

ProjectName_utils.plotting.apply_white_background(figHandle);

if options.ApplySize && strlength(options.TargetLayout) > 0
    resize_figure(figHandle, profile, options.TargetLayout);
end

apply_font_defaults(figHandle, fontName, profile.appliedFontSizePt);
apply_axes_defaults(figHandle, profile);
apply_line_defaults(figHandle, profile);
apply_marker_defaults(figHandle, profile);
end

function fontSizePt = resolve_font_size(profile, requestedFontSizePt)
if isnan(requestedFontSizePt)
    fontSizePt = profile.fontSizePt;
elseif requestedFontSizePt < profile.minFontSizePt
    error("ProjectName_utils:plotting:FontTooSmall", ...
        "Formal figure font size %.1f pt is below the profile minimum %.1f pt.", ...
        requestedFontSizePt, profile.minFontSizePt);
elseif ~isfinite(requestedFontSizePt)
    error("ProjectName_utils:plotting:InvalidFontSize", ...
        "Requested font size must be finite; received %g.", requestedFontSizePt);
else
    fontSizePt = requestedFontSizePt;
end
end

function fontName = choose_font(fontCandidates)
availableFonts = string(listfonts());
for k = 1:numel(fontCandidates)
    candidate = string(fontCandidates(k));
    if any(strcmpi(availableFonts, candidate))
        fontName = candidate;
        return
    end
end
error("ProjectName_utils:plotting:MissingFont", ...
    "Required font %s is unavailable. Install it and check listfonts before exporting.", ...
    strjoin(fontCandidates, ", "));
end

function resize_figure(figHandle, profile, targetLayout)
widthCm = ProjectName_utils.plotting.resolve_figure_width( ...
    profile, targetLayout);

figHandle.Units = "centimeters";
pos = figHandle.Position;
if numel(pos) < 4 || pos(3) <= 0 || pos(4) <= 0
    aspectRatio = 0.72;
else
    aspectRatio = pos(4) / pos(3);
end
heightCm = min(widthCm * aspectRatio, profile.maxHeightCm);
figHandle.Position = [pos(1) pos(2) widthCm heightCm];
figHandle.PaperUnits = "centimeters";
figHandle.PaperPosition = [0 0 widthCm heightCm];
end

function apply_font_defaults(figHandle, fontName, fontSizePt)
fontObjects = findall(figHandle, "-property", "FontName");
availableFonts = string(listfonts());
for k = 1:numel(fontObjects)
    % 中文对象保留微软雅黑；混排文字由 TeX 分组指定各段字体。
    isChineseFont = strcmpi(string(fontObjects(k).FontName), "Microsoft YaHei");
    hasChineseWrapper = false;
    for textProperty = ["String", "XTickLabel", "YTickLabel", "ZTickLabel", "TickLabels"]
        if isprop(fontObjects(k), textProperty)
            hasChineseWrapper = hasChineseWrapper || any(contains( ...
                string(fontObjects(k).(textProperty)), ...
                "\fontname{Microsoft YaHei}"), "all");
        end
    end
    if isChineseFont || hasChineseWrapper
        assert(any(strcmpi(availableFonts, "Microsoft YaHei")), ...
            "ProjectName_utils:plotting:MissingChineseFont", ...
            "Microsoft YaHei is unavailable. Install it and check listfonts.");
    end
    if ~isChineseFont
        fontObjects(k).FontName = char(fontName);
    end
    if isprop(fontObjects(k), "FontSize")
        if isprop(fontObjects(k), "FontUnits")
            fontObjects(k).FontUnits = "points";
        end
        fontObjects(k).FontSize = fontSizePt;
    end
end
end

function apply_axes_defaults(figHandle, profile)
axesList = findall(figHandle, "Type", "axes");
for k = 1:numel(axesList)
    if ~isempty(findall(axesList(k), "Type", "line"))
        set(axesList(k), "XGrid", profile.lineGrid, "YGrid", profile.lineGrid, ...
            "XMinorGrid", "off", "YMinorGrid", "off");
    end
    try
        if axesList(k).LineWidth < profile.axisLineWidthPt
            axesList(k).LineWidth = profile.axisLineWidthPt;
        end
    catch
    end
    if profile.tickDir ~= "preserve"
        try
            axesList(k).TickDir = char(profile.tickDir);
        catch
        end
    end
end
end

function apply_line_defaults(figHandle, profile)
lineList = findall(figHandle, "Type", "line");
for k = 1:numel(lineList)
    try
        if lineList(k).LineWidth < profile.lineWidthPt
            lineList(k).LineWidth = profile.lineWidthPt;
        end
    catch
    end
end
end

function apply_marker_defaults(figHandle, profile)
markerObjects = findall(figHandle, "-property", "MarkerSize");
for k = 1:numel(markerObjects)
    try
        if markerObjects(k).MarkerSize < profile.markerSizePt
            markerObjects(k).MarkerSize = profile.markerSizePt;
        end
    catch
    end
end
end

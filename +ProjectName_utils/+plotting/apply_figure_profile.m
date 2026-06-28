function [fontName, profile] = apply_figure_profile(figHandle, options)
%APPLY_FIGURE_PROFILE Apply journal profile defaults to an existing figure.

arguments
    figHandle = []
    options.Profile (1,1) string = "ieee"
    options.TargetLayout (1,1) string = ""
    options.ApplySize (1,1) logical = false
    options.FontSizePt (1,1) double = NaN
end

if isempty(figHandle)
    figHandle = gcf;
end

profile = ProjectName_utils.plotting.figure_profile(options.Profile);
profile.appliedFontSizePt = resolve_font_size(profile, options.FontSizePt);
fontName = choose_font(profile.fontCandidates);

try
    figHandle.Visible = "off";
catch
end
try
    figHandle.Color = [1 1 1];
catch
end

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
else
    fontSizePt = requestedFontSizePt;
end
end

function fontName = choose_font(fontCandidates)
availableFonts = string(listfonts);
fontName = "";
for k = 1:numel(fontCandidates)
    candidate = string(fontCandidates(k));
    if any(strcmpi(availableFonts, candidate))
        fontName = candidate;
        return
    end
end
fontName = "Times";
warning("ProjectName_utils:plotting:FontFallback", ...
    "None of the profile fonts are available. Falling back to %s.", fontName);
end

function resize_figure(figHandle, profile, targetLayout)
layout = lower(strrep(string(targetLayout), "_", "-"));
switch layout
    case {"single-column", "single", "one-column"}
        widthCm = profile.singleColumnWidthCm;
    case {"double-column", "double", "two-column"}
        widthCm = profile.doubleColumnWidthCm;
    otherwise
        widthCm = parse_custom_width_cm(layout, []);
end
if isempty(widthCm)
    return
end
widthCm = min(widthCm, profile.maxWidthCm);

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

function widthCm = parse_custom_width_cm(layout, fallbackCm)
tokens = regexp(layout, "width-([0-9]+(\.[0-9]+)?)-cm", "tokens", "once");
if isempty(tokens)
    widthCm = fallbackCm;
else
    widthCm = str2double(tokens{1});
end
end

function apply_font_defaults(figHandle, fontName, fontSizePt)
fontObjects = findall(figHandle, "-property", "FontName");
for k = 1:numel(fontObjects)
    try
        fontObjects(k).FontName = char(fontName);
    catch
    end
    if isprop(fontObjects(k), "FontSize")
        try
            fontObjects(k).FontSize = fontSizePt;
        catch
        end
    end
end
end

function apply_axes_defaults(figHandle, profile)
axesList = findall(figHandle, "Type", "axes");
for k = 1:numel(axesList)
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

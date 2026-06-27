function fig = create_figure(targetLayout, options)
%CREATE_FIGURE Create an offscreen figure sized from a journal profile.

arguments
    targetLayout (1,1) string = "single-column"
    options.Profile (1,1) string = "ieee"
    options.AspectRatio (1,1) double {mustBePositive} = 0.72
    options.Visible (1,1) string = "off"
end

profile = ProjectName_utils.plotting.figure_profile(options.Profile);
[widthCm, heightCm] = target_size_cm(profile, targetLayout, options.AspectRatio);

fig = figure( ...
    "Color", "w", ...
    "Visible", options.Visible, ...
    "Units", "centimeters", ...
    "Position", [2 2 widthCm heightCm], ...
    "PaperUnits", "centimeters", ...
    "PaperPosition", [0 0 widthCm heightCm]);
end

function [widthCm, heightCm] = target_size_cm(profile, targetLayout, aspectRatio)
layout = lower(strrep(string(targetLayout), "_", "-"));
switch layout
    case {"single-column", "single", "one-column"}
        widthCm = profile.singleColumnWidthCm;
    case {"double-column", "double", "two-column"}
        widthCm = profile.doubleColumnWidthCm;
    otherwise
        widthCm = parse_custom_width_cm(layout, profile.singleColumnWidthCm);
end

heightCm = widthCm * aspectRatio;
heightCm = min(heightCm, profile.maxHeightCm);
end

function widthCm = parse_custom_width_cm(layout, fallbackCm)
tokens = regexp(layout, "width-([0-9]+(\.[0-9]+)?)-cm", "tokens", "once");
if isempty(tokens)
    widthCm = fallbackCm;
else
    widthCm = str2double(tokens{1});
end
end

function fig = create_figure(targetLayout, options)
%CREATE_FIGURE Create a visible-by-default figure from a journal profile.

arguments
    targetLayout (1,1) string = "single-column"
    options.Profile (1,1) string = "ieee"
    options.AspectRatio (1,1) double {mustBePositive} = 0.72
    options.Visible (1,1) string = "on"
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
ProjectName_utils.plotting.apply_white_background(fig);
end

function [widthCm, heightCm] = target_size_cm(profile, targetLayout, aspectRatio)
widthCm = ProjectName_utils.plotting.resolve_figure_width( ...
    profile, targetLayout);
heightCm = widthCm * aspectRatio;
heightCm = min(heightCm, profile.maxHeightCm);
end

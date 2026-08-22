function widthCm = resolve_figure_width(profile, targetLayout)
%RESOLVE_FIGURE_WIDTH Validate a target layout and return its width in cm.

arguments
    profile (1,1) struct
    targetLayout (1,1) string
end

layout = lower(strrep(strtrim(targetLayout), "_", "-"));
switch layout
    case {"half-column", "half"}
        widthCm = profile.halfColumnWidthCm;
    case {"single-column", "single", "one-column"}
        widthCm = profile.singleColumnWidthCm;
    case {"double-column", "double", "two-column"}
        widthCm = profile.doubleColumnWidthCm;
    otherwise
        tokens = regexp(layout, ...
            "^width-([0-9]+(\.[0-9]+)?)-cm$", "tokens", "once");
        if isempty(tokens)
            error("ProjectName_utils:plotting:InvalidTargetLayout", ...
                "Target layout '%s' is invalid. Use half-column, single-column, double-column, or width-<positive>-cm.", ...
                targetLayout);
        end
        widthCm = str2double(tokens{1});
end

if ~isfinite(widthCm) || widthCm <= 0
    error("ProjectName_utils:plotting:InvalidTargetLayout", ...
        "Target layout '%s' must resolve to a positive finite width in centimeters.", ...
        targetLayout);
end
widthCm = min(widthCm, profile.maxWidthCm);
end

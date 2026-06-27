function profile = figure_profile(name)
%FIGURE_PROFILE Return journal figure defaults used by the template.
%
% The default profile follows IEEE graphics guidance for journals and
% conferences. Use it as a starting point, then override project- or
% venue-specific details when a target journal gives stricter instructions.

arguments
    name (1,1) string = "ieee"
end

key = lower(strrep(name, "_", "-"));
switch key
    case {"ieee", "ieee-journal", "ieee-transactions", "ieee-conference"}
        profile = ieee_profile();
    otherwise
        error("ProjectName_utils:plotting:UnknownFigureProfile", ...
            "Unknown figure profile: %s.", name);
end
end

function profile = ieee_profile()
profile = struct();
profile.name = "IEEE";
profile.source = "IEEE Author Center graphics guidance, checked 2026-06-27";
profile.recommendedFonts = ["Helvetica", "Times New Roman", "Arial", "Cambria", "Symbol"];
profile.fontCandidates = ["Times New Roman", "Helvetica", "Arial", "Cambria", "Times"];
profile.fontSizePt = 9;
profile.axisLineWidthPt = 0.75;
profile.lineWidthPt = 1.2;
profile.markerSizePt = 5;
profile.tickDir = "preserve";
profile.singleColumnWidthCm = 8.89;
profile.doubleColumnWidthCm = 18.2;
profile.maxWidthCm = 18.2;
profile.maxHeightCm = 22.0;
profile.previewDpi = 300;
profile.diagnosticDpi = 200;
profile.rasterColorGrayDpi = 300;
profile.rasterLineArtDpi = 600;
profile.defaultExtraFormats = "pdf";
profile.acceptedSubmissionFormats = ["ps", "eps", "pdf", "png", "tiff"];
profile.vectorSubmissionFormats = ["ps", "eps", "pdf"];
profile.accessibilityRule = "Do not rely on color alone; combine color with line style, marker, brightness, or fill pattern.";
profile.axisLabelRule = "Use quantity names with units in parentheses, not units alone.";
end

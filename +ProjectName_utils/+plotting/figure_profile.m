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
profile.source = "IEEE-oriented project default for two-column manuscripts, updated 2026-06-28";
profile.recommendedFonts = ["Helvetica", "Times New Roman", "Arial", "Cambria", "Symbol"];
profile.fontCandidates = ["Times New Roman", "Helvetica", "Arial", "Cambria", "Times"];
profile.fontSizePt = 10;
profile.defaultFontSizePt = 10;
profile.minFontSizePt = 8;
profile.axisLineWidthPt = 0.75;
profile.lineWidthPt = 1.2;
profile.markerSizePt = 5;
profile.tickDir = "preserve";
profile.defaultLayout = "single-column";
profile.singleColumnWidthCm = 8.89;
profile.doubleColumnWidthCm = 18.2;
profile.maxWidthCm = profile.singleColumnWidthCm;
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
profile.widthRule = "Default manuscript figures target IEEE two-column papers and must not exceed one column width.";
profile.fontSizeRule = "Default manuscript figure text is 10 pt; complex small figures may use 8 pt when explicitly recorded.";
profile.legendRule = "Prefer in-axes legends for line and bar charts; use best/auto placement first and move only when the legend covers important data.";
end

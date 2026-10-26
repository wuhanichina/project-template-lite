function apply_white_background(figHandle)
%APPLY_WHITE_BACKGROUND 固定图窗及绘图区域为白底，避免继承 MATLAB 深色主题。

arguments
    figHandle (1,1) matlab.ui.Figure
end

% 新版本固定为浅色主题，旧版本使用下面的显式颜色设置。
if isprop(figHandle, "Theme")
    figHandle.Theme = "light";
end
figHandle.Color = [1 1 1];
figHandle.InvertHardcopy = "off";

% 后续创建或重置坐标区时继续使用相同的背景和文字颜色。
set(figHandle, ...
    "DefaultAxesColor", [1 1 1], ...
    "DefaultAxesXColor", [0 0 0], ...
    "DefaultAxesYColor", [0 0 0], ...
    "DefaultAxesZColor", [0 0 0], ...
    "DefaultTextColor", [0 0 0], ...
    "DefaultLegendColor", [1 1 1], ...
    "DefaultLegendTextColor", [0 0 0], ...
    "DefaultColorbarColor", [0 0 0]);

axesList = findall(figHandle, "Type", "axes");
for k = 1:numel(axesList)
    set(axesList(k), "Color", [1 1 1], ...
        "XColor", [0 0 0], "YColor", [0 0 0], "ZColor", [0 0 0]);
end

legendList = findall(figHandle, "Type", "legend");
for k = 1:numel(legendList)
    set(legendList(k), "Color", [1 1 1], "TextColor", [0 0 0]);
end

colorbarList = findall(figHandle, "Type", "colorbar");
for k = 1:numel(colorbarList)
    colorbarList(k).Color = [0 0 0];
end

textList = findall(figHandle, "Type", "text");
for k = 1:numel(textList)
    textList(k).Color = [0 0 0];
end
end

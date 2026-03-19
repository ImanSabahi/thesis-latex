function [fig1]=Figure_Styling_Iman_Manuscript_Subplots(figfig,opts)
% Figure_Styling_Iman_Manuscript_Subplots - Style figures with single or multiple subplots
%
% This function styles .fig files for PhD manuscript, supporting both
% single-axis figures and figures with multiple subplots.
%
% For per-subplot settings, use cell arrays. If a scalar/single value is
% provided, it will be applied to all subplots.
%
% Example usage for subplots:
%   Figure_Styling_Iman_Manuscript_Subplots(fig,...
%       TitleLabel_YlabelText=["Force (N)", "Acceleration (m/s²)"],...
%       Axis_YLim={[0 100], [-5 5]},...  % cell array for different limits per subplot
%       Legend_OnOff=["on", "off"]);     % legend only on first subplot

%% General inputs
arguments
    figfig
    %General
    opts.General_SavePDF %String, if empty it means don't save. 
    opts.General_SavePath (1,1) string = pwd
    opts.General_ShowFigure (1,1) string = "visible"
    %SizeAndPos
    opts.SizeAndPos_widthCm (1,1) single = 9
    opts.SizeAndPos_heightCm (1,1) single = 9
    %Legend (can be per-subplot using arrays)
    opts.Legend_OnOff (1,:) string = "off"
    opts.Legend_Strings  % cell array of string arrays for multiple subplots: {["a","b"],["c","d"]}
    opts.Legend_Location (1,:) string = "northeast"
    opts.Legend_FontSize (1,1) double = 8
    opts.Legend_Box (1,1) string = "on"
    opts.Legend_Font (1,1) string = "Times New Roman"
    opts.Legend_Orientation (1,1) string = "vertical"
    %TitleLabel (can be per-subplot using arrays)
    opts.TitleLabel_TitleText (1,:) string = ""
    opts.TitleLabel_TitleFontSize (1,1) double = 10
    opts.TitleLabel_TitleFont (1,1) string = "Times New Roman"
    opts.TitleLabel_LabelFontSize (1,1) double = 10
    opts.TitleLabel_XlabelText (1,:) string  % array for multiple subplots
    opts.TitleLabel_YlabelText (1,:) string  % array for multiple subplots
    opts.TitleLabel_LabelFont (1,1) string = "Times New Roman"
    %Axis (limits can be per-subplot using cell arrays)
    opts.Axis_LineWidth (1,1) double = 1.0
    opts.Axis_FontSize (1,1) double = 10
    opts.Axis_Font (1,1) string = "Times New Roman"
    opts.Axis_XLim  = [] % Cell array for per-subplot: {[0 10], [0 20]} or single [0 10] for all
    opts.Axis_YLim  = [] % Cell array for per-subplot: {[0 10], [0 20]} or single [0 10] for all
    opts.Axis_XMinorTick (1,1) string = "on"
    opts.Axis_YMinorTick (1,1) string = "on"
    opts.Axis_GridStyle (1,1) string = "--"
    opts.Axis_YGrid (1,1) string = "on"
    opts.Axis_XGrid (1,1) string = "on"
    opts.Axis_Box (1,1) string = "off"
    %Color
    opts.Color_Background (1,1) string = "white"
    opts.Color_Axis (1,1) string = "black"
    opts.Color_Grid (1,3) double = [0.5 0.5 0.5] % RGB as gray
    %Line
    opts.Line_style (1,:) string = repmat("-",1,20)
    opts.Line_color (:,3) double = lines(20)
    opts.Line_width (1,:) double = repmat(1,1,20)
    opts.Line_marker (1,:) string = repmat("none",1,20)
    opts.Line_markerSize (1,:) double = repmat(6,1,20)
    opts.Line_markerFaceColor (:,3) double = lines(20)
    opts.Line_markerFreqRatio (1,1) double = 10
    opts.Line_change (1,1) string = "on"
    %Subplot-specific options
    opts.Subplot_Order (1,:) double = [] % Specify order of subplots to process (empty = auto-detect)
end

%% Opening the figure

if isequal(class(figfig),'matlab.ui.Figure')
    fig1 = figfig;
elseif isequal(class(figfig),'string') || ischar(figfig)
    fig1 = openfig(figfig,'visible',opts.General_ShowFigure);
else
    error('Input figure not done correctly')
end

%% Find all axes in the figure (excluding legends, colorbars, etc.)
allAxes = findobj(fig1, 'Type', 'axes');

% Filter out non-plot axes (legends, colorbars, etc.)
plotAxes = [];
for i = 1:length(allAxes)
    ax = allAxes(i);
    % Skip if it's a legend or colorbar
    if isa(ax, 'matlab.graphics.illustration.Legend') || ...
       isa(ax, 'matlab.graphics.illustration.ColorBar')
        continue;
    end
    % Check if the axes has a tag indicating it's not a main plot
    if contains(lower(ax.Tag), {'legend', 'colorbar'})
        continue;
    end
    plotAxes = [plotAxes; ax];
end

% Sort axes by position (top-to-bottom, left-to-right) for consistent ordering
if ~isempty(plotAxes)
    positions = zeros(length(plotAxes), 2);
    for i = 1:length(plotAxes)
        pos = plotAxes(i).Position;
        positions(i,:) = [pos(2), pos(1)]; % [bottom, left]
    end
    % Sort by row (descending) then column (ascending)
    [~, sortIdx] = sortrows(positions, [-1, 2]);
    plotAxes = plotAxes(sortIdx);
end

% Override order if specified
if ~isempty(opts.Subplot_Order)
    plotAxes = plotAxes(opts.Subplot_Order);
end

numAxes = length(plotAxes);

%% Process each axis
for axIdx = 1:numAxes
    ax = plotAxes(axIdx);
    
    % Make this axis current
    axes(ax);
    
    % Handle double Y-axis: start with left axis
    if size(ax.YAxis,1) == 2
        yyaxis(ax, 'left');
    end
    
    %% Legend
    legendOnOff = getPerSubplotValue(opts.Legend_OnOff, axIdx, "off");
    if legendOnOff == "on"
        % Get legend strings for this subplot
        if iscell(opts.Legend_Strings)
            legendStr = opts.Legend_Strings{min(axIdx, length(opts.Legend_Strings))};
        elseif isfield(opts, 'Legend_Strings') && ~isempty(opts.Legend_Strings)
            legendStr = opts.Legend_Strings;
        else
            legendStr = [];
        end
        legendLoc = getPerSubplotValue(opts.Legend_Location, axIdx, "northeast");
        
        if ~isempty(legendStr)
            legend(ax, legendStr, 'Location', legendLoc, ...
                   'FontSize', opts.Legend_FontSize, 'Box', opts.Legend_Box,...
                   'FontName', opts.Legend_Font, 'Orientation', opts.Legend_Orientation, ...
                   'Units', 'points');
        end
    elseif legendOnOff == "off"
        leg = legend(ax);
        if ~isempty(leg)
            leg.Visible = "off";
        end
    end
    
    %% Title and Labels
    titleText = getPerSubplotValue(opts.TitleLabel_TitleText, axIdx, "");
    titleHandle = ax.Title;
    if ~isempty(titleText) && titleText ~= ""
        titleHandle.String = titleText;
    end
    set(titleHandle, 'FontSize', opts.TitleLabel_TitleFontSize, ...
        'FontName', opts.TitleLabel_TitleFont);
    
    % X Label
    if isfield(opts, 'TitleLabel_XlabelText') && ~isempty(opts.TitleLabel_XlabelText)
        xlabelText = getPerSubplotValue(opts.TitleLabel_XlabelText, axIdx, "");
        if ~isempty(xlabelText)
            ax.XLabel.String = xlabelText;
        end
    end
    set(ax.XLabel, 'FontSize', opts.TitleLabel_LabelFontSize, ...
        'FontName', opts.TitleLabel_LabelFont);
    
    % Y Label
    if isfield(opts, 'TitleLabel_YlabelText') && ~isempty(opts.TitleLabel_YlabelText)
        ylabelText = getPerSubplotValue(opts.TitleLabel_YlabelText, axIdx, "");
        if ~isempty(ylabelText)
            ax.YLabel.String = ylabelText;
        end
    end
    set(ax.YLabel, 'FontSize', opts.TitleLabel_LabelFontSize, ...
        'FontName', opts.TitleLabel_LabelFont);
    
    %% Axis properties
    ax.LineWidth = opts.Axis_LineWidth;
    ax.FontSize = opts.Axis_FontSize;
    ax.FontName = opts.Axis_Font;
    
    % X Limits (per-subplot support)
    xlimVal = getPerSubplotValueCell(opts.Axis_XLim, axIdx);
    if ~isempty(xlimVal)
        ax.XLim = xlimVal;
    end
    
    % Y Limits (per-subplot support)
    ylimVal = getPerSubplotValueCell(opts.Axis_YLim, axIdx);
    if ~isempty(ylimVal)
        ax.YLim = ylimVal;
    end
    
    ax.XColor = opts.Color_Axis;
    ax.YColor = opts.Color_Axis;
    set(ax, 'XMinorTick', opts.Axis_XMinorTick, 'YMinorTick', opts.Axis_YMinorTick, ...
        'Box', opts.Axis_Box);
    
    % Handle right Y-axis if present
    if size(ax.YAxis,1) == 2
        yyaxis(ax, 'right');
        ax.LineWidth = opts.Axis_LineWidth;
        ax.FontSize = opts.Axis_FontSize;
        ax.FontName = opts.Axis_Font;
        ax.XColor = opts.Color_Axis;
        ax.YColor = opts.Color_Axis;
        set(ax, 'XMinorTick', opts.Axis_XMinorTick, 'YMinorTick', opts.Axis_YMinorTick, ...
            'Box', opts.Axis_Box);
        yyaxis(ax, 'left');
    end
    
    %% Grid
    ax.XGrid = opts.Axis_XGrid;
    ax.YGrid = opts.Axis_YGrid;
    ax.GridLineStyle = opts.Axis_GridStyle;
    ax.GridColor = opts.Color_Grid;
    
    if size(ax.YAxis,1) == 2
        yyaxis(ax, 'right');
        ax.XGrid = opts.Axis_XGrid;
        ax.YGrid = opts.Axis_YGrid;
        ax.GridLineStyle = opts.Axis_GridStyle;
        ax.GridColor = opts.Color_Grid;
        yyaxis(ax, 'left');
    end
    
    %% Lines
    h = findobj(ax, 'Type', 'line');
    if isequal(opts.Line_change,"on") %to not change anything if we don't want to
        for i = 1:length(h)
            if i <= length(opts.Line_style)
                set(h(i), 'LineStyle', opts.Line_style(i), ...
                    'Color', opts.Line_color(min(i, size(opts.Line_color,1)), :), ...
                    'LineWidth', opts.Line_width(min(i, length(opts.Line_width))));
                % Set markers
                set(h(i), 'Marker', opts.Line_marker(min(i, length(opts.Line_marker))), ...
                    'MarkerSize', opts.Line_markerSize(min(i, length(opts.Line_markerSize))), ...
                    'MarkerFaceColor', opts.Line_markerFaceColor(min(i, size(opts.Line_markerFaceColor,1)), :), ...
                    'MarkerIndices', 1:fix(length(h(i).XData)/opts.Line_markerFreqRatio):length(h(i).XData));
            end
        end
    end

    %% Tick direction and colors (hardcoded settings)
    set(ax, 'TickDir', 'out', 'XColor', [.3 .3 .3], ...
        'YColor', [.3 .3 .3], 'LineWidth', 1);
    
    if size(ax.YAxis,1) == 2
        yyaxis(ax, 'right');
        set(ax, 'TickDir', 'out', 'XColor', [.3 .3 .3], ...
            'YColor', [.3 .3 .3], 'LineWidth', 1);
        yyaxis(ax, 'left');
    end
end

%% Background Color (applies to whole figure)
fig1.Color = opts.Color_Background;

%% Size and Position
set(fig1, 'Units', 'centimeters');
fig1.Position(3:4) = [opts.SizeAndPos_widthCm opts.SizeAndPos_heightCm];

%% Save figure in PDF format
if isfield(opts, 'General_SavePDF') && ~isempty(opts.General_SavePDF) && opts.General_SavePDF ~= ""
    timestamp = datetime('now', 'Format', 'yyyyMMdd_HHmmss');
    nameOfPDF = fullfile(opts.General_SavePath, strcat('Figure_', opts.General_SavePDF, string(timestamp), '.pdf'));
    exportgraphics(fig1, nameOfPDF, 'ContentType', 'vector', 'Padding', 'tight');
end

end

%% Helper functions

function val = getPerSubplotValue(arr, idx, default)
% Get value for specific subplot index from string/numeric array
% If array is shorter than idx, returns last element or default
    if isempty(arr)
        val = default;
    elseif length(arr) >= idx
        val = arr(idx);
    else
        val = arr(end); % Use last value for remaining subplots
    end
end

function val = getPerSubplotValueCell(cellOrArr, idx)
% Get value for specific subplot index from cell array or regular array
% For cell arrays: each cell contains settings for one subplot
% For regular arrays: same settings apply to all subplots
    if isempty(cellOrArr)
        val = [];
    elseif iscell(cellOrArr)
        if length(cellOrArr) >= idx
            val = cellOrArr{idx};
        elseif ~isempty(cellOrArr)
            val = cellOrArr{end};
        else
            val = [];
        end
    else
        val = cellOrArr; % Same value for all subplots
    end
end

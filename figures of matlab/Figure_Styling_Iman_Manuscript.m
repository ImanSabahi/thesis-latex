function [fig1]=Figure_Styling_Iman_Manuscript(figfig,opts)
% Author: Iman Sabahi, u0138258
% LMSD group, Mechanical Engineering Dept. of KU Leuven
% Email: iman.sabahi@kuleuven.be
% Last change: 08/11/2024
% Description:
% This function applies a style to figures.
% INPUTS:
%       fig: The figure 
% NAMEVALUE INPUTS:
%       opts.
%       
% OUTPUTS:
%       fig1

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
    %Legend
    opts.Legend_OnOff (1,1) string = "off"
    opts.Legend_Strings (1,:) string %ex:["Force","acceleration"]
    opts.Legend_Location (1,:) string = "northeast"
    opts.Legend_FontSize (1,1) double = 8
    opts.Legend_Box (1,1) string = "on"
    opts.Legend_Font (1,1) string = "Times New Roman"
    opts.Legend_Orientation (1,1) string = "vertical"
    %TitleLabel
    opts.TitleLabel_TitleText (1,1) string = ""
    opts.TitleLabel_TitleFontSize (1,1) double = 10
    opts.TitleLabel_TitleFont (1,1) string = "Times New Roman"
    opts.TitleLabel_LabelFontSize (1,1) double = 10
    opts.TitleLabel_XlabelText (1,1) string
    opts.TitleLabel_YlabelText (1,1) string
    opts.TitleLabel_LabelFont (1,1) string = "Times New Roman"
    %Axis
    opts.Axis_LineWidth (1,1) double = 1.0
    opts.Axis_FontSize (1,1) double = 10
    opts.Axis_Font (1,1) string = "Times New Roman"
    opts.Axis_XLim (1,:) double = [] %Empty if we want no lim change
    opts.Axis_YLim (1,:) double = []
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
    opts.Line_color (:,:) double = lines(20)
    opts.Line_width (1,:) double = repmat(1,1,20)
    opts.Line_marker (1,:) string = repmat("none",1,20) %"none","^","none","square","none","v","none","o"
    opts.Line_markerSize (1,:) double = repmat(6,1,20)
    opts.Line_markerFaceColor (:,3) double = lines(20)
    opts.Line_markerFreqRatio (1,1) double = 10
end

%% Openning the figure

if isequal(class(figfig),'matlab.ui.Figure')
    fig1=figfig;
elseif isequal(class(figfig),'string')
    fig1=openfig(figfig,'visible',opts.General_ShowFigure);
else
    error('Input figure not done correctly')
end
ax = gca; 
% drawnow()

%% Main section
%First lets make sure we're on the correct axis if there's 2:
if size(ax.YAxis,1) == 2 %If double y axis, lets be at the left one
    yyaxis left    
end

%Legend
if opts.Legend_OnOff == "on"
    legend(opts.Legend_Strings, 'Location', opts.Legend_Location, ...
           'FontSize', opts.Legend_FontSize, 'Box', opts.Legend_Box,...
           'FontName',opts.Legend_Font,'Orientation',opts.Legend_Orientation,Units='points');
elseif opts.Legend_OnOff == "off"
    q=legend();
    q.Visible="off";
end

%TitleLabel
titleHandle = ax.Title;
if isfield(opts,'TitleLabel_TitleText');titleHandle.String=opts.TitleLabel_TitleText;end
set(titleHandle,'FontSize', opts.TitleLabel_TitleFontSize,...
    'FontName',opts.TitleLabel_TitleFont);

xlableHandle = ax.XLabel;
if isfield(opts,'TitleLabel_XlabelText');xlableHandle.String=opts.TitleLabel_XlabelText;end
set(xlableHandle,'FontSize', opts.TitleLabel_LabelFontSize,...
    'FontName',opts.TitleLabel_LabelFont);

ylableHandle = ax.YLabel;
if isfield(opts,'TitleLabel_YlabelText');ylableHandle.String=opts.TitleLabel_YlabelText;end
set(ylableHandle,'FontSize', opts.TitleLabel_LabelFontSize,...
    'FontName',opts.TitleLabel_LabelFont);

% yyaxis left %%%This caused size(ax.YAxis,1) to be 2
%Axis
ax.LineWidth = opts.Axis_LineWidth;
ax.FontSize = opts.Axis_FontSize;
ax.FontName = opts.Axis_Font;
if ~isempty(opts.Axis_XLim);ax.XLim = opts.Axis_XLim;end
if ~isempty(opts.Axis_YLim);ax.YLim = opts.Axis_YLim;end
ax.XColor = opts.Color_Axis;
ax.YColor = opts.Color_Axis;
set(ax, 'XMinorTick', opts.Axis_XMinorTick, 'YMinorTick', opts.Axis_YMinorTick,...
    'Box', opts.Axis_Box);
if size(ax.YAxis,1) == 2 %If double y axis, to include both
    yyaxis right
    ax.LineWidth = opts.Axis_LineWidth;
    ax.FontSize = opts.Axis_FontSize;
    ax.FontName = opts.Axis_Font;
    if ~isempty(opts.Axis_XLim);ax.XLim = opts.Axis_XLim;end
    if ~isempty(opts.Axis_YLim);ax.YLim = opts.Axis_YLim;end
    ax.XColor = opts.Color_Axis;
    ax.YColor = opts.Color_Axis;
    set(gca, 'XMinorTick', opts.Axis_XMinorTick, 'YMinorTick', opts.Axis_YMinorTick,...
    'Box', opts.Axis_Box);
    yyaxis left
end



%Grid
ax.XGrid = opts.Axis_XGrid;
ax.YGrid = opts.Axis_YGrid;
ax.GridLineStyle = opts.Axis_GridStyle;
ax.GridColor = opts.Color_Grid;
if size(ax.YAxis,1) == 2 %If double y axis, to include both
    yyaxis right
    ax.XGrid = opts.Axis_XGrid;
    ax.YGrid = opts.Axis_YGrid;
    ax.GridLineStyle = opts.Axis_GridStyle;
    ax.GridColor = opts.Color_Grid;
    yyaxis left
end


% Background Color
fig1.Color = opts.Color_Background;

% Lines
h = findobj(gca,'Type','line');
for i=1:size(h,1)
    set(h(i), 'LineStyle', opts.Line_style(i), 'Color', opts.Line_color(i,:),...
        'LineWidth', opts.Line_width(i))
    % set markers 
    set(h(i),'Marker', opts.Line_marker(i), 'MarkerSize', opts.Line_markerSize(i),...
    'MarkerFaceColor', opts.Line_markerFaceColor(i,:),'MarkerIndices',...
    1:fix(length(h(i).XData)/opts.Line_markerFreqRatio):length(h(i).XData));
end


%SizeAndPos
% set(ax,"PositionConstraint","outerposition"); %To make sure that nothing gets cropped
set(fig1,'units','centimeters')
set(fig1,'Position',[5 5 opts.SizeAndPos_widthCm opts.SizeAndPos_heightCm]);

%% Settings for which I have not yet defined a namevalue arg:
set(gca, 'TickDir', 'out','XColor', [.3 .3 .3], ...
    'YColor', [.3 .3 .3],'LineWidth', 1)
if size(ax.YAxis,1) == 2 %If double y axis, to include both
    yyaxis right
    set(gca, 'TickDir', 'out','XColor', [.3 .3 .3], ...
        'YColor', [.3 .3 .3],'LineWidth', 1);
    yyaxis left
end
% colorbar

%% Save figure in PDF format
%Fix the sizing and positioning parameters
% ti = get(ax, 'TightInset'); % [left, bottom, right, top] in centimeters
% pad = [0.05 0.05 0.05 0.1]; % extra margin in cm (top slightly larger)
% set(fig1,"Units","centimeter",'PaperUnits','centimeters');
% set(fig1,"PaperPosition", ...
%     [ti(1)+pad(1), ti(2)+pad(2), ...
%     opts.SizeAndPos_widthCm, opts.SizeAndPos_heightCm],...
%     'PaperSize', ...
%     [opts.SizeAndPos_widthCm + ti(1) + ti(3) + pad(1) + pad(3),...
%     opts.SizeAndPos_heightCm+ ti(2) + ti(4) + pad(2) + pad(4)])

set(fig1,'Units','centimeters');
fig1.Position(3:4) = [opts.SizeAndPos_widthCm opts.SizeAndPos_heightCm];

% set(fig1,"PaperPosition",[ti(1), ti(2), opts.SizeAndPos_widthCm, opts.SizeAndPos_heightCm],...
%     'PaperPositionMode','Auto','PaperSize',[opts.SizeAndPos_widthCm,...
%     opts.SizeAndPos_heightCm])
if ~or(isempty(opts.General_SavePDF),isequal(opts.General_SavePDF,"")) %set opts.General_SavePDF to [] or "" to not save.

%Create the name and save the fig

    timestamp = datetime('now','Format','yyyyMMdd_HHmmss');
    nameOfPDF=fullfile(opts.General_SavePath,strcat('Figure_',opts.General_SavePDF,string(timestamp),'.pdf'));
    % print(fig1,nameOfPDF,'-dpdf') %changed to use exportgraphics
    exportgraphics(fig1,nameOfPDF,'ContentType','vector',Padding='tight');

end
end
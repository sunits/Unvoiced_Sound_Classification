function setup_figure(h_fig)
% setup_figure(h_fig)
% Sets up figure properties
% h_fig = A N-length vector of gcf of N figures.
% Author: Arun K. Tangirala

for k = 1:length(h_fig)
    set(h_fig(k),'Color',[1 1 1]);
    prop_fig = get(h_fig(k));

    % Annotate for all axes
    for i = 1:length(prop_fig.Children)
      axis tight
      h_ax = prop_fig.Children(i);
      %axis(h_ax,'tight');
      set(h_ax,'fontsize',12,'fontweight','bold','Xgrid','on','Ygrid','on','Zgrid','on');
      % Set Title and Label Fonts
      h_title = get(h_ax,'Title');
      set(h_title,'fontsize',12,'fontweight','bold');
      h_xlabel = get(h_ax,'Xlabel');
      set(h_xlabel,'fontsize',12,'fontweight','bold');
      h_ylabel = get(h_ax,'Ylabel');
      set(h_ylabel,'fontsize',12,'fontweight','bold');
      % Set linewidth
      h_lines = findobj(h_ax,'type','line');
      for j = 1:length(h_lines)
        set(h_lines(j),'linewidth',2);
      end        
    end
end
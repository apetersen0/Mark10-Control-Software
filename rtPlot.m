function rtPlot(ff_hObject,ff_handles,f_axes_yy,f_plot_yyL,f_plot_yyR,f_plotR,f_dispData,f_forceData,f_timeData)

set(f_plot_yyL,'Ydata',f_dispData');
set(f_plot_yyL,'Xdata',f_timeData');


set(f_plot_yyR,'Ydata',f_forceData');
set(f_plot_yyR,'Xdata',f_timeData');

set(f_axes_yy,'XLimMode','auto');
set(f_axes_yy,'YLimMode','auto');
set(f_axes_yy,'YTickMode','auto')


set(f_plotR,'Ydata',f_forceData');
set(f_plotR,'Xdata',f_dispData');

guidata(ff_hObject,ff_handles); 
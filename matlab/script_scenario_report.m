clear
close all

root = fileparts(fileparts(mfilename('fullpath')));
fwy = {'680N','680S'};

X(1).config = 'scenario_rm_nooverride_dn.xml';
X(1).label = 'dn feedback, no override';
X(1).color = 'k';

X(2).config = 'scenario_rm_override_dn.xml';
X(2).label = 'dn feedback, with override';
X(2).color = 'r';

X(3).config = 'scenario_rm_nooverride_up.xml';
X(3).label = 'up feedback, no override';
X(3).color = 'b';

X(4).config = 'scenario_rm_override_up.xml';
X(4).label = 'up feedback, with override';
X(4).color = 'm';

for f=1:length(fwy)
    
    folder = fullfile(root,'config',[fwy{f} '_+RM_2013']);
    
    % simulate scenarios, load results into Y
    Y = repmat(struct('time',[],'tvh',[],'tvm',[]),1,length(X));
    for i=1:length(X)
        ptr = BeatsSimulation;
        ptr.load_scenario(fullfile(folder,X(i).config));
        ptr.run_beats(struct('SIM_DT','5','OUTPUT_DT','300'));
        [Y(i).time,Y(i).tvh,Y(i).tvm] = ptr.compute_performance;
    end
    clear ptr
    
    % plot tvh
    figure
    for i=1:length(Y)
        hold on
        plot(Y(i).time/3600,Y(i).tvh,'Color',X(i).color,'LineWidth',2)
    end
    set(gca,'XLim',[0 24])
    legend({X.label},'Location','Best')
    title('680 North ramp metering scenarios, Total vehicle hours')
    ylabel('TVH [veh.hr]')
    grid
    
    % plot tvm
    figure
    for i=1:length(Y)
        hold on
        plot(Y(i).time/3600,Y(i).tvm,'Color',X(i).color,'LineWidth',2)
    end
    set(gca,'XLim',[0 24])
    legend({X.label},'Location','Best')
    title('680 North ramp metering scenarios, Total vehicle miles')
    ylabel('TVH [veh.mile]')
    grid
    
    clear Y
    
end
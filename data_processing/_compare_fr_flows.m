clear
close all
ptr = BeatsSimulation;
ptr.load_scenario('C:\Users\gomes\Dropbox\680_Data\config\680N\680N_v4_control.xml');
ptr.load_simulation_output('C:\Users\gomes\Dropbox\680_Data\config\680N\680N_v4_control');

FR = xml_read('fr_demand_vph.xml');

link_ids = ptr.scenario_ptr.get_link_ids;
link_types = ptr.scenario_ptr.get_link_types;

is_fr = strcmp(link_types,'Off-Ramp');
[ppt,op]=openppt('compare_fr',true);

for i=1:length(FR.demandProfile)
    link_id = FR.demandProfile(i).ATTRIBUTE.link_id_org;
    ind = link_id==link_ids;
    if(~any(ind))
        error('sadfsadfsadf')
    end
    
    sim_flw = ptr.inflow_veh{1}(:,ind)+ptr.inflow_veh{2}(:,ind);
    sim_flw = sim_flw'*12;
    msr_flw = FR.demandProfile(i).demand.CONTENT;
    
    figure
    plot((1:288)*24/288,msr_flw,'r','LineWidth',3)
    hold on
    plot((1:288)*24/288,sim_flw,'k--','LineWidth',2)
    grid
    set(gca,'XLim',[0 24])
    timelabelXTick(gca)
    ylabel('offramp flow [veh/hr]')
    legend('measured','simulated')
    
    
    addslide(op,['Link id ' num2str(link_id)])
    
    close
end
closeppt(ppt,op)

beep()

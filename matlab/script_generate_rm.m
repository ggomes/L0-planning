clear 
close all

alinea_gain_value = 50.0 * 1609.344 / 3600.0;  % in meter/sec
queue_limit = 30;   % vehicles

root = fileparts(fileparts(mfilename('fullpath')));

%% 680 N / base year

% rm with upstream feedback / no override
i = 1;
X(i).folder_base        = fullfile(root,'config','680N-no217');
X(i).config_file        = fullfile(X(i).folder_base,'680N.xml');
X(i).folder_rm          = fullfile(root,'config','680N_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_nooverride_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;

% rm with upstream feedback / with override
i = i+1;
X(i).folder_base        = fullfile(root,'config','680N-no217');
X(i).config_file        = fullfile(X(i).folder_base,'680N.xml');
X(i).folder_rm          = fullfile(root,'config','680N_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_override_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;
            
% rm with downstream feedback / no override
i = i+1;
X(i).folder_base        = fullfile(root,'config','680N-no217');
X(i).config_file        = fullfile(X(i).folder_base,'680N.xml');
X(i).folder_rm          = fullfile(root,'config','680N_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_nooverride_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;
            
% rm with downstream feedback / with override
i = i+1;
X(i).folder_base        = fullfile(root,'config','680N-no217');
X(i).config_file        = fullfile(X(i).folder_base,'680N.xml');
X(i).folder_rm          = fullfile(root,'config','680N_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_override_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;

%% 680 S / base year

% rm with upstream feedback / no override
i = i+1;
X(i).folder_base        = fullfile(root,'config','680S');
X(i).config_file        = fullfile(X(i).folder_base,'680S.xml');
X(i).folder_rm          = fullfile(root,'config','680S_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_nooverride_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;

% rm with upstream feedback / with override
i = i+1;
X(i).folder_base        = fullfile(root,'config','680S');
X(i).config_file        = fullfile(X(i).folder_base,'680S.xml');
X(i).folder_rm          = fullfile(root,'config','680S_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_override_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;
            
% rm with downstream feedback / no override
i = i+1;
X(i).folder_base        = fullfile(root,'config','680S');
X(i).config_file        = fullfile(X(i).folder_base,'680S.xml');
X(i).folder_rm          = fullfile(root,'config','680S_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_nooverride_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;
            
% rm with downstream feedback / with override
i = i+1;
X(i).folder_base        = fullfile(root,'config','680S');
X(i).config_file        = fullfile(X(i).folder_base,'680S.xml');
X(i).folder_rm          = fullfile(root,'config','680S_+RM_2013');
X(i).out_file           = fullfile(X(i).folder_rm,'rm_override_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;

%% run generate_rm ....................................................
for i=1:length(X)
    generate_rm( X(i).config_file , ...
                     X(i).out_file , ...
                     X(i).up_or_down , ...
                     X(i).alinea_gain_value , ...
                     X(i).queue_limit )
end


disp('done')
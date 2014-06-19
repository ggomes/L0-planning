clear 
close all

alinea_gain_value = 50.0 * 1609.344 / 3600.0;  % in meter/sec
queue_limit = 30;   % vehicles

root = fileparts(fileparts(mfilename('fullpath')));

config_680N_base    = fullfile(root,'config','680N-no217','680N_with_splits.xml');
folder_680N_base_rm = fullfile(root,'config','680N_+RM_2013');

config_680S_base    = fullfile(root,'config','680S','680S_with_splits.xml');
folder_680S_base_rm = fullfile(root,'config','680S_+RM_2013');

%% 680 N / base year

% rm with upstream feedback / no override
i = 1;
X(i).config_file        = config_680N_base;
X(i).out_file           = fullfile(folder_680N_base_rm,'680N_alinea_nooverride_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;

% rm with upstream feedback / with override
i = i+1;
X(i).config_file        = config_680N_base;
X(i).out_file           = fullfile(folder_680N_base_rm,'680N_alinea_override_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;
            
% rm with downstream feedback / no override
i = i+1;
X(i).config_file        = config_680N_base;
X(i).out_file           = fullfile(folder_680N_base_rm,'680N_alinea_nooverride_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;
            
% rm with downstream feedback / with override
i = i+1;
X(i).config_file        = config_680N_base;
X(i).out_file           = fullfile(folder_680N_base_rm,'680N_alinea_override_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;

%% 680 S / base year

% rm with upstream feedback / no override
i = i+1;
X(i).config_file        = config_680S_base;
X(i).out_file           = fullfile(folder_680S_base_rm,'680N_alinea_nooverride_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;

% rm with upstream feedback / with override
i = i+1;
X(i).config_file        = config_680S_base;
X(i).out_file           = fullfile(folder_680S_base_rm,'680N_alinea_override_up.xml');
X(i).up_or_down         = 'up';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;
            
% rm with downstream feedback / no override
i = i+1;
X(i).config_file        = config_680S_base;
X(i).out_file           = fullfile(folder_680S_base_rm,'680N_alinea_nooverride_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = inf;
            
% rm with downstream feedback / with override
i = i+1;
X(i).config_file        = config_680S_base;
X(i).out_file           = fullfile(folder_680S_base_rm,'680N_alinea_override_dn.xml');
X(i).up_or_down         = 'down';
X(i).alinea_gain_value  = alinea_gain_value;
X(i).queue_limit        = queue_limit;

%% run generate_alinea ....................................................
for i=1:length(X)
    generate_alinea( X(i).config_file , ...
                     X(i).out_file , ...
                     X(i).up_or_down , ...
                     X(i).alinea_gain_value , ...
                     X(i).queue_limit )
end


disp('done')
// This file read xcos graphs saved on disc
exec("T1//scripts//utils.sci");

function [plots] = get_plots(scg_file)
    xload(scg_file);
    fig = gcf();
    graph = fig.children;
    plots = graph.children;
endfunction

function [x, y] = get_curve(scg_file, curve_index)
    plots = get_plots(scg_file);
    
    x = [];
    y = [];
    count = 0;
    for i = 1:size(plots, "*")
        p = plots(i);
        if p.type == "Polyline" then
            count = count + 1;
            if count == curve_index then
                x = p.data(:,1);
                y = p.data(:,2);
                return;
            end
        end
    end

    // If requested curve not found
    error("Curve index " + string(curve_index) + " not found in file: " + scg_file);
endfunction

// mprintf("MOD-SP file\n");
// view_data("T1//MOD-SP.scg") // CURVA-1: SP | CURVA-2: CV | CURVA-3: DV
// mprintf("MOD-DV file\n");
// view_data("T1//MOD-DV.scg") // CURVA-1: SP | CURVA-2: CV | CURVA-3: DV

mprintf("Controller optimazed for SP step\n");
mod_sp_file = "T1//MOD-SP-MF.scg";
[mod_sp_time, mod_sp_sp] = get_curve(mod_sp_file, 1);
[_, mod_sp_cv] = get_curve(mod_sp_file, 2);
show_parameters(mod_sp_time, mod_sp_sp, mod_sp_cv);
mprintf("-----------------------------\n\n");

mprintf("Controller optimazed for DV step\n");
mod_dv_file = "T1//MOD-DV-MF.scg";
[mod_dv_time, mod_dv_sp] = get_curve(mod_dv_file, 1);
[_, mod_dv_cv] = get_curve(mod_dv_file, 2);
show_parameters(mod_dv_time, mod_dv_sp, mod_dv_cv);
mprintf("-----------------------------\n\n");

mprintf("Controller optimazed for DV step with step in SP\n");
mod_sp_file = "T1//MOD-SP-inverted.scg";
[mod_sp_time, mod_sp_sp] = get_curve(mod_sp_file, 1);
[_, mod_sp_cv] = get_curve(mod_sp_file, 2);
show_parameters(mod_sp_time, mod_sp_sp, mod_sp_cv);
mprintf("-----------------------------\n\n");

mprintf("Controller optimazed for DP step with step in SP\n");
mod_dv_file = "T1//MOD-DV-inverted.scg";
[mod_dv_time, mod_dv_sp] = get_curve(mod_dv_file, 1);
[_, mod_dv_cv] = get_curve(mod_dv_file, 2);
show_parameters(mod_dv_time, mod_dv_sp, mod_dv_cv);
mprintf("-----------------------------\n\n");

mprintf("Controller optimazed with step in SP\n");
mod_sp_file = "T1//MOD-SP-opt.scg";
[mod_sp_time, mod_sp_sp] = get_curve(mod_sp_file, 1);
[_, mod_sp_cv] = get_curve(mod_sp_file, 2);
show_parameters(mod_sp_time, mod_sp_sp, mod_sp_cv);
mprintf("-----------------------------\n\n");

mprintf("Controller optimazed with step in DV\n");
mod_sp_file = "T1//MOD-DV-opt.scg";
[mod_sp_time, mod_sp_sp] = get_curve(mod_sp_file, 1);
[_, mod_sp_cv] = get_curve(mod_sp_file, 2);
show_parameters(mod_sp_time, mod_sp_sp, mod_sp_cv);
mprintf("-----------------------------\n\n");

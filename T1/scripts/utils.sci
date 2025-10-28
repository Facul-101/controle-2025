function show_preview(x, y)
    n = length(y);        
    mid = round(n / 2);

    mprintf("- Number of points: %d\n", n)
    mprintf("- First point:  x = %f,  y = %f\n", x(1), y(1));
    mprintf("- Middle point: x = %f,  y = %f\n", x(mid), y(mid));
    mprintf("- Last point:   x = %f,  y = %f\n", x(n), y(n));
endfunction

function view_data(scg_file)
    plots = get_plots(scg_file);

    for i = 1:size(plots, "*");
        p = plots(i);
        if p.type == "Polyline" then
            x = p.data(:,1);
            y = p.data(:,2);

            mprintf("Curve %d: \n", i);
            show_preview(x, y);
            mprintf("-----------------------------\n\n");
        end
    end
endfunction

function [iae] = calc_iae(dt, erro)
    iae = sum(dt.*(abs(erro(1:$-1)) + abs(erro(2:$)))/2);
endfunction

function [ise] = calc_ise(dt, erro)
    ise = sum(dt.*(erro(1:$-1).^2 + erro(2:$).^2)/2);
endfunction

function [itae] = calc_itae(dt, erro)
    itae = sum(dt.*((time(1:$-1).*abs(erro(1:$-1))) + (time(2:$).*abs(erro(2:$))))/2);
endfunction

function [iae, ise, itae] = calc_parameters(time, sp, cv)
    erro = sp - cv;
    dt = diff(time);

    iae = calc_iae(dt, erro)
    ise = calc_ise(dt, erro)
    itae = calc_itae(dt, erro)
endfunction

function show_parameters(time, sp, cv)
    // show_preview(time, erro);

    [iae, ise, itae] = calc_parameters(time, sp, cv);

    mprintf("IAE:  %f\n", iae);
    mprintf("ISE:  %f\n", ise);
    mprintf("ITAE: %f\n", itae);
endfunction

function hot_load(xcos_path)
    loadXcosLibs();
    imported = importXcosDiagram(xcos_path); // Loads scs_m
    
    if imported then
        xcos_simulate(scs_m, 4);  // 4 = compiled mode
    else
        error("Xcos simulation failed to load");
    end

    // All parameters are loaded from the xcos simulation

    mprintf("Step change on SP\n");
    show_parameters(mod_sp_sp.time, mod_sp_sp.values, mod_sp_cv.values);
    mprintf("-----------------------------\n\n");

    mprintf("Step change on DV\n");
    show_parameters(mod_dv_sp.time, mod_dv_sp.values, mod_dv_cv.values);
    mprintf("-----------------------------\n\n");
endfunction

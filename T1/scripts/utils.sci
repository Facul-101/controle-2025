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

function show_parameters(time, sp, cv)
    erro = sp - cv;
    // show_preview(time, erro);

    dt = diff(time);

    iae = sum(dt.*(abs(erro(1:$-1)) + abs(erro(2:$)))/2);
    mprintf("IAE:  %f\n", iae);

    ise = sum(dt.*(erro(1:$-1).^2 + erro(2:$).^2)/2);
    mprintf("ISE:  %f\n", iae);

    itae = sum(dt.*((time(1:$-1).*abs(erro(1:$-1))) + (time(2:$).*abs(erro(2:$))))/2);
    mprintf("ITAE: %f\n", itae);
endfunction

function hot_load(xcos_path)
    loadXcosLibs();
    diagram = importXcosDiagram(xcos_path);
    xcos_simulate(scs_m, 4);  // 4 = compiled mode

    // All parameters are loaded from the xcos simulation

    mprintf("Step change on SP\n");
    show_parameters(mod_sp_sp.time, mod_sp_sp.values, mod_sp_cv.values);
    mprintf("-----------------------------\n\n");

    mprintf("Step change on CV\n");
    show_parameters(mod_dv_sp.time, mod_dv_sp.values, mod_dv_cv.values);
    mprintf("-----------------------------\n\n");
endfunction
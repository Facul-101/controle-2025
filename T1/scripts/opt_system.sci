function [block_idx] = get_block_idx(b_type, b_label, scs_m)
    for i = 1:length(scs_m.objs)
        element = scs_m.objs(i);
        // disp(element.graphics);
        if typeof(element) == "Block" then
            if element.graphics.style == b_type then
                if ~isempty(strindex(element.graphics.id, b_label)) then
                    block_idx = i;
                    return;
                end
            end
        end
    end

    error("Block not found")
endfunction

function [iae] = opt_calc_iae(time, sp, cv)
    erro = sp - cv;
    dt = diff(time);
    iae = sum(dt.*(abs(erro(1:$-1)) + abs(erro(2:$)))/2);
endfunction

function [cont_copy] = update_controller_copy(scs_m, idx, kp, ki, kd)
    cont_copy = scs_m.objs(idx);

    kp_block = cont_copy.model.rpar.objs(3);
    ki_block = cont_copy.model.rpar.objs(5);
    kd_block = cont_copy.model.rpar.objs(6);

    kp_block.model.rpar = kp;
    ki_block.model.rpar = ki;
    kd_block.model.rpar = kd;

    cont_copy.model.rpar.objs(3) = kp_block;
    cont_copy.model.rpar.objs(5) = ki_block;
    cont_copy.model.rpar.objs(6) = kd_block;
endfunction

function main()
    sp_cont_name = "ContSP"
    dv_cont_name = "ContDV"
    
    loadXcosLibs();
    importXcosDiagram("T1//simulacao-MF-opt.xcos"); // Loads scs_m

    sp_cont_idx = get_block_idx("PID", sp_cont_name, scs_m);
    dv_cont_idx = get_block_idx("PID", dv_cont_name, scs_m);
    
    scs_m.objs(sp_cont_idx) = update_controller_copy(scs_m, sp_cont_idx, 0, 0, 0);
    scs_m.objs(dv_cont_idx) = update_controller_copy(scs_m, dv_cont_idx, 0, 0, 0);
    
    info = scicos_simulate(scs_m);  // loads mod_sp_sp, mod_sp_cv, mod_dv_sp and mod_dv_cv

    // Find best global value for kp
    scs_m.objs(sp_cont_idx).model.rpar.objs(3).model.rpar = 0.001; // Index checked my hand - sp_kp
    scs_m.objs(dv_cont_idx).model.rpar.objs(3).model.rpar = 0.001; // Index checked my hand - sp_kp

    last_sp_off = %inf;
    last_dv_off = %inf;

    last_sp_iae = %inf;
    last_dv_iae = %inf;

    scicos_simulate(scs_m, 4);  // loads mod_sp_sp, mod_sp_cv, mod_dv_sp and mod_dv_cv

    last_sp_off = abs(mod_sp_sp.values($) - sum(mod_sp_cv.values(floor(length(mod_sp_cv.values)/2)+1:$))/(length(mod_sp_cv.values)/2));
    last_dv_off = %inf;

    next_sp_iae = opt_calc_iae(mod_sp_sp.time, mod_sp_sp.values, mod_sp_cv.values)
    next_dv_iae = opt_calc_iae(mod_dv_sp.time, mod_dv_sp.values, mod_dv_cv.values)

    while 0
        kp_sp_cont = kp_sp_cont + 0.001;
        kp_dv_cont = kp_dv_cont + 0.001;

        xcos_simulate(scs_m, 4);  // loads mod_sp_sp, mod_sp_cv, mod_dv_sp and mod_dv_cv

    end
endfunction

main();

/*

This code does not work. Apparently there is no way of changing a xcos simulation from a .sci script.
Thats readly strange, but that's what I found. 

This language had so much potential...

*/

function [g_c, g_v, g_p, g_d, g_m] = get_gs(Kc, tau_i)
    n = 5;
    s = poly(0, 's');

    g_c = syslin('c', Kc*(1 + (1/(tau_i*s))))
    // disp(g_c);
    g_v = syslin('c', 0.02/(s + 1));
    // disp(g_v);
    g_p = syslin('c', (2 + n)/((n*s + 1)*(20*s + 1)));
    // disp(g_p);
    g_d = syslin('c', 1/(10*s + 1));
    // disp(g_d);
    g_m = syslin('c', 2/(0.1*s + 1));
    // disp(g_m);
endfunction

function Gol = get_gol(Kc, tau_i)
    [g_c, g_v, g_p, _, g_m] = get_gs(Kc, tau_i);

    Gol = g_c*g_v*g_p*g_m;
    // disp(g_ol);
endfunction

function [GM, PM] = get_margins(Gol)
    dB_GM = g_margin(Gol);
    GM = 10^(dB_GM/20);
    PM = p_margin(Gol);
endfunction

function is_stable(GM)
    stability = "unstable";

    if GM > 1 then
        stability = "stable";
    end

    mprintf("This system is %s\n", stability);
endfunction

function value = FO(Kc, tau_i)
    Gol = get_gol(Kc, tau_i);
    [GM, PM] = get_margins(Gol);
    value = abs(4 - GM)/4 + abs(45 - PM)/45;
endfunction

function [Kc, tau_i] = PSO(n_particles, iterations, Kc_bounds, tau_i_bounds)
    lb = [Kc_bounds(1); tau_i_bounds(1)];
    ub = [Kc_bounds(2); tau_i_bounds(2)];
    par = length(lb);

    inert      = 0.4;
    antisocial = 1.5;
    social     = 1.5;

    // Init
    positions  = rand(par, n_particles).*repmat(ub - lb, 1, n_particles) + repmat(lb, 1, n_particles);
    velocities = zeros(par, n_particles);

    personal_best = [positions; zeros(1, size(positions, 2))];

    for i=1:n_particles
        Kc    = positions(1, i);
        tau_i = positions(2, i);
        
        personal_best(3, i) = FO(Kc, tau_i);
    end

    [_, idx] = min(personal_best(3, :));
    global_best = personal_best(:, idx);

    // Iterations
    for iter=1:iterations
        
        for i=1:n_particles

            // update velocity
            r1 = rand();
            r2 = rand();
            vel_loss         = inert*velocities(:, i);
            antisocial_gain  = r1*antisocial*(personal_best([1, 2], i) - positions(:, i));
            social_gain      = r2*social*(global_best([1, 2]) - positions(:, i));
            velocities(:, i) = vel_loss + antisocial_gain + social_gain;

            // update current position
            positions(:, i) = positions(:, i) + velocities(:, i);

            // limits
            positions(:, i) = min(max(positions(:, i), lb), ub);

            // current points
            Kc    = positions(1, i);
            tau_i = positions(2, i);
            current_points = FO(Kc, tau_i);

            if current_points < personal_best(3, i) then
                personal_best(:, i) = [Kc; tau_i; current_points];
            end
        end

        // update global best
        [_, idx] = min(personal_best(3, :));
        global_best = personal_best(:, idx);

        // mprintf("Iter %d  Best cost = %f\n", iter, global_best(3));
    end
    
    Kc = global_best(1);
    tau_i = global_best(2);
endfunction

function plot_graph(Kc_bounds, tau_i_bounds)

    Kc = Kc_bounds(1):Kc_bounds(2);
    tau_i = tau_i_bounds(1):tau_i_bounds(2);
    
    [K, T] = ndgrid(Kc, tau_i);
    value = zeros(K);

    for i = 1:size(K, 1)
        for j = 1:size(K, 2)
            value(i, j) = FO(K(i, j), T(i, j));
        end
    end

    surf(Kc, tau_i, value);
    xlabel("Kc");
    ylabel("tau_i");
    zlabel("FO");
    title("Objective Function Surface");

endfunction
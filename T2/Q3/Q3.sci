clear;
clf;

exec("T2//utils.sci");

Kc_bounds = [1, 150];
tau_i_bounds = [1, 150];

[Kc, tau_i] = PSO(50, 125, Kc_bounds, tau_i_bounds);

Gol = get_gol(Kc, tau_i);
[GM, PM] = get_margins(Gol);
value = FO(GM, PM);

mprintf("PSO minimization result\n")
mprintf("Kc:  %f\n", Kc)
mprintf("Tau: %f\n", tau_i)
mprintf("Ki:  %f\n", Kc/tau_i)
mprintf("GM:  %f\n", GM)
mprintf("PM:  %f rads/s\n", PM)
mprintf("FO:  %f\n", FO(Kc, tau_i))

// plot_graph(Kc_bounds, tau_i_bounds)
// bode(Gol, 'rad');
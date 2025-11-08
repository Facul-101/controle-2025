clear;
clf;

exec("T2//utils.sci");

Gol = get_gol(7, 5);

bode(Gol, 'rad');

[GM, PM] = get_margins(Gol);

is_stable(GM);
mprintf("- GM: %f\n", GM);
mprintf("- PM: %f rads/s\n", PM);

disp(Gol);
// This files loads the xcos simulation and gets data from it
exec("T1//scripts//utils.sci");

mprintf("Controllers optimized for step changes\n")
hot_load("T1//simulacao-MF.xcos")

mprintf("Controllers inverted\n")
hot_load("T1//simulacao-MF-inverted.xcos")
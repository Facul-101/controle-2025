// This files loads the xcos simulation and gets data from it
exec("T1//scripts//utils.sci");

mprintf("Controllers optimized for step changes\n")
hot_load("T1//simulacao-MF.zcos")

mprintf("Controllers optimized for step changes on the other end\n")
hot_load("T1//simulacao-MF-inverted.zcos")
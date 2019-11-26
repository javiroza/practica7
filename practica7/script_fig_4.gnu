# Format i nom de la imatge
set term png enhanced
set output "P7-1920-fig4.png"

# Permet escriure lletres gregues i altres mogudes
set encoding utf8

# Mostra els eixos
#set xzeroaxis
#set yzeroaxis

# Títol del gràfic
set title "Energia (t), {/Symbol q}(0)=1 rad {/Symbol w}(0)=0 rad/s"

# Rang dels eixos
set xrange[0:11]
set yrange[0:30]

# Títols dels eixos
set xlabel "Temps, t (s)"
set ylabel "Energia, E (s)"

# Canvia els nombres dels eixos per nombres personalitzats
#set ytics("1x10^-^1^0" 1.00e-10,"1x10^-^0^5" 1.00e-05,"1x10^0" 1.00e+00,"1x10^5" 1.00e+05,"1x10^1^0" 1.00e+10)
#set xtics("1x10^-^3" 1.00e-03,"1x10^-^2" 1.00e-02,"1x10^-^1" 1.00e-01,"1x10^0" 1.00e+00,"1x10^1" 1.00e+01)

# Format dels nombres dels eixos
set format y '%.2f'
set format x '%.2f'

# Escala dels eixos logarítmica
#set logscale y
#set logscale x

# Posició de la llegenda
set key top left

# Plot 
plot "P7-1920-resf.dat" index 4 using 1:4 with points t "E_c_i_n_è_t_i_c_a Euler", \
"P7-1920-resf.dat" index 4 using 1:6 with points t "E_t_o_t_a_l Euler", \
"P7-1920-resf.dat" index 5 using 1:4 with points t "E_c_i_n_è_t_i_c_a Predictor-Corrector", \
"P7-1920-resf.dat" index 5 using 1:6 with points t "E_t_o_t_a_l Predictor-Corrector"
#pause -1

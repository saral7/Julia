# pocetni podaci
m = 70
c_d = 0.25
t = 0:0.5:14
g = 9.81

# racun funkcije brzine - iz dobivenog diferencijanog rjesenja
v = sqrt(g*m/c_d) .* tanh.(sqrt.(g*c_d/m) .* t)

using Plots
plot(t, v, label = "Brzina ovisna o vremenu")
plot!(xlab = "t [s]", ylab = "v [m/s]")

# racun terminalne brzine
v_term = sqrt(g*m/c_d) .* tanh.(sqrt.(g*c_d/m) .* Inf)
v_term = v_term .* ones(length(t))  # asimptot kojoj brzina tezi

plot!(t, v_term, label = "Terminalna brzina")

#savefig("analiticko_rjesenje.png")



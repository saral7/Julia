using DifferentialEquations
using Plots

# a = stopa rasta plijena kad nema grabezljivca
# bx = efikasnost stete grabezljivca_x plijenu
# cx = stopa mortaliteta grabezljivaca_x
# dx = stopa rasta grabezljivaca u interakciji s plijenom_x
# ex = koliko grabezljivac_x moze pojesti odjednom
# K = kapacitet okolisa, gornja granica za plijen
a = 2

b1 = 3
c1 = 0.5
d1 = 0.61 
e1 = 10

b2 = 2
c2 = 0.5
d2 = 0.61
e2 = 10

K = 100

# modificirana funkcija tako da sada plijen lovi jos jedan grabezljivac
function Rosenzweig_MacArthur(du, u, p, t)
   a, b1, c1, d1, e1, b2, c2, d2, e2, K = p
   du[1] = u[1]*(a*(1-u[1]/K)-b1*u[2]/(e1+u[1])-b2*u[3]/(e2+u[1])) # stopa promjene plijena
   du[2] = u[2]*(-c1+d1*u[1]/(u[1]+e1))   # stopa promjene grabezljivca 1
   du[3] = u[3]*(-c2+d2*u[1]/(u[1]+e2))   # stopa promjene grabezljivca 2
end

# parametri
p = (a, b1, c1, d1, e1, b2, c2, d2, e2, K)

u0 = [50.0; 15.0; 10.0]   # za pocetni broj plijena, grabezljivaca1 i grabezljivaca2
tspan = (0.0, 300.0)
problem = ODEProblem(Rosenzweig_MacArthur, u0, tspan, p)
sol = solve(problem)
#plot(sol, vars = (0, 1), label = "Plijen")
#plot!(sol, vars = (0, 2), label = "Grabezljivac 1")
#plot!(sol, vars = (0, 3), label = "Grabezljivac 2")
plot(xlab = "plijen", ylab = "grabezljivac")
plot!(sol, vars = (1, 2), label = "Grabezljivac 1 u ovisnovsi o plijenu")
plot!(sol, vars = (1, 3), label = "Grabezljivac 2 u ovisnovsi o plijenu")

# DODATI KOMENTAR:
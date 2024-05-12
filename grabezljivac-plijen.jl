using DifferentialEquations
using Plots

# a = stopa rasta plijena kad nema grabezljivca
# b = efikasnost stete grabezljivca plijenu
# c = stopa mortaliteta grabezljivaca
# d = stopa rasta grabezljivaca u interakciji s plijenom
a = 2
b = 3
c = 0.5
d = 0.61

K = 100  # kapacitet okolisa, gornja granica za plijen
e = 10   # koliko mogu pojesti (odjednom ??)

# du[1] = dx/dt, du[2] = dy/dt, u[1] = x, u[2] = y
function Lotka_Volterra(du, u, p, t)
   a, b, c, d = p
   du[1] = u[1]*(a-b*u[2])
   du[2] = u[2]*(-c+d*u[1])
end

function Rosenzweig_MacArthur(du, u, p, t)
   a, b, c, d, e, K = p
   du[1] = u[1]*(a*(1-u[1]/K)-b*u[2]/(e+u[1]))
   du[2] = u[2]*(-c+d*u[1]/(u[1]+e))
end

#p = (a, b, c, d)
p = (a, b, c, d, e, K)

u0 = [50.0; 15.0]   # za pocetni broj plijena i grabezljivaca
tspan = (0.0, 300.0)
problem = ODEProblem(Rosenzweig_MacArthur, u0, tspan, p)
sol = solve(problem)
plot(sol, vars = (0, 1), label = "Plijen")
plot!(sol, vars = (0, 2), label = "Grabezljivac")
plot!(xlab = "vrijeme", ylab = "broj")
#plot(sol, vars = (1, 2), label = "Grabezljivac u ovisnovsi o plijenu")
#plot!(xlab = "plijen", ylab = "grabezljivac")
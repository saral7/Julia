# dv/dt = g-c_dv*abs(v)/m-k*(x-L)/m-y*v/m

using Pkg
Pkg.add("DifferentialEquations")


using DifferentialEquations
using Plots
## ulazni podaci
L = 56/2   # duljina uzeta
c_d = 0.25
m = 70
k = 81.4
gamma = 8

## parametri u tuple/vector (?)
p = (L, c_d, m, k, gamma)

## funkcija
skok = function (du, u, p, t)
   L, c_d, m, k, gamma = p
   g = 9.81
   pocetni_put = u[1]
   pocetna_brzina = u[2]
   opruga = 0
   if pocetni_put > L
      opruga = (k/m)*(pocetni_put-L)+(gamma/m)*pocetna_brzina
   end

   du[1] = pocetna_brzina
   du[2] = g-pocetna_brzina*abs(pocetna_brzina)*(c_d/m)-opruga
end


## pocetni utjeti za ODE
u0 = [0.0; 0.0]   # za put i brzinu
tspan = (0.0, 50.0)
problem = ODEProblem(skok, u0, tspan, p)
sol = solve(problem)
display(sol.u)

#plot(sol, title = "Bungee skok")
plot(sol, vars = (0,1), label = "Put", legend = :bottomright)
plot!(sol, vars = (0,2), label = "Brzina")
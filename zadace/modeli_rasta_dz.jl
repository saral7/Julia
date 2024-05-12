using Pkg
Pkg.add("DataFrames")
Pkg.add("CSV")
using DataFrames
using CSV

populacija = CSV.read("zadace//Populacija_zemlja.csv", DataFrame) 
godina = populacija[:,1] 
broj = populacija[:,2]./1e9 

using Plots
#plot(godina, broj, label="Stanovništvo svijeta", legend = :bottomright) # osnovna naredba za plot
#plot!(xlab="vrijeme [god]", ylab="broj stanovnika [milijarde]")
using DifferentialEquations

projekcija = CSV.read("zadace//Projekcija.csv", DataFrame)
god = projekcija[:, 1]
br = projekcija[:, 2]./1e9
plot(god, br, label ="Projekcija")

# PROBLEM: kako prikazati ovo s projekcije i s rj diferencijalnih na istom plotu

# linearni rast
linearni = function(du, u, p, t) 
   du[1] = p
end

tspan = (2020, 2100)
u0 = [7.8]

c = 3
problem = ODEProblem(linearni, u0, tspan, c)
sol = solve(problem)
plot!(sol, vars = (0, 1), label = "Linearni")

# eksponencijalni
eksponencijalni = function(du, u, p, t) 
   du[1] = p*u[1]
end

tspan = (1950, 2020)
u0 = [3]

alfa = 0.06
problem = ODEProblem(eksponencijalni, u0, tspan, alfa)
sol = solve(problem)
#plot!(sol, vars = (0, 1), label = "Eksponencijalni")


# logisticki
function parametri_populacije(alpha, beta)
   K=-(alpha/beta)
   r=alpha
   return r,K
end

r, Kap=parametri_populacije(0.025,-0.0018)

logisticki = function(du, u, p, t) 
   K, al = p
   du[1] = u[1]*al*(1-u[1]/K)
end

tspan = (1950, 2020)
u0 = [3]

p = Kap, r
problem = ODEProblem(logisticki, u0, tspan, p)
sol = solve(problem)
plot(sol, vars = (0, 1), label = "Logisticki")

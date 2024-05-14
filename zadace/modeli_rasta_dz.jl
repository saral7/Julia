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

## linearni rast
linearni = function(du, u, p, t) 
   du[1] = p
end

tspan = (2020, 2100)
u0 = [7.8]  # toliko je milijarda ljudi bilo u 2020

c = (broj[nrow(populacija)]-broj[1])/nrow(populacija) # nagib je prosjecni rast u podacima koje imamo (populacija)
problem = ODEProblem(linearni, u0, tspan, c)
sol = solve(problem)
plot(god, br, label ="Projekcija")
plot!(sol, vars = (0, 1), label = "Linearni")

# KOMENTAR: na pocetku se model slaze s predikcijom (do negdje 2033), ali nakon toga beskonacno raste sto nije realno


## eksponencijalni
eksponencijalni = function(du, u, p, t) 
   du[1] = p*u[1]
end

tspan = (2020, 2100)
u0 = [7.8]

alfa = (broj[nrow(populacija)]-broj[nrow(populacija)-1])/broj[nrow(populacija)-1]  # broj dobiven na temelju zadnjih podataka iz populacije
alfa = 0.0085
problem = ODEProblem(eksponencijalni, u0, tspan, alfa)
sol = solve(problem)
plot(god, br, label ="Projekcija")
plot!(sol, vars = (0, 1), label = "Eksponencijalni")

# KOMENTAR: ovaj je model najlosiji i jedva prati projekciju na pocetku, nije realan bas za ovaj problem
#  jer ljudska populacija ne raste eksponencijalno u beskonacnost
#  malo je bolje ako uzmemo recimo alfa = 0.0085, ali nemamo neki razlog za objasniti zasto

## logisticki
function parametri_populacije(alpha, beta)
   K=-(alpha/beta)
   r=alpha
   return r,K
end

r, Kap=parametri_populacije(0.04338,-0.004)

logisticki = function(du, u, p, t) 
   al, K = p
   du[1] = u[1]*al*(1-u[1]/K)
end
tspan = (2020, 2100)
u0 = [7.8]

p = r, Kap
problem = ODEProblem(logisticki, u0, tspan, p)
sol = solve(problem)
plot(god, br, label ="Projekcija")
plot!(sol, vars = (0, 1), label = "Logisticki")

# KOMENTAR: s ovim parametrima sam dobila projekciju najslicniju UN-ovoj, nisam znala kako ih odrediti iz podataka
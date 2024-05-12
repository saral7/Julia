# dv/dt = g-c_dv*abs(v)/m-k*(x-L)/m-y*v/m

using Pkg
Pkg.add("DifferentialEquations")


using DifferentialEquations
using Plots
## ulazni podaci
L = 56/2   # duljina uzeta, jer na https://www.izazov-tours.hr/ pise da je visina 56m, a uze se moze jos protegnuti duplo
c_d = 0.25
gamma = 8


## funkcija skoka, s predavanja
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


## pocetni uvjeti za ODE
u0 = [0.0; 0.0]   # za put i brzinu
tspan = (0.0, 50.0)


#IDEJA ZA ODREDITI K: raditi binary search za konstantu elasticnosti i provjeravati koliko je dobro, je li premalo ili previse

masses = [60, 65, 70, 75, 80]
k_vals = []

for j=1:length(masses) 
   k_min = 1 
   k_max = 2000
   k_mid = 0
   epsilon = 2    # dodala sam ovo zato da bude sigurno ispod 56; nekad je zbog nepreciznosti znalo preci preko 56m
   for i=0:700
      k_mid = (k_max+k_min)/2
      p = (L, c_d, masses[j], k_mid, gamma)
      problem = ODEProblem(skok, u0, tspan, p)
      sol = solve(problem)

      global maxVal = 0

      # trazenje najvece visine (dubine zapravo) do koje dolazimo s ovim k=k_mid
      for i=1:length(sol)
         global maxVal
         maxVal = max(sol[i][1], maxVal)
      end

      #display(maxVal)
      if (maxVal >= 56-epsilon)
         k_min = k_mid # treba jace pritegnuti
      else
         k_max = k_mid # treba slabije pritegnuti
      end
   end

   
   println("Potreba konstanta elasticnosti za ", masses[j], "kg je ",k_mid, "N/m")
   
   append!(k_vals, k_mid);
   
   
end

Plots.default(show = true)
L_range = 56 .* ones(length(0:0.1:50))    # samo da mogu nacrtati "asimptotu" (na 56m)
plot(L_range)

# iz nekog razloga se plot nije prikazivao kad sam u for-petlji dodavala za pojedine kilaze, pa sam napisala ovako :(


# vidimo da sto je veca masa, treba biti veca konstanta elasticnosti (valjda da jace "zadrzi")
i = 1
p = (L, c_d, masses[i], k_vals[i], gamma)
problem = ODEProblem(skok, u0, tspan, p)
sol2 = solve(problem)
plot!(sol2, vars = (0,1), label = string("Put za masu od ", masses[i], "kg"), legend = :bottomright)

i = 2
p = (L, c_d, masses[i], k_vals[i], gamma)
problem = ODEProblem(skok, u0, tspan, p)
sol2 = solve(problem)
plot!(sol2, vars = (0,1), label = string("Put za masu od ", masses[i], "kg"), legend = :bottomright)

i = 2
p = (L, c_d, masses[i], k_vals[i], gamma)
problem = ODEProblem(skok, u0, tspan, p)
sol2 = solve(problem)
plot!(sol2, vars = (0,1), label = string("Put za masu od ", masses[i], "kg"), legend = :bottomright)

i = 3
p = (L, c_d, masses[i], k_vals[i], gamma)
problem = ODEProblem(skok, u0, tspan, p)
sol2 = solve(problem)
plot!(sol2, vars = (0,1), label = string("Put za masu od ", masses[i], "kg"), legend = :bottomright)

i = 4
p = (L, c_d, masses[i], k_vals[i], gamma)
problem = ODEProblem(skok, u0, tspan, p)
sol2 = solve(problem)
plot!(sol2, vars = (0,1), label = string("Put za masu od ", masses[i], "kg"), legend = :bottomright)

i = 5
p = (L, c_d, masses[i], k_vals[i], gamma)
problem = ODEProblem(skok, u0, tspan, p)
sol2 = solve(problem)
plot!(sol2, vars = (0,1), label = string("Put za masu od ", masses[i], "kg"), legend = :bottomright)

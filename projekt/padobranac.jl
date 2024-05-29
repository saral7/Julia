using Plots
using DifferentialEquations

jump = function(du, u, p, t) 
   C, ro, A, g, m, t_parachute, A_parachute = p

   if (u[2] < 1e-6) 
      du[2] = 0
      u[1] = 0
   else 
      if (t >= t_parachute)
         A = A_parachute
      end
      du[1] = (C*ro*A/(2*m)) * u[1] * u[1] - g
      du[2] = u[1]
   end
   
end


# pocetne vrijednosti
C = 0.42
ro = 1.225
m = 70
g = 9.81
A = 0.7
t_parachute = 40
A_parachute = 50

tspan = (0, 400)
p = (C, ro, A, g, m, t_parachute, A_parachute)
u0 = [0, 3000]

problem = ODEProblem(jump, u0, tspan, p)
sol = solve(problem)

plot(sol, vars = (0, 1), label = "Brzina tijekom vremena")
plot(sol, vars = (0, 2), label = "Polozaj tijekom vremena")
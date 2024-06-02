using Plots
using DifferentialEquations

jump = function(du, u, p, t) 
   C, ro, A, g, m, t_parachute, A_parachute, F_wind = p

   # provjeravam jesmo li blizu tlu
   if (u[2] < 1e-6)     # ako da, brzina pada na 0, polozaj (visina) se ne mijenja
      du[2] = 0         # promjena polozaja (visine)
      u[1] = 0          # brzina u y-smjeru

      u[3] = 0          # brzina u x-smjeru postane 0
      du[4] = 0         # polozaj (x-smjer) se ne mijenja
   else 
      du[3] = -(C*ro*p[3]/(2*m)) * u[3] * u[3] + F_wind/m   # promjena brzine u x-smjeru
      du[4] = u[3]                                          # promjena polozaja u x-smjeru
      # provjeravam jesmo li otvorili padobran
      if (t >= t_parachute)   # ako da, povrsina A je zapravo povrsina padobrana
         A = A_parachute * min(1, (t-t_parachute)/3)
      end
      du[1] = (C*ro*A/(2*m)) * u[1] * u[1] - g     # promjena brzine u y-smjeru
      du[2] = u[1]                                 # promjena polozaja (visine)

   end
   
end

# funkcija koja vraca par (t1, t2) 
# t1 = najkasniji trenutak da se otvori padobran, a da se i dalje sleti terminalnom brzinom s otvorenim padobranom
# t2 = kada otvoriti padobran, a da se leti barem time_wished sekundi

   # ideja je raditi binarno pretrazivanje po trenutcima otvaranja (sto kasnije se otvori padobran)
   # ranije ce se doci do tla
function whenToOpenParachute(p, u0, time_wished) 
   C, ro, A, g, m, A_parachute, F_wind = p

   t_min = 0 
   t_max = 10000
   t_mid = 0
   tspan = (0, t_max)
   p2 = (C, ro, A, g, m, 1, A_parachute, F_wind)
   epsilon = 2    # offset, za greske
   v_term = sqrt(2*m*g/(C*ro*A_parachute))      # vrijednost terminalne brzine s otvorenim padobranom
   
   # binarno pretrazivanje za zadnji trenutak otvaranja za pristojno slijetanje
   for i=1:1:30
      t_mid = (t_min+t_max)/2    # t_mid = trenutna opcija za trenutak
      p2 = (C, ro, A, g, m, t_mid, A_parachute, F_wind)

      problem = ODEProblem(jump, u0, tspan, p2)
      sol = solve(problem)

      t_kon = t_max
      v_kon = 1e7

      # nadi trenutak prije nego sto dode to tla (tj. kada visina, odnosno sol[j][2] manja od nekog malog epsilona)
      for j=5:length(sol.t)   
         if ((sol.t[j] > 2 && sol[j][2] < epsilon) || j == length(sol.t))
            v_kon = abs(sol[j-1][1])
            t_kon = sol.t[j-1]
            break
         end
      end

      if (abs(v_kon-v_term) > epsilon)
         t_max = t_mid     # ako je prevelika brzina slijetanja, znaci da smo vec sletjeli prije nego sto smo otvorili padobran, treba ranije
      else
         t_min = t_mid     # inace pokusajmo s kasnijim vremenom (povecaj lijevu granicu)
      end
   end
   
   t1 = t_mid

   t_min = 0
   t_max = 10000
   t_mid = 0
   p2 = (C, ro, A, g, m, 1, A_parachute, F_wind)
   
   # nadi zadnji trenutak za otvorit padobran da bismo letjeli barem time_wished sekundi
   for i=1:1:30
      t_mid = (t_min+t_max)/2
      p2 = (C, ro, A, g, m, t_mid, A_parachute, F_wind)

      problem = ODEProblem(jump, u0, tspan, p2)
      sol = solve(problem)

      t_kon = 0

      # nadi trenutak prije nego sto dode to tla (tj. kada visina, odnosno sol[j][2] manja od nekog malog epsilona)
      for j=5:length(sol.t)
         if (sol.t[j] > 2 && sol[j][2] < epsilon)
            t_kon = sol.t[j-1]
            break
         end
      end

      if (t_kon-time_wished > epsilon)
         t_min = t_mid     # ako smo letjeli duze od zeljenog, znaci da mozemo probati kasnije otvoriti padobran
      else
         t_max = t_mid     # inace moramo ipak ranije (pomicemo desnu granicu)
      end
   end

   t2 = t_mid

   return (t1, t2)
end


# pocetne vrijednosti
C = 0.82    # drag coefficient: modeliram covjeka kao long-cilinder: https://en.wikipedia.org/wiki/Drag_coefficient
ro = 1.225  # gustoca zraka, https://en.wikipedia.org/wiki/Density_of_air
m = 75      # masa covjeka sa svom opremom
g = 9.81
A = 0.7     # povrsina tijela okomita na smjer brzine
A_parachute = 30  # povrsina padobrana
F_wind = 15

# poziv funkcije za optimiranje trenutaka otvaranja padobrana
param = (C, ro, A, g, m, A_parachute, F_wind)
u0 = [0, 3000, 240, 0]     # pocetni uvjeti: v0 u y smjeru, pocetna visina, v0 u x smjeru, pocetni x-polozaj
t_wished = 300
t1, t2 = whenToOpenParachute(param, u0, t_wished)
println("Za lijepo slijetanje najkasnije otvoriti padobran u ", t1, " sekundi,",
 "a za let duljine barem ", t_wished, " sekundi otvoriti padobran najkasnije u ", t2, " sekundi")



t_parachute = 26   # trenutak od pocetka skoka otvaranja padobrana 
tspan = (0, 400)
p = (C, ro, A, g, m, t_parachute, A_parachute, F_wind)
u0 = [0, 3000, 240, 0]

problem = ODEProblem(jump, u0, tspan, p)
sol = solve(problem)

# plotovi, moze sluziti za provjeru rjesenja koje je dala pozvana funkcija whenToOpenParachute
plot(sol, vars = (0, 1), label = "Brzina (y-smjer) tijekom vremena", xaxis = "vrijeme [s]", yaxis = "brzina [m/s]")
plot(sol, vars = (0, 2), label = "Visina tijekom vremena", xaxis = "vrijeme [s]", yaxis = "visina [m]")
plot(sol, vars = (0, 3), label = "Brzina (x-smjer) tijekom vremena", xaxis = "vrijeme [s]", yaxis = "brzina [m/s]")
plot(sol, vars = (0, 4), label = "Polozaj (x-smjer) tijekom vremena", xaxis = "vrijeme [s]", yaxis = "pomak [m]")

plot(sol, vars = (4, 2), label = "Putanja", xaxis = "polozaj (x-smjer) [m]", yaxis = "visina [m]")

rotation = @animate for i = 0:90
   plot(sol, vars = (4, 2, 0), label = "Prikaz svih vrijednosti", camera = (i, i), xaxis = "polozaj (x-smjer) [m]", yaxis = "visina [m]", zaxis = "vrijeme [s]")
end

gif(rotation, "3d_rotation.gif")
# source: https://docs.juliaplots.org/stable/


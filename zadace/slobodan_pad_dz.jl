# sada numericko rjesenje - racunamo dv/dt = (v(t_i+1)-v(t_i))/(t_i+1 - t_i) = g-c_d*v(t_i)^2/m
# v(t_i+1) = v(t_i) + dv/dt(t_i+1 - t_i), nova = stara + nagib*korak :)

import Pkg

# pocetni podaci
global m = 70
global c_d = 0.25
global t = 0:0.5:14
global g = 9.81

function dv_dt(v_i) 
   #return g-c_d*v_i^2/m
   return g - c_d*v_i*abs(v_i)/m # cooler jer je uvijek suprotno od smjera brzine, a ne negativno
end

function brzina(v0, dt, tp, tk)  # nama su zadane dvije tocke (tp i tk), 
                                 # kazemo na koju velicinu koraka zelimo napraviti (dt)
                                 # podijelimo na te korake i iterativno updateamo brzinu
   n = (tk-tp)/dt    # broj koraka
   vi = v0
   ti = tp

   for i=1:n
      dvdt = dv_dt(vi)  # novi nagib
      vi = vi+dvdt*dt   # nova brzina
      ti = ti+dt        # novi trenutak
   end
   return vi            # konacna brzina
end


#rez = brzina(0, 1, 0, 14)
#display(rez)

function brzina2(v0, dt, tp, tk)
   vi = v0
   ti = tp
   s = dt

   brzine = zeros(0)          # zasad vektor duljine nula (prazan)
   vrijeme = zeros(0)         # vektori koji ce se koristiti za plotanje
   put = zeros(0)
   p = 0
   while true
      if (ti+dt > tk)         # da ne uzme korak preko konacnog vremena
         s = tk-ti            # uzmes koliko ti je ostalo
      end

      dvdt = dv_dt(vi)

      append!(brzine, vi)     # nadostukaj novu brzinu u vektor
      append!(vrijeme, ti)    
      append!(put, p)

      p = p-vi*s              # aproksimiramo put na kratkom intervalu ovako (??)
      vi = vi + dvdt*s
      ti = ti+s

      if (ti >= tk)
         break
      end
   end

   append!(brzine, vi)     # one zadnje koje nisu upale u whileu
   append!(vrijeme, ti)    
   append!(put, p)

   return vi, brzine, vrijeme, put

end

v_kon, brzine, vrijeme, put = brzina2(0, 0.5, 0, 14)



using Plots 
plot(vrijeme, brzine, label = "Brzina u vremenu - numericki")

# DZ - racun prijedenog puta, stavila sam da bude apsolutna vrijednost, ljepse se ostali rezultati vide kada se makne
plot!(vrijeme, abs.(put), label = "Put u vremenu")

# racun funkcije brzine - iz dobivenog diferencijanog rjesenja
v = sqrt(g*m/c_d) .* tanh.(sqrt.(g*c_d/m) .* t)

plot!(t, v, label = "Brzina u vremenu - analiticki")
plot!(xlab = "t [s]", ylab = "v [m/s]")

# DZ - racun i prikaz relativne pogreske
pogreska_rel = abs.(v .- brzine)./v * 100.0
show(pogreska_rel)
plot!(vrijeme, pogreska_rel, label = "Relativna pogreska")

# racun terminalne brzine
v_term = sqrt(g*m/c_d) .* tanh.(sqrt.(g*c_d/m) .* Inf)
v_term = v_term .* ones(length(t))  # asimptota kojoj brzina tezi

plot!(t, v_term, label = "Terminalna brzina")




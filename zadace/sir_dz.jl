using Plots
using DifferentialEquations

# pocetni podaci
#=
𝛽 – stopa zaraze
𝛾 – stopa oporavka
S – broj podložnih bolesti
I – broj zaraženih
R – broj oporavljenih
N – ukupan broj jedinki
=#

# preuzeto s izvora: https://www.hzjz.hr/sluzba-epidemiologija-zarazne-bolesti/gripa-u-hrvatskoj-u-sezoni-2018-2019-14-4-2019/



# 1) SIR
S = 18380  
I = 100
R = 0 
k = 12
b = 0.03 
t_oporavka = 19
N = S+I+R 
beta = (k*b)/N 
gamma = 1/t_oporavka

# KOMENTAR: s ovim parametrima mi krivulja najsličnije izgleda,
#  bilo je ukupno zaraženo oko 18480 ljudi pa sam to uzela kao N, 
#  te da oporavaka traje 19 dana, a stopa zaraze je 0.03

SIR = function(du, u, p, t) # S=u[1], I=u[2], R=u[3]
   beta, gamma = p
   du[1] = -beta*u[1]*u[2]
   du[2] = beta*u[1]*u[2]-gamma*u[2]
   du[3] = gamma*u[2]
end

p = (beta, gamma)
u0 = [S; I; R]
tspan = (0, 25*7)
problem = ODEProblem(SIR, u0, tspan, p)
sol = solve(problem)

#plot(sol, vars = (0, 1), label = "Podlozni")
plot(sol, vars = (0, 2), label = "Zarazeni")
#plot!(sol, vars = (0, 3), label = "Oporavljeni")


# 2) SIRS

S = 18380 
I = 100
R = 0 
k = 12
b = 0.03 
t_oporavka = 19
N = S+I+R 
beta = (k*b)/N 
gamma = 1/t_oporavka
delta = 0.001  # stopa gubitka imuniteta, jako mala

SIRS = function(du, u, p, t) # S=u[1], I=u[2], R=u[3]
   beta, gamma, delta = p
   du[1] = -beta*u[1]*u[2] + delta*u[3]
   du[2] = beta*u[1]*u[2]-gamma*u[2]
   du[3] = gamma*u[2] - delta*u[3]
end

p = (beta, gamma, delta)
u0 = [S; I; R]
tspan = (0, 25*7)
problem = ODEProblem(SIRS, u0, tspan, p)
sol = solve(problem)
plot(sol, vars = (0, 2), label = "Zarazeni")

# KOMENTAR: svi podaci su isti kao za SIR, osim delte koji je jako mali 
#  jer ljudi ne gube bas imunitet od gripe (bar ne u toj godini)




# 3) SIR + demografija

S = 18380 
I = 100
R = 0 
k = 10
b = 0.04 
t_oporavka = 19
N = S+I+R 
beta = (k*b)/N 
gamma = 1/t_oporavka
ni = 0.0089 # stopa nataliteta
mi = 0.0127 # stopa mortaliteta
# preuzeto sa: https://web.dzs.hr/Hrv_Eng/publication/2020/07-01-01_01_2020.htm

SIR_demografija = function(du, u, p, t) # S=u[1], I=u[2], R=u[3]
   beta, gamma, ni, mi = p
   du[1] = -beta*u[1]*u[2] + ni*(u[1]+u[2]+u[3]) - mi*u[1]
   du[2] = beta*u[1]*u[2] - gamma*u[2] - mi*u[2]
   du[3] = gamma*u[2] - mi*u[3]
end

p = (beta, gamma, ni, mi)
u0 = [S; I; R]
tspan = (0, 25*7)
problem = ODEProblem(SIR_demografija, u0, tspan, p)
sol = solve(problem)
plot(sol, vars = (0, 2), label = "Zarazeni")

# KOMENTAR: mislim da zbog nataliteta krivulja ne tezi u 0 (nisam uspjela postici to)
#  mozda treba staviti mi = ni 


# 4) SIR + demografija + cijepljenje

S = 18380 
I = 100
R = 0 
k = 10
b = 0.04 
t_oporavka = 19
N = S+I+R 
beta = (k*b)/N 
gamma = 1/t_oporavka
ni = 0.0089 # stopa nataliteta
mi = 0.0127 # stopa mortaliteta
kapa = 0.003 # stopa cijepljenja rodenih

SIR_demografija_cijepljenje = function(du, u, p, t) # S=u[1], I=u[2], R=u[3]
   beta, gamma, ni, mi, kapa = p
   du[1] = -beta*u[1]*u[2] + (ni-kapa)*(u[1]+u[2]+u[3]) - mi*u[1]
   du[2] = beta*u[1]*u[2] - gamma*u[2] - mi*u[2]
   du[3] = gamma*u[2] - mi*u[3]
end

p = (beta, gamma, ni, mi, kapa)
u0 = [S; I; R]
tspan = (0, 25*7)
problem = ODEProblem(SIR_demografija_cijepljenje, u0, tspan, p)
sol = solve(problem)
plot(sol, vars = (0, 2), label = "Zarazeni")


# 5) SEIR

S = 18380 
I = 150
R = 0 
k = 10
b = 0.04 
t_oporavka = 19
v = 0.95  # stopa prijelaza iz E u I
E = 200  # zarazeni ali ne zarazni
N = S+I+R+E 
beta = (k*b)/N 
gamma = 1/t_oporavka
ni = 0.0089 # stopa nataliteta
mi = 0.0127 # stopa mortaliteta
# preuzeto sa: https://web.dzs.hr/Hrv_Eng/publication/2020/07-01-01_01_2020.htm
kapa = 0.003 # stopa cijepljenja rodenih

SEIR = function(du, u, p, t) # S=u[1], I=u[2], R=u[3], E=u[4]
   beta, gamma, ni, mi, kapa, v = p
   du[1] = -beta*u[1]*u[2] + (ni-kapa)*(u[1]+u[2]+u[3]+u[4]) - mi*u[1]
   du[2] = v*u[4] - gamma*u[2] - mi*u[2]
   du[3] = gamma*u[2] - mi*u[3]
   du[4] = beta*u[1]*u[2] - v*u[4] - mi*u[4]
end

p = (beta, gamma, ni, mi, kapa, v)
u0 = [S; I; R; E]
tspan = (0, 25*7)
problem = ODEProblem(SEIR, u0, tspan, p)
sol = solve(problem)
plot(sol, vars = (0, 2), label = "Zarazeni")


# KOMENTAR: u posljednja tri nisam uspjela postici da dode do 10000 zarazenih u maksimumu
# ali sam otprilike pogodila kada je maksimum i kada dospije do 0
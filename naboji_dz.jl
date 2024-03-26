# Zadatak:
# upisati broj pozitivnih i negativnih, random popuniti koordinate, nacrtati polje

using Random

eps0 = 8.854e-12
k = 1/(4*pi*eps0)

# funkcija za generiranje random broja iz intervala (minVal, maxVal)
function randNum(minVal, maxVal)
   return (maxVal-minVal)*Random.rand()+minVal
end

# broj pozitivnih
N = 6
# broj negativnih
M = 2

# vrijednosti naboja
Q1 = +20
Q2 = -20

# granice mreze
minX = -5
minY = -5
maxX = 5
maxY = 5
# broj podjela mreze
K = 20

# x-os i y-os, range
xAxis = range(minX, maxX, length = K)
yAxis = range(minY, maxY, length = K)

# stvaranje mreze
xG = ones(K) .* xAxis'
yG = yAxis .* ones(K)'   # TODO: obrnuti yG

# stvaranje naboja
pozX = Vector()
pozY = Vector()
negX = Vector()
negY = Vector()

# generiranje koordinata pozitivnih
for i = 1:1:N
   push!(pozX, randNum(minX, maxX))
   push!(pozY, randNum(minY, maxY))
end

# generiranje koordinata negativnih
for i = 1:1:M
   push!(negX, randNum(minX, maxX))
   push!(negY, randNum(minY, maxY))
end

# KxK matrica nula
Ex = zeros(K, K) 
Ey = zeros(K, K)

# racunanje za mrezu polja od pozitivnih naboja
for i=1:1:N
   Rx = xG .- pozX[i]
   Ry = yG .- pozY[i]
   R = sqrt.(Rx.^2 + Ry.^2).^3
   global Ex += k .* Q1 .* Rx ./ R
   global Ey += k .* Q1 .* Ry ./ R
end

# racunanje za mrezu polja od negativnih naboja
for i=1:1:M
   Rx = xG .- negX[i]
   Ry = yG .- negY[i]
   R = sqrt.(Rx.^2 + Ry.^2).^3
   global Ex += k .* Q2 .* Rx ./ R
   global Ey += k .* Q2 .* Ry ./ R
end

E = sqrt.(Ex.^2 + Ey.^2)
u = Ex./E
v = Ey./E

# vizualizacija
using Plots
Plots.scatter([pozX, negX], [pozY, negY], label = ["Pozitivni" "Negativni"], aspect_ratio=:equal)
println("ispis")
for i=1:K
   display(quiver!(xG[i,:], yG[i,:], quiver = (u[i, :]/3, v[i,:]/3))) # quiver je za strelice
end





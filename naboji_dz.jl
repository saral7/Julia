using Random

eps0 = 8.854e-12
k = 1/(4*pi*eps0)

function randNum(minVal, maxVal)
   return (maxVal-minVal)*Random.rand()+minVal
end
# broj pozitivnih
N = 5
# broj negativnih
M = 5

Q1 = +20
Q2 = -20
# Zadatak:
# upisati broj pozitivnih i negativnih, random popuniti koordinate, nacrtati polje

minX = -5
minY = -5
maxX = 5
maxY = 5
K = 30

xAxis = range(minX, maxX, length = K)
yAxis = range(minY, maxY, length = K)

xG = ones(K) .* xAxis'
yG = yAxis .* ones(K)'   # TODO: obrnuti yG


# stvaranje naboja
pozX = Vector()
pozY = Vector()
negX = Vector()
negY = Vector()
for i = 1:1:N
   push!(pozX, randNum(minX, maxX))
   push!(pozY, randNum(minY, maxY))
end
for i = 1:1:M
   push!(negX, randNum(minX, maxX))
   push!(negY, randNum(minY, maxY))
end

#println(pozX)
#println(pozY)
#println(negX)
#println(negY)

# 
Ex = xG .* 0
Ey = yG .* 0

for i=1:1:N
   Rx = xG .- pozX[i]
   Ry = yG .- pozY[i]
   R = sqrt.(Rx.^2 + Ry.^2)
   global Ex += k .* Q1 .* Rx ./ R
   global Ey += k .* Q1 .* Ry ./ R
end

for i=1:1:M
   Rx = xG .- negX[i]
   Ry = yG .- negY[i]
   R = sqrt.(Rx.^2 + Ry.^2)
   global Ex += k .* Q2 .* Rx ./ R
   global Ey += k .* Q2 .* Ry ./ R
end

E = sqrt.(Ex.^2 + Ey.^2)
#println(Ex) # Ex puno veci pa ispadne 1
#println(Ey)
#println(E)
u = Ex./E
v = Ey./E

Plots.scatter([pozX, negX], [pozY, negY], label = "Pozitivni", aspect_ratio=:equal)
println("ispis")
for i=1:K
   display(quiver!(xG[i,:], yG[i,:], quiver = (u[i, :]/5, v[i,:]/5))) # quiver je za strelice
end





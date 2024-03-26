# konstante
eps0 = 8.854e-12
k = 1/(4*pi*eps0)

# prvi naboja
x1 = 0.5
y1 = 0
Q1 = -20
# drugi naboja
x2 = -0.5
y2 = 0
Q2 = +20

# parametri za mrezu (mesh)
N = 30
minX = -2
maxX = 2
minY = -2
maxY = 2
x = range(minX, maxX, length = N) # doslovno kao za for petlju - poc:korak:kraj
y = range(minY, maxY, length = N) # sad su x i y vektori

# matrica
display(x')

xG = x' .* ones(N) # x' = x transponirano
yG = ones(N)' .* y

# za prvi naboj
Rx = xG .- x1
Ry = yG .- y1
R = sqrt.(Rx.^2 + Ry.^2)

Ex = k .* Q1 .* Rx./R
Ey = k .* Q1 .* Ry./R

# dodamo drugi naboj
Rx = xG .- x2
Ry = yG .- y2
R = sqrt.(Rx.^2 + Ry.^2).^3

Ex += k .* Q2 .* Rx./R
Ey += k .* Q2 .* Ry./R

E = sqrt.(Ex.^2 + Ey.^2).^3
u = Ex./E
v = Ey./E

using Plots
gr()
#arrX1 = [1, 1]
#arrY1 = [1, -1]
#arrX2 = [0.5, 1]
#arrY2 = [-0.5, -0.5]
#Plots.scatter([arrX1, arrX2], [arrY1, arrY2], label = "Naboj", aspect_ratio=:equal)
Plots.scatter([x1 x2], [y1, y2], label = "Naboj", aspect_ratio=:equal)
for i=1:N
   display(quiver!(xG[i,:], yG[i, :], quiver = (u[i, :]/4, v[i,:]/4))) # quiver je za strelice
end

savefig("tockasti_naboj.png")
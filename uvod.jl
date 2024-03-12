println("Hello world")
15+5
20-13

## 
println("bok world")
println("bok")
##
ime = "gs"
ime
tezina = 21.3
godine = 21
tezina
##
1.5e-2
##
racBroj = 10//6
denominator(racBroj)
##
2^4
a = 7
b = 5
kol = b // a
println(kol+1.4)
##
function nekaj(a, b=15; c, d=4)
   return a + b - c - d
end

println(nekaj(a=1, c=3))
#println(nekaj(1, 3, 4, 2))

##
for i=1:2:21
   println(i)
end

##

using Pkg
Pkg.status()   # ispise ti pakete koje imas
# Pkg.update()   # 
# Pkg.add("Plots")  # skini Plots
using Plots
x = 1:0.1:2*pi

for i=x        # COOL
   println(i)
end

y = cos.(x)
println(y)

##
x = y = 1
##
15 = a
##
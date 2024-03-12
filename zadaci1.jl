##
x = y = 1
x
y
##
# 15 = a, ne moze se
##

function volumen(a, objekt)
   if (objekt == "sfera")
      return (4/3)*pi*a^3
   end
   if (objekt == "kocka")
      return a^3
   end
   print("Nije moguce izracunati")
end

volumen(2, "kocka")
volumen(2, "sfera")
volumen(2, "nesto")

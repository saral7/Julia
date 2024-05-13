## 1
x = y = 1
x
y
# odgovor: x i y iznose 1

## 2
15 = a
# dobijemo error

## 3
xy
# xy je oznaka neke druge varijable, a x*y umnozak

## 4 funkcija
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

## 5
function myAbs(x) 
   if (x < 0) 
      return -x
   else 
      return x
   end
end

myAbs(8)
myAbs(-8)

## 6
function dist(x1, y1, x2, y2) 
   return sqrt((x2-x1)^2 + (y2-y1)^2)
end

dist(1, 2, -2, 6)

## 7
for i=1:30
   if (i%3 != 0)
      println(i)
   end
end

## 8
cnt = 0
for i="Volim studirati u Zagrebu"
   if (i == 'a' || i == 'A')
      cnt += 1
   end
end

println(cnt)
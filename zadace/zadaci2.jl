## moze i tu bok

## 1
function transform(temp, type)
   if (type == "Fahrenheit")
      return temp*1.8+32
   end
   if (type == "Kelvin")
      return temp+274.15
   end
end

transform(10, "Fahrenheit")
transform(10, "Kelvin")

## 2
# a, b = katete, c = hipotenuza
function area(a, b, c)
   if (c == -1) # nepoznata hipotenuza
      return a*b*0.5
   end
   a = max(a, b) # nepoznata neka kateta, u a spremamo poznatu
   return a*sqrt(c^2-a^2)*0.5
end

area(4, 6, -1)
area(-1, 4, 5)
area(6, -1, 10)

## 3
function area2(a, b, c)
   s = 0.5*(a+b+c)
   return sqrt(s*(s-a)*(s-b)*(s-c))
end

area2(5, 5, 6)
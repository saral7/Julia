using Pkg
Pkg.add("DataFrames")
using DataFrames


torba = DataFrame(
   predmet = ["olovka", "biljeznica"],
   kolicina = [3, 5],
   opis = ["crvena olovka", "na crte"]
)

show(torba)    # jako cool

Pkg.add("CSV")
using CSV

population = CSV.read("Populacija_zemlja.csv", DataFrame)

year = population(:,1)  # sve iz prvog stupca
num = population(:,2)./1e9   # sve iz drugog stupca

# plotaj onda

## DOVRSIIII
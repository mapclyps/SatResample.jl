#some shortcuts for comon grids in polar remote sensing
"""
	NSIDCN(n)

generate the _National Snow and Ice Data Center_ North polar stereographic grid 
for a given resolution `n` in m
"""
NSDICN(n)=Grid(Proj4.Projection(Proj4.epsg[3411]),(-3850,3750).*1e3,(-5350,3850).*1e3,n)

"""
	NSDICS(n)

generate the _National Snow and Ice Data Center_ South polar stereographic grid
for a given resolution `n` in m
"""
NSDICS(n)=Grid(Proj4.Projection(Proj4.epsg[3412]),(-3950,3950).*1e3,(-3950,4350).*1e3,n)

"""
	EASE2N(n)

generate the _National Snow and Ice Data Center_ North EASE2 grid
for a given resolution `n` in m
"""
EASE2N(n)=Grid(Proj4.Projection(Proj4.epsg[6931]),(-9e6, 9e6),(-9e6, 9e6),n)

"""
	EASE2N(n)

generate the _National Snow and Ice Data Center_ South EASE2 grid
for a given resolution `n` in m
"""
EASE2S(n)=Grid(Proj4.Projection(Proj4.epsg[6932]),(-9e6, 9e6),(-9e6, 9e6),n)
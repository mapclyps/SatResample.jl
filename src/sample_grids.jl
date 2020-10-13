#some shortcuts for common grids in polar remote sensing
"""
	NSIDCN(n)

generate the _National Snow and Ice Data Center_ North polar stereographic grid 
for a given resolution `n` in m
"""
NSIDCN(n)=Grid(Proj4.Projection(Proj4.epsg[3413]),(-3850,3750).*1e3,(-5350,5850).*1e3,n)

"""
	NSDICS(n)

generate the _National Snow and Ice Data Center_ South polar stereographic grid
for a given resolution `n` in m
"""
NSIDCS(n)=Grid(Proj4.Projection(Proj4.epsg[3976]),(-3950,3950).*1e3,(-3950,4350).*1e3,n)

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
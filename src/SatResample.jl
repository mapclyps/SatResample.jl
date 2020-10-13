"""
`SatResample` -- conventiently resample satellite data to common local grids.
"""
module SatResample

# Write your package code here.
using Proj4
using NearestNeighbors
using Statistics
using StaticArrays

include("sample_grids.jl")

"""
	resample(mx, my, data, xgrid, ygrid, maxdist, nneighbors)

returns unstructured ungridded data on mx,my coordinates onto 
a regular 2D gridded data on xgrid, ygrid
"""
function resample(mx,my,data,xgrid,ygrid,maxdist,nneighbors)

	if isa(data[1],AbstractArray) #multiple data layers
		md=true
	else
		md=false
	end

	AA=[SVector(i) for i in Iterators.product(ygrid,xgrid)][:]
	BB=SVector.(zip(my,mx))
	kdt=KDTree(BB)#;leafsize=3,reorder=false)
	ind,dist=knn(kdt,AA,nneighbors,true)
	
	if md
		outimg= [fill(NaN,(length(ygrid),length(xgrid))) for i in 1:length(data)]
	else
		outimg=fill(NaN,(length(ygrid),length(xgrid)))
	end

	for (n,(i,d)) in enumerate(zip(ind,dist))
		c=0
		for di in d
			if di<maxdist
				c+=1
			else
				break
			end
		end
		if c!=0
			if md
				for ii = 1:length(data)
					outimg[ii][n]=mean(@views data[ii][i[1:c]])
				end
			else
				outimg[n]=mean(@views data[i[1:c]])
			end		
		end
	end
	return outimg
end


"""
	Grid(proj, xlim, ylim, resolution)

Grid instance holding projection, border information and resolution
"""
struct Grid
	"The projection which is a Proj4 instance"
	proj::Proj4.Projection
	"A tuple holding minimum and maximum values in x direction in m"
	xlim::NTuple{2,Float64}
	"A tuple holding minimum and maximum values in x direction in m"
	ylim::NTuple{2,Float64}
	"the resolution in m"
	resolution::Float64
end


"""
	gen_ps_grid(clon, clat, width, height, resolution)

generates polar stereographic grid with center coordinates of `clat`, `clon`
and `width` and `height` and `resolution` in m. This is a special case with 
the North pole always rotated upwards. For arbitrary rotated grid see [`gen_ps_grid`](@ref)
"""
function gen_ps_grid(clon,clat,width,height,resolution)
	proj=Projection("+proj=stere +lat_0=$clat +lon_0=$clon +ellps=WGS84")
	Grid(proj,(-width/2, width/2), (-height/2, height/2),resolution)
end


"""
	gen_ps_grid(clon, clat, width, height, resolution, rotation)

generates polar stereographic grid with center coordinates of `clat`, `clon`
and `width` and `height` and `resolution` in m rotated by `rotation` degrees`.
"""
function gen_ps_grid(clon,clat,width,height,resolution,rotation)
	proj=Projection("+proj=stere +lat_0=$clat +lat_ts=$clat +lon_0=$(rotation) +ellps=WGS84")
	x,y=lonlat2xy(Float64[clon clat],proj)
	nproj=Projection("+proj=stere +lat_0=$clat +lat_ts=$clat +lon_0=$rotation +x_0=$(-x) +y_0=$(-y) +ellps=WGS84")
	return Grid(nproj,(-width/2, width/2), (-height/2, height/2),resolution)
end


"""
	resample(mx, my, data, grid, maxdist, nneighbor)

resample `data` which is already in `grid` coordinates `mx` and `my`.
`maxdist` is the maximum distance in grid units to take into account
`nneighbor` is the number of neighbors to take into account for the resampling
"""
function resample(mx,my,data,grid::Grid,maxdist,nneighbor)
	xg,yg=genxy(grid)
	resample(mx,my,data,xg,yg,maxdist,nneighbor)
end

"""
	resample(lon, lat, data, grid, maxdist, nneighbor)

resample `data` which is `lat`, `lon` coordinates into the `grid`.
`maxdist` is the maximum distance in grid units to take into account
`nneighbor` is the number of neighbors to take into account for the resampling
"""
function llresample(lon,lat,data,grid::Grid,maxdist,nneighbor)
	xx,yy=xyfromlonlat(lon,lat,grid)
	resample(xx,yy,data,grid,maxdist,nneighbor)
end

"""
	xyfromlonlat(lon, lat, grid)

convert `lat`, `lon` into x and y coordinates of the `grid`
"""
function xyfromlonlat(lon,lat,grid::Grid)
	eachcol(lonlat2xy(Float64[lon lat],grid.proj))
end



"""
	genxy(grid)

generates grid coordinates `x` and `y` for a given grid instance
"""
function genxy(grid::Grid)
	xg=grid.xlim[1]+grid.resolution/2:grid.resolution:grid.xlim[2]
	yg=grid.ylim[1]+grid.resolution/2:grid.resolution:grid.ylim[2]
	return xg,yg
end

end

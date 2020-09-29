module SatResample

# Write your package code here.
using Proj4
using NearestNeighbors
using Statistics
using StaticArrays

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

	AA=[SVector(i) for i in Iterators.product(xgrid,ygrid)][:]
	BB=SVector.(zip(mx,my))
	kdt=KDTree(BB)#;leafsize=3,reorder=false)
	ind,dist=knn(kdt,AA,nneighbors,true)
	
	if md
		outimg= [fill(NaN,(length(xgrid),length(ygrid))) for i in 1:length(data)]
	else
		outimg=fill(NaN,(length(xgrid),length(ygrid)))
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

end

# SatResample.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://mapclyps.github.io/SatResample.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://mapclyps.github.io/SatResample.jl/dev)
[![Build Status](https://github.com/mapclyps/SatResample.jl/workflows/CI/badge.svg)](https://github.com/mapclyps/SatResample.jl/actions)
[![Coverage](https://codecov.io/gh/mapclyps/SatResample.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/mapclyps/SatResample.jl)

`SatResample.jl` is a package for gridding and resampling satellite data with the focus on ease of use.

---

## Introducing a Grid datatype


```julia
Grid(projection, xlimits, ylimits, resolution)
```
* `projection` : a `Proj4.Projection` instance, can be create from a proj4 string or an EPSG as `Proj4.Projection(proj4.epsg[#])` (see [Proj4.jl](https://github.com/JuliaGeo/Proj4.jl))
* `xlimits` : a tuple with the minimum and maximum value of the first projection coordinate.
* `ylimits` : like xlimits buy for the second coordinate.
* `resolution` : the grid resolution in projection coordinates.


## Resampling of satellite data
A common case is when some satellite data comes in swath files or granules and one has the lat and lon values for each point and want to put several of these together on a map.

```julia
llresample(lon, lat, data, grid, maxdist, nneighbor)
```
* `lon`, `lat` : longitudes and latitudes in 1d array or list. It does not need to be geographically sorted.
* `data` : the data to be resampled, can either be 
  * a1d array of the same size of `lat` and `lon` or 
  * a collection of 1d arrays with with each having the same length fo `lat` and `lon`. This is for gridding several datasets with the same input `lat` and `lon` combinations to a common grid, e.g., several spectral channels.
* `grid` : a `Grid` instance of the desired target grid.
* `maxdist` : the maximum distance allowed to each grid point.
* `nneighbor` : the maximum number of neighbors to be taken into account.

## Arbitrary local grids

For convenience, a grid constructor (stereograpic projection) can be used to create local grids where the cartesian coordanes are in meters like

```julia
gen_ps_grid(clon, clat, width, height, resolution, rotation)
```
* `clon` : center longitude of the grid
* `clat` : center latitude of the grid
* `width` : width of the grid in the local grid coordinates, i.e., meters.
* `height` : height of the grid in meters
* `resolution` : grid resolution in meters
* `rotation` : the rotation, 0° means North is up.

This package uses [NearestNeighbors.jl](https://github.com/KristofferC/NearestNeighbors.jl) for resampling.
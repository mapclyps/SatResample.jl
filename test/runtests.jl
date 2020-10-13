using SatResample
using SatResample: resample
using Test

@testset "resample" begin

    @test isequal(resample([1,2,3],[1,2,3],[1,1,1],1:3,1:3,1,1),
        [1.0 NaN NaN
        NaN 1.0 NaN
        NaN NaN 1.0])

    @test isequal(resample([1,2,3],[1,2,3],[1,1,1],1:3,1:3,1+eps(),1),
    [1.0 1.0 NaN
     1.0 1.0 1.0
     NaN 1.0 1.0])

    @test isequal(resample([1,2,3],[1,2,3],[1,1,1],1:3,1:3,sqrt(2)+eps(),1), ones(3,3))

    @test isequal(resample([1,2,3],[1,2,3],[1,2,3],1:3,1:3,sqrt(2)+eps(),1),
      [1.0  2.0  2.0
       2.0  2.0  3.0
       2.0  3.0  3.0])
        
    @test isequal(resample([1,2,3],[1,2,3],[1,2,3],1:3,1:3,sqrt(2)+eps(),2),
    [1.5  1.5  2.0
     1.5  2.5  2.5
     2.0  2.5  2.5])

    @test isequal(resample([1,2,3],[1,2,3],[[1,1,1],[1,2,3]],1:3,1:3,sqrt(2)+eps(),2),
     [[1.0 1.0 1.0; 1.0 1.0 1.0; 1.0 1.0 1.0],
     [1.5 1.5 2.0; 1.5 2.5 2.5; 2.0 2.5 2.5]])
    

end

@testset "grids" begin
    #check NSIDC North and South grids for correct grid sizes
    #see https://nsidc.org/data/polar-stereo/ps_grids.html
    let genxy=SatResample.genxy
        let NSIDCN = SatResample.NSIDCN
            @test length.(genxy(NSIDCN(50000)))==(152,224)
            @test length.(genxy(NSIDCN(25000)))==(304,448)
            @test length.(genxy(NSIDCN(12500)))==(608,896)
            @test length.(genxy(NSIDCN( 6250)))==(1216,1792)
            @test length.(genxy(NSIDCN( 3125)))==(2432,3584)
        end

        let NSIDCS = SatResample.NSIDCS
            @test length.(genxy(NSIDCS(50000)))==(158,166)
            @test length.(genxy(NSIDCS(25000)))==(316,332)
            @test length.(genxy(NSIDCS(12500)))==(632,664)
            @test length.(genxy(NSIDCS( 6250)))==(1264,1328)
            @test length.(genxy(NSIDCS( 3125)))==(2528,2656)
        end
    end
end
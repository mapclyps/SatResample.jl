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

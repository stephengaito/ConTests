if not modules then modules = { } end modules ['t-contests'] = {
    version   = 1.000,
    comment   = "ConTests",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata          = thirddata        or {}
thirddata.contests = thirddata.contests or {}

local contests     = thirddata.contests
contests.lunatest  = require('t-contests-lunatest')
local assert       = contests.lunatest.assert

function contests.runSuite(bufferName)
  texio.write_nl(bufferName)
end

texio.write_nl("loaded ConTests lua code\n")
if not modules then modules = { } end modules ['t-contests-demo'] = {
    version   = 1.000,
    comment   = "ConTestsDemo",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata              = thirddata              or {}
thirddata.contestsDemo = thirddata.contestsData or {}

local cts   = thirddata.contests.tests
local cDemo = thirddata.contestsDemo
local pp    = require('pl.pretty')

texio.write("loaded ConTestsDemo\n")

cts.loadSuite('t-suite1')
cts.loadSuite('t-suite2')
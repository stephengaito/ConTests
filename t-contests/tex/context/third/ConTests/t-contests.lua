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
contests.tests     = require('t-contests-lunatest')
local pp           = require('pl.pretty')

texio.write("loaded ConTests\n")

texio.write(pp.write(contests.tests))
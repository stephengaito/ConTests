if not modules then modules = { } end modules ['t-joylol'] = {
    version   = 1.000,
    comment   = "ConTests",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata          = thirddata        or {}
thirddata.contests = thirddata.contests or {}

-- local tests        = require('t-contests-lunatest')
local contests     = thirddata.contests

texio.write("loaded ConTests\n")
local ok, result = pcall(error, "silly")
if ok then
  texio.write("xpcall OK\n")
else
  texio.write("xpcall NOT OK\n")
end
texio.write("just passed assert false\n")

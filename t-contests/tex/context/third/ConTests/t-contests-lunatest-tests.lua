-- @module basicTests
local basicTests = {}

local assert = thirddata.contests.tests.assert

function basicTests.suite_setup()
   print "\n\n-- running basic tests setup hook"
end

function basicTests.suite_teardown()
   print "\n\n-- running basic tests teardown hook"
end

function basicTests.test_ok()
   assert.true(true)
end

return basicTests
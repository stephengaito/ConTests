texio.write("hello from suite-1\n")

-- @module suite1
local suite1 = {}

local assert = thirddata.contests.tests.assert

function suite1.suite_setup()
   print "\n\n-- running suite-1 setup hook"
end

function suite1.suite_teardown()
   print "\n\n-- running suite-1 teardown hook"
end

function suite1.test_ok()
   assert.isTrue(true)
end

return suite1
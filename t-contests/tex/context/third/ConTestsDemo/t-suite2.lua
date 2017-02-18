texio.write("hello from suite-2\n")

-- @module suite1
local suite2 = {}

local assert = thirddata.contests.tests.assert

function suite2.suite_setup()
   print "\n\n-- running suite-2 setup hook"
end

function suite2.suite_teardown()
   print "\n\n-- running suite-2 teardown hook"
end

function suite2.test_ok()
   assert_true(true)
end

return suite2
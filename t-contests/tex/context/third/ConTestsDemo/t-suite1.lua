texio.write("hello from suite-1\n")

-- @module suite1
local suite1 = {}

local lunatest = thirddata.contests.tests
local assert_true = lunatest.assert_true

function suite1.suite_setup()
   print "\n\n-- running suite-1 setup hook"
end

function suite1.suite_teardown()
   print "\n\n-- running suite-1 teardown hook"
end

function suite1.test_ok()
   assert_true(true)
end

return suite1
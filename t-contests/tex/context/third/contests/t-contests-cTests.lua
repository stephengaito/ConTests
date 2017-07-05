-- A Lua file for CTests

-- from file: cTests.tex after line: 150

-- from file: cTests.tex after line: 150

function startTestSuite(aDesc, testFileName, testFileLine)
  -- do something
end

function stopTestSuite(testFileName, testFileLine)
  -- do something
end

function startTestCase(aDesc, srcFileName, srcStartLine, srcLastLine, testFileName, testFileLine)
  -- do something
end

function stopTestCase(testFileName, testFileLine)
  -- do something
end

-- from file: cTests.tex after line: 200

function reportCAssertion(theCondition, aMessage, theReason, testFileName, testFileLine)
  -- do something
end

-- from file: cTests.tex after line: 200

function startCShouldFail(messagePattern, reasonPattern, aMessage, testFileName, testFileLine)
  -- do something
end

function stopCShouldFail(testFileName, testFileLine)
  -- do something
end
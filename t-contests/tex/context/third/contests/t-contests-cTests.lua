-- A Lua file for CTests

-- from file: cTests.tex after line: 150

-- from file: cTests.tex after line: 150

-- This is the lua code associated with the t-contests-cTests

local cTests  = { }
local tInsert = table.insert
local sFmt    = string.format

function startTestSuite(aDesc, testFileName, testFileLine)
  cTests.curSuite = { }
  local curSuite  = cTests.curSuite
  curSuite.desc   = aDesc
  curSuite.passed = true
end

function stopTestSuite(testFileName, testFileLine)
  cTests.suites = cTests.suites or { }
  if cTests.curSuite then
    tInsert(cTests.suites, cTests.curSuite)
  end
  cTests.curSuite = { }
end

function startTestCase(
  aDesc, srcFileName, srcStartLine, srcLastLine,
  testFileName, testFileLine)
  cTests.curSuite   = cTests.curSuite or { }
  local curSuite    = cTests.curSuite
  curSuite.curCase  = { }
  local curCase     = curSuite.curCase
  curCase.desc      = aDesc
  curCase.fileName  = srcFileName
  curCase.startLine = srcStartLine
  curCase.lastLine  = srcLastLine
  curCase.passed    = true
end

function stopTestCase(testFileName, testFileLine)
  cTests.curSuite = cTests.curSuite or { }
  local curSuite  = cTests.curSuite
  curSuite.cases  = curSuite.cases or { }
  if curSuite.curCase then
    tInsert(curSuite.cases, curSuite.curCase)
  end
  curSuite.curCase = { }
end

-- from file: cTests.tex after line: 200

function reportCAssertion(
  theCondition, aMessage, theReason,
  testFileName, testFileLine)
  cTests.curSuite  = cTests.curSuite or { }
  local curSuite   = cTests.curSuite
  curSuite.curCase = curSuite.curCase or { }
  local curCase    = curSuite.curCase
 
  if type(curCase.shouldFail) == 'table' then
    local shouldFail   = curCase.shouldFail
    local innerMessage = aMessage
    local innerReason  = theReason
    theReason          = nil
    theCondition       = not theCondition

    if theReason ~= nil
      and shouldFail.messagePattern ~= nil
      and type(shouldFail.messagePattern) == 'string'
      and 0 < #shouldFail.messagePattern
      and innerMessage:match(shouldFail.messagePattern) then
      -- do nothing
    else
      theReason = sFmt('Expected inner message [%s] to match [%s]',
        innerMessage, shouldFail.messagePattern)
    end

    if theReason ~= nil
      and shouldFail.reasonPattern ~= nil
      and type(shouldFail.reasonPattern) == 'string'
      and 0 < #shouldFail.reasonPattern
      and innerReason:match(shouldFail.reasonPattern) then
      -- do nothing
    else
      theReason = sFmt('Expected inner failure reason [%s] to match [%s]',
        innerReason, shouldFail.reasonPattern)
    end
 
    if theReason ~= nil then
      theReason = sFmt('Expcedted inner assertion [%s] to fail',
        innerMessage)
    end
    aMessage = shouldFail.message
    curCase.shouldFail = nil
  end
 
  if theCondition then
    -- record stats
  else
    curSuite.passed = false
    curCase.passed  = false
    local failure = logFailure(
      'CTest FAILED',
      curSuite.desc,
      curCase.desc,
      aMessage,
      theReason,
      sFmt('in file: %s between lines %s and %s',
        curCase.fileName,
        toStr(curCase.startLine),
        toStr(curCase.lastLine)
      )
    )
    tInsert(cTests.failures, failure)
  end
end

-- from file: cTests.tex after line: 300

function startCShouldFail(
  messagePattern, reasonPattern, aMessage,
  testFileName, testFileLine)
  cTests.curSuite    = cTests.curSuite or { }
  local curSuite     = cTests.curSuite
  curSuite.curCase   = curSuite.curCase or { }
  local curCase      = curSuite.curCase
  curCase.shouldFail = { }
  local shouldFail   = curCase.shouldFail
  shouldFail.messagePattern = messagePattern
  shouldFail.reasonPattern  = reasonPattern
  shouldFail.message        = aMessage
end

function stopCShouldFail(testFileName, testFileLine)
  -- do nothing at the moment
end
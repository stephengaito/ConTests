-- A Lua file for CTests

-- from file: cTests.tex after line: 600

-- This is the lua code associated with the t-contests-cTests

local cTests  = { }
local tInsert = table.insert
local tRemove = table.remove
local tSort   = table.sort
local sFmt    = string.format
local toStr   = tostring

function setDefs(varVal, selector, defVal)
  if not defVal then defVal = { } end
  varVal[selector] = varVal[selector] or defVal
  return varVal[selector]
end

function startTestSuite(aDesc, testFileName, testFileLine)
  cTests.curSuite = { }
  local curSuite  = cTests.curSuite
  curSuite.desc   = aDesc
  curSuite.passed = true
  io.stdout:write("\n-------------------------------------\n")
  io.stdout:write(sFmt("cTS: %s\n", aDesc))
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
  local curSuite    = setDefs(cTests, 'curSuite')
  curSuite.curCase  = { }
  local curCase     = curSuite.curCase
  curCase.desc      = aDesc
  curCase.fileName  = srcFileName
  curCase.startLine = srcStartLine
  curCase.lastLine  = srcLastLine
  curCase.passed    = true
  io.stdout:write(sFmt("  cTC: %s\n", aDesc))
end

function skipTestCase(testFileName, testFileLine)
  io.stdout:write("    SKIPPED\n")
end

function stopTestCase(testFileName, testFileLine)
  local curSuite  = setDefs(cTests, 'curSuite')
  curSuite.cases  = curSuite.cases or { }
  if curSuite.curCase then
    tInsert(curSuite.cases, curSuite.curCase)
  end
  curSuite.curCase = { }
end

-- from file: cTests.tex after line: 700

local function compareKeyValues(a, b)
  return (a[1] < b[1])
end

local function prettyPrint(anObj, indent)
  local result = ""
  indent = indent or ""
  if type(anObj) == 'nil' then
    result = 'nil'
  elseif type(anObj) == 'boolean' then
    if anObj then result = 'true' else result = 'false' end
  elseif type(anObj) == 'number' then
    result = toStr(anObj)
  elseif type(anObj) == 'string' then
    result = '"'..anObj..'"'
  elseif type(anObj) == 'function' then
    result = toStr(anObj)
  elseif type(anObj) == 'userdata' then
    result = toStr(anObj)
  elseif type(anObj) == 'thread' then
    result = toStr(anObj)
  elseif type(anObj) == 'table' then
    local origIndent = indent
    indent = indent..'  '
    result = '{\n'
    for i, aValue in ipairs(anObj) do
      result = result..indent..prettyPrint(aValue, indent)..',\n'
    end
    local theKeyValues = { }
    for aKey, aValue in pairs(anObj) do
      if type(aKey) ~= 'number' or aKey < 1 or #anObj < aKey then
        tInsert(theKeyValues,
          { prettyPrint(aKey), aKey, prettyPrint(aValue, indent) })
      end
    end
    tSort(theKeyValues, compareKeyValues)
    for i, aKeyValue in ipairs(theKeyValues) do
      result = result..indent..'['..aKeyValue[1]..'] = '..aKeyValue[3]..',\n'
    end
    result = result..origIndent..'}'
  else
    result = 'UNKNOWN TYPE: ['..toStr(anObj)..']'
  end
  return result
end

local function logFailure(reason, suiteDesc, caseDesc,
                          testMsg, errMsg, fileInfo)
  local failure = {}
  failure.reason    = reason
  failure.suiteDesc = suiteDesc
  failure.caseDesc  = caseDesc
  failure.testMsg   = testMsg
  failure.errMsg    = errMsg
  failure.fileInfo  = fileInfo
  io.stdout:write(sFmt('    %s\n', reason))
  if 0 < #testMsg then
    io.stdout:write(sFmt('    %s\n', testMsg))
  end
  io.stdout:write(sFmt('    %s\n', errMsg))
  io.stdout:write(sFmt('    %s\n', fileInfo))
  io.stdout:write('\n\n')
  return failure
end

function reportCAssertion(
  theCondition, aMessage, theReason,
  testFileName, testFileLine)
  local curSuite     = setDefs(cTests, 'curSuite')
  local curCase      = setDefs(curSuite, 'curCase')
  curCase.shouldFail = curCase.shouldFail or { }
 
  if 0 < #curCase.shouldFail then
    -- we are wrapped in a shouldFail
    --
    local shouldFail   = tRemove(curCase.shouldFail)
    local innerMessage = aMessage
    local innerReason  = theReason
    theReason          = nil
    theCondition       = not theCondition
 
    if theReason == nil
      and innerMessage ~= nil
      and shouldFail.messagePattern ~= nil
      and type(shouldFail.messagePattern) == 'string'
      and 0 < #shouldFail.messagePattern then
      if innerMessage:match(shouldFail.messagePattern) then
        -- do nothing
      else
        theReason = sFmt('Expected inner message [%s] to match [%s]',
          innerMessage, shouldFail.messagePattern)
        theCondition = false
      end
    end

    if theReason == nil
      and innerReason ~= nil
      and shouldFail.reasonPattern ~= nil
      and type(shouldFail.reasonPattern) == 'string'
      and 0 < #shouldFail.reasonPattern then
      if innerReason:match(shouldFail.reasonPattern) then
        -- do nothing
      else
        theReason = sFmt('Expected inner failure reason [%s] to match [%s]',
          innerReason, shouldFail.reasonPattern)
        theCondition = false
      end
    end
 
    if theReason == nil then
      theReason = sFmt('Expected inner assertion [%s] to fail',
        innerMessage)
    end
    aMessage = shouldFail.message
 
    return reportCAssertion(
      theCondition,
      aMessage,
      theReason,
      testFileName,
      testFileLine
    )
  end
  -- there are no more wrapping shouldFails
  -- so report the resulting condition
  --
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
    cTests.failures = cTests.failures or { }
    tInsert(cTests.failures, failure)
    cTests.numFailures = #cTests.failures
  end
  return theCondition
end

function getNumFailures()
  cTests.numFailures = cTests.numFailures or 0
  return cTests.numFailures
end

-- from file: cTests.tex after line: 850

function startCShouldFail(
  messagePattern, reasonPattern, aMessage,
  testFileName, testFileLine)
  local curSuite     = setDefs(cTests, 'curSuite')
  local curCase      = setDefs(curSuite, 'curCase')
  local curShouldFail   = { }
  curShouldFail.messagePattern = messagePattern
  curShouldFail.reasonPattern  = reasonPattern
  curShouldFail.message        = aMessage
 
  curCase.shouldFail = curCase.shouldFail or { }
  tInsert(curCase.shouldFail, curShouldFail)
end

function stopCShouldFail(testFileName, testFileLine)
  -- do nothing at the moment
end
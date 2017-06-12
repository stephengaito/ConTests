-- A Lua file

-- from file: preamble.tex starting line: 55

-- This is the lua code associated with t-contests.mkiv

if not modules then modules = { } end modules ['t-contests'] = {
    version   = 1.000,
    comment   = "ConTests Unit testing - lua",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata          = thirddata          or {}
thirddata.contests = thirddata.contests or {}

local contests  = thirddata.contests
contests.tests  = {}
local tests     = contests.tests
tests.suites    = {}
tests.failures  = {}
contests.assert = {}
local assert    = contests.assert
contests.mocks  = {}
local mocks     = contests.mocks

local litProgs     = thirddata.literateProgs
litProgs.templates = litProgs.templates or {}
local templates    = litProgs.templates

local function initRawStats()
  local raw = {}
  raw.attempted  = 0
  raw.passed     = 0
  raw.failed     = 0
  return raw
end

local function initStats()
  local stats = {}
  stats.assertions = initRawStats()
  stats.cases      = initRawStats()
  stats.suites     = initRawStats()
  return stats
end

tests.stats          = {}
tests.stats.mkiv     = initStats()
local mkivStats      = tests.stats.mkiv
local mkivAssertions = mkivStats.assertions
tests.stats.lua      = initStats()
local luaStats       = tests.stats.lua
local luaAssertions  = luaStats.assertions

local tInsert = table.insert
local tConcat = table.concat
local tRemove = table.remove
local tSort   = table.sort
local sFmt    = string.format
local sMatch  = string.match
local toStr   = tostring

-- from file: testSuites.tex starting line: 42

local function initSuite()
  local curSuite = {}
  curSuite.passed = true
  curSuite.cases  = {}
  return curSuite
end

function contests.startTestSuite(aDesc)
  tests.curSuite      = initSuite()
  tests.curSuite.desc = aDesc
end

function contests.stopTestSuite()
  tInsert(tests.suites, tests.curSuite)
  tests.curSuite = initSuite()
end

function contests.startTestCase(aDesc)
  local suite       = tests.curSuite
  suite.curCase     = {}
  local curCase     = suite.curCase
  curCase.passed    = true
  curCase.desc      = aDesc
  curCase.fileName  = status.filename
  curCase.startLine = status.linenumber
end

function contests.stopTestCase()
  local curSuite   = tests.curSuite
  local curCase    = curSuite.curCase
  curCase.lastLine = status.linenumber
  contests.runCurMkIVTestCase(curSuite, curCase)
  contests.runCurLuaTestCase(curSuite, curCase)
  tInsert(curSuite.cases, curCase)
end

function contests.skipTestCase()
  local curSuite   = tests.curSuite
  local curCase    = curSuite.curCase
  curCase.lastLine = status.linenumber
  tInsert(curSuite.cases, curCase)
  tex.print('{\\magenta SKIPPED}')
end

function contests.reportStats(statsType)
  local stats = tests.stats[statsType]
  local rows = { 'cases', 'assertions' }
  local cols =
    { 'attempted', 'passed', 'failed' }
  local colCol = { '', '\\green', '\\red' }
  tex.print("\\placetable[force,none]{}{%")
  tex.print("\\starttabulate[|r|c|c|c|]\\HL\\NC")
  for j, col in ipairs(cols) do
    tex.print("\\NC "..colCol[j]..' '..col)
  end
  tex.print("\\NR\\HL")
  for i, row in ipairs(rows) do
    tex.print("\\NC "..row)
    for j, col in ipairs(cols) do
      tex.print("\\NC "..colCol[j]..' '..tostring(stats[row][col]))
    end
    tex.print("\\NR")
  end
  tex.print("\\HL\\stoptabulate")
  tex.print("}")
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
  return failure
end

local function reportFailure(aFailure, fullReport)
  tex.print("\\noindent{\\red "..aFailure.reason.."}:\\\\")
  if fullReport then
    tex.print(aFailure.suiteDesc.."\\\\")
    tex.print(aFailure.caseDesc.."\\\\")
  end
  if aFailure.testMsg and 0 < #aFailure.testMsg then
    tex.print(aFailure.testMsg.."\\\\")
  end
  tex.cprint(12, aFailure.errMsg)
  tex.print("\\\\"..aFailure.fileInfo)
end

function contests.reportFailures()
  if 0 < #tests.failures then
    tex.print("\\startitemize ")
    for i, aFailure in ipairs(tests.failures) do
      tex.print("\\item ")
      reportFailure(aFailure, true)
    end
    tex.print("\\stopitemize ")
  else
    tex.print("{\\green All test cases PASSED}")
  end
end

-- from file: mkivTests.tex starting line: 30

------------------
-- ConTest code --
------------------

function contests.addConTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.mkiv   = case.mkiv or {}
  tInsert(case.mkiv, bufferContents)
end

function contests.runCurMkIVTestCase(suite, case)
  case.passed = case.passed or true
  case.mkiv   = case.mkiv   or { }
  local mkivChunk = tConcat(case.mkiv, '\n')
  if not mkivChunk:match('^%s*$') then
    local caseStats = tests.stats.mkiv.cases
    caseStats.attempted = caseStats.attempted + 1
    tex.print("\\directlua{thirddata.contests.startConTestImplementation()}")
    for i, aChunk in ipairs(case.mkiv) do
      for aLine in string.gmatch(aChunk, '[^\n]*') do
        if 0 < #aLine then
          tex.print(aLine)
        end
      end
    end
    tex.print("\\directlua{thirddata.contests.stopConTestImplementation()}")
  end
end

function contests.startConTestImplementation()
  -- nothing to do at the moment
end

function contests.stopConTestImplementation()
  local curCase  = tests.curSuite.curCase
  local caseStats = mkivStats.cases
  if curCase.passed then
    caseStats.passed = caseStats.passed + 1
  else
    caseStats.failed = caseStats.failed + 1
  end
end

-- from file: mkivTests.tex starting line: 94

function contests.reportMkIVAssertion(theCondition, aMessage, theReason)
  local curSuite  = tests.curSuite
  local curCase   = curSuite.curCase
  mkivAssertions.attempted = mkivAssertions.attempted + 1

  if type(curCase.shouldFail) == 'table'  then
    local shouldFail = curCase.shouldFail
    local innerMessage = aMessage
    local innerReason  = theReason
    theReason = nil
    theCondition = not theCondition
    if theReason ~= nil
      and shouldFail.messagePattern ~= nil
      and type(shouldFail.messagePattern) == 'string'
      and 0 < #shouldFail.messagePattern
      and aMessage:match(shouldFail.messagePattern) then
      -- do nothing
    else
      theReason = sFmt('Expected inner message [%s] to match [%s]',
        innerMessage, shouldFail.messagePattern)
    end
    if theReason ~= nil
      and shouldFail.reasonPattern ~= nil
      and type(shouldFail.reasonPattern) == 'string'
      and 0 < #shouldFail.reasonPattern
      and theReason:match(shouldFail.reasonPattern) then
      -- do nothing
    else
      theReason = sFmt('Expected inner failure reason [%s] to match [%s]',
        innerReason, shouldFail.reasonPattern)
    end
    if theReason ~= nil then
      theReason = 'Expected inner assertion ['..aMessage..'] to fail'
    end
    aMessage  = shouldFail.message
    curCase.shouldFail = nil
  end

  if theCondition then
    mkivAssertions.passed = mkivAssertions.passed + 1
    tex.print("\\noindent{\\green PASSED}")
  else
    curSuite.passed = false
    curCase.passed  = false
    mkivAssertions.failed = mkivAssertions.failed + 1
    local failure = logFailure(
      "ConTest FAILED",
      curSuite.desc,
      curCase.desc,
      aMessage,
      theReason,
      sFmt("in file: %s between lines %s and %s",
        curCase.fileName,
        toStr(curCase.startLine),
        toStr(curCase.lastLine)
      )
    )
    reportFailure(failure, false)
    tInsert(tests.failures, failure)
  end
end

-- from file: mkivTests.tex starting line: 177

function contests.mkivAssertShouldFail(messagePattern, reasonPattern, aMessage)
  local curCase = tests.curSuite.curCase
  curCase.shouldFail = { }
  local shouldFail = curCase.shouldFail
  shouldFail.messagePattern = messagePattern
  shouldFail.reasonPattern  = reasonPattern
  shouldFail.message        = aMessage
end

-- from file: mkivTests.tex starting line: 736

function contests.createTraceMacro(theMacroName, numArgs, theArgType)
  local theArgList = { }
  for argNum = 1, numArgs, 1 do
    tInsert(theArgList, argNum)
  end
  local theArgTemplate = 'ctmTexFormalArgs'
  if theArgType == 'context' then
    theArgTemplate = 'ctmContextFormalArgs'
  end
  local theEnv  = {
    macroName   = theMacroName,
    argList     = theArgList,
    argType     = theArgType,
    argTemplate = theArgTemplate
  }
  texio.write_nl(litProgs.prettyPrint(theEnv))
  local ctmMainPath = litProgs.parseTemplatePath('ctmMain', theEnv)
  texio.write_nl(litProgs.prettyPrint(ctmMainPath))
  texio.write_nl(litProgs.prettyPrint(litProgs.templates))
  local ctmMain     = litProgs.navigateToTemplate(ctmMainPath)
  texio.write_nl(litProgs.prettyPrint(ctmMain))
  local result      = litProgs.renderer(ctmMain, theEnv)
  texio.write_nl(result)
  --result = templates.splitLines(result)
  --tex.print(result)
end

-- from file: mkivTests.tex starting line: 814

function contests.startMocking()
  contests.mocks = { }
  mocks          = contests.mocks
end

function contests.stopMocking()
  contests.mocks   = { }
  mocks            = contests.mocks
  mocks.traceCalls = false
end

-- from file: mkivTests.tex starting line: 830

function contests.traceMockCalls(traceCalls)
  mocks.traceCalls = traceCalls
  texio.write_nl('-----------------------------------------------------')
end

function contests.callMock(mockedMacro, mockedArguments, callType)
  if mocks.traceCalls then
    texio.write_nl('MOCKED '..callType..' macro expanded ['..mockedMacro..']')
    for i, anArg in ipairs(mockedArguments) do
      texio.write_nl('  args['..toStr(i)..'] = ['..toStr(anArg)..']')
    end
  end
  mockedMacro = mockedMacro:gsub('^%s+', ''):gsub('%s+$', '')
  mocks[mockedMacro] = mocks[mockedMacro] or { }
  mockedMacro = mocks[mockedMacro]
  mockedMacro.calls = mockedMacro.calls or { }
  tInsert(mockedMacro.calls, { callType, mockedArguments})
  mockedMacro.returns = mockedMacro.returns or { }
  local result = tRemove(mockedMacro.returns, 1)
  if result and type(result) == 'string' and not result:match('^%s*$') then
    tex.print(result)
  end
end

function contests.defMock(mockedMacro)
  mockedMacro = mockedMacro:gsub('^%s+', ''):gsub('%s+$', '')
  mocks[mockedMacro] = { }
end

function contests.addMockResult(mockedMacro, returnValue)
  mockedMacro = mockedMacro:gsub('^%s+', ''):gsub('%s+$', '')
  mocks[mockedMacro] = mocks[mockedMacro] or { }
  mockedMacro = mocks[mockedMacro]
  mockedMacro.returns = mockedMacro.returns or { }
  tInsert(mockedMacro.returns, returnValue)
end

-- from file: mkivTests.tex starting line: 1028

function contests.assertMockExpanded(mockedMacro, callNum, aMessage)
  local expectedMsg = 'Expected ['..mockedMacro..']'
  mockedMacro = mocks[mockedMacro]
  contests.reportMkIVAssertion(
    mockedMacro ~= nil
    and mockedMacro.calls ~= nil
    and mockedMacro.calls[callNum] ~= nil,
    aMessage,
    expectedMsg..'to have been expanded at least '..
      toStr(callNum)..' times'
  )
end

function contests.assertMockNeverExpanded(mockedMacro, aMessage)
  local expectedMsg = 'Expected ['..mockedMacro..']'
  mockedMacro = mocks[mockedMacro]
  contests.reportMkIVAssertion(
    mockedMacro ~= nil
    and mockedMacro.calls == nil,
    aMessage,
    expectedMsg..'to have been expanded at least '..
      toStr(callNum)..' times'
  )
end

-- from file: mkivTests.tex starting line: 1110

function contests.assertMockArguments(mockedMacro,
                                      callNum,
                                      argNum,
                                      aPattern,
                                      aMessage)
  local expectedMsg = 'Expected ['..mockedMacro..'] '
  mockedMacro = mocks[mockedMacro]
  if mockedMacro then
    local calls = mockedMacro.calls
    if calls then
      local aCall = calls[callNum]
      if aCall then
        local anArg = aCall[2][argNum]
        if anArg then
          if sMatch(anArg, aPattern) then
            contests.reportMkIVAssertion(true, aMessage, '')
          else
            contests.reportMkIVAssertion(false, aMessage,
              expectedMsg..'the '..
              toStr(argNum)..' argument on the '..
              toStr(callNum)..' expansion to match ['..
              aPattern..']')
          end
        else
          contests.reportMkIVAssertion(false, aMessage,
            expectedMsg..'to have supplied '..
            toStr(argNum)..' arguments on the '..
            toStr(callNum)..' expansion')
        end
      else
        contests.reportMkIVAssertion(false, aMessage,
          expectedMsg..'to have been expanded '..
          toStr(callNum)..' times')
      end
    else
      contests.reportMkIVAssertion(false, aMessage,
        expectedMsg..'to have been expanded')
    end
  else
    contests.reportMkIVAssertion(false, aMessage,
      expectedMsg..'to be defined')
  end
end

-- from file: luaTests.tex starting line: 5

------------------
-- LuaTest code --
------------------

-- from file: luaTests.tex starting line: 20

function contests.showValue(aValue, aMessage)
  texio.write_nl('-----------------------------------------------')
  if aMessage and type(aMessage) == 'string' and 0 < #aMessage then
    texio.write_nl(aMessage)
  end
  texio.write_nl(litProgs.prettyPrint(aValue))
  texio.write_nl('-----------------------------------------------')
end

-- from file: luaTests.tex starting line: 67

function contests.addLuaTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.lua    = case.lua or {}
  tInsert(case.lua, bufferContents)
end

local function buildLuaChunk(case)
  case.lua = case.lua or { }
  local luaChunk = tConcat(case.lua, '\n')
  if luaChunk:match('^%s*$') then
    luaChunk = nil
  else
    luaChunk = [=[
---
local assert    = thirddata.contests.assert
local showValue = thirddata.contests.showValue
---
]=]..luaChunk..[=[

---
return true
]=]
  end
  return luaChunk
end

function contests.showLuaTest()
  texio.write_nl('-----------------------------------------------')
  local luaChunk = buildLuaChunk(tests.curSuite.curCase)
  if luaChunk then
    texio.write_nl('Lua Test: ')
    texio.write_nl(luaChunk)
  else
    texio.write_nl('NO Lua Test could be built')
  end
  texio.write_nl('-----------------------------------------------')
end

function contests.runCurLuaTestCase(suite, case)
  case.passed = case.passed or true
  local luaChunk = buildLuaChunk(case)
  if luaChunk then
    local caseStats = tests.stats.lua.cases
    caseStats.attempted = caseStats.attempted + 1
    local luaFunc, errMessage = load(luaChunk)
    if luaFunc then
      local ok, errObj = pcall(luaFunc)
      if ok then
        caseStats.passed = caseStats.passed + 1
        tex.print("\\noindent{\\green PASSED}")
      else
        case.passed  = false
        suite.passed = false
        caseStats.failed = caseStats.failed + 1
        if type(errObj) == 'string' then
          errObj = {
            message = 'Could not execute the LuaTest.',
            reason = errObj..'.'
          }
        end
        if type(errObj) ~= 'table' then
          errObj = {
            message = 'Could not execute the LuaTest.',
            reason = 'Is something unexpectedly nil?'
          }
        end
        if errObj.message == nil then
          errObj.message = 'Could not execute the LuaTest.'
        end
        if errObj.reason == nil then
          errObj.reason = 'Is something unexpectedly nil?'
        end
        local failure = logFailure(
          "LuaTest FAILED",
          suite.desc,
          case.desc,
          errObj.message,
          toStr(errObj.reason),
          sFmt("in file: %s between lines %s and %s",
            case.fileName, toStr(case.startLine), toStr(case.lastLine))
        )
        reportFailure(failure, false)
        tInsert(tests.failures, failure)
      end
    else
      case.passed  = false
      suite.passed = false
      caseStats.failed = caseStats.failed + 1
      local failure = logFailure(
        "LuaTest FAILED TO COMPILE",
        suite.desc,
        case.desc,
        "",
        errMessage,
        sFmt("in file: %s between lines %s and %s",
          case.fileName, toStr(case.startLine), toStr(case.lastLine))
      )
      reportFailure(failure, false)
      tInsert(tests.failures, failure)
    end
  end
end

-- from file: luaTests.tex starting line: 185

function reportLuaAssertion(theCondition, aMessage, theReason)
  local assertionStats = tests.stats.lua.assertions
  assertionStats.attempted = assertionStats.attempted + 1
  --
  -- we do not need to do anything unless theCondition is false!
  if not theCondition then
    local test     = { }
    test.message   = aMessage
    test.reason    = theReason
    test.condition = theCondition
    local info     = debug.getinfo(2,'l')
    test.line      = info.currentline
    assertionStats.failed = assertionStats.failed + 1
    error(test, 0) -- throw an error to be captured by an error_handler
  end
  assertionStats.passed = assertionStats.passed + 1
end

-- from file: luaTests.tex starting line: 228

function assert.throwsError(aFunction, aMessage, ...)
  local ok, err = pcall(aFunction, ...)
  if not ok and type(err) == 'table' and err.reason ~= nil then
    -- this is an expected error which has already been counted...
    -- so reduce the number of failures and attempts...
    local assertions = tests.stats.lua.assertions
    assertions.failed    = assertions.failed    - 1
    assertions.attempted = assertions.attempted - 1
  end
  return reportLuaAssertion(
    not ok,
    aMessage,
    sFmt("Expected %s to throw an error.", toStr(aFunction))
  )
end

-- from file: luaTests.tex starting line: 312

function assert.throwsNoError(aFunction, aMessage, ...)
  local ok, err = pcall(aFunction, ...)
  if not ok and type(err) == 'table' and err.reason ~= nil then
    -- this is an unexpected error which has already been counted...
    -- so reduce the number of failures and attempts...
    local assertions = tests.stats.lua.assertions
    assertions.failed    = assertions.failed    - 1
    assertions.attempted = assertions.attempted - 1
  end
  return reportLuaAssertion(
    ok,
    aMessage,
    sFmt("Expected %s not to throw an error (%s).",
      toStr(aFunction), toStr(err))
  )
end

-- from file: luaTests.tex starting line: 367

function assert.fail(aMessage)
  return reportLuaAssertion(
    false,
    aMessage,
    "(Failed)"
  )
end

-- from file: luaTests.tex starting line: 392

function assert.succeed(aMessage)
  return reportLuaAssertion(
    true,
    aMessage,
    "(Succeed)"
  )
end

-- from file: luaTests.tex starting line: 418

function assert.isBoolean(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'boolean',
    aMessage,
    sFmt("Expected %s to be a boolean.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 465

function assert.isNotBoolean(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'boolean',
    aMessage,
    sFmt("Expected %s to not be a boolean.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 511

function assert.isTrue(aBoolean, aMessage)
  return reportLuaAssertion(
    aBoolean,
    aMessage,
    sFmt("Expected true, got %s.", toStr(aBoolean))
  )
end

-- from file: luaTests.tex starting line: 551

function assert.isFalse(aBoolean, aMessage)
  return reportLuaAssertion(
    not aBoolean,
    aMessage,
    sFmt("Expected false, got %s.", toStr(aBoolean))
  )
end

-- from file: luaTests.tex starting line: 591

function assert.isNil(anObj, aMessage)
  return reportLuaAssertion(
    anObj == nil,
    aMessage,
    sFmt("Expected nil, got %s.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 630

function assert.isNotNil(anObj, aMessage)
  return reportLuaAssertion(
    anObj ~= nil,
    aMessage,
    sFmt("Expected non-nil, got %s.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 668

function assert.isEqual(objA, objB, aMessage)
  return reportLuaAssertion(
    objA == objB,
    aMessage,
    sFmt("Expected %s to equal %s.",
      toStr(objA), toStr(objB))
  )
end

-- from file: luaTests.tex starting line: 714

function assert.isEqualWithIn(numA, numB,
  tolerance, aMessage)
  return reportLuaAssertion(
    type(numA) == 'number' and type(numB) == 'number'
    and math.abs(numA - numB) <= tolerance,
    aMessage,
    sFmt("Expected %s to equal %s with tolerance %s.",
      toStr(numA), toStr(numB), toStr(tolerance))
  )
end

-- from file: luaTests.tex starting line: 773

function assert.isNotEqual(objA, objB, aMessage)
  return reportLuaAssertion(
    objA ~= objB,
    aMessage,
    sFmt("Expected %s to not equal %s.",
      toStr(objA), toStr(objB))
  )
end

-- from file: luaTests.tex starting line: 814

function assert.isNotEqualWithIn(numA, numB, tolerance, aMessage)
  return reportLuaAssertion(
    type(numA) ~= 'number' or type(numB) ~= 'number'
    or tolerance < math.abs(numA - numB),
    aMessage,
    sFmt("Expected %s to not equal %s with tolerance %s.",
      toStr(numA), toStr(numB), toStr(tolerance))
  )
end

-- from file: luaTests.tex starting line: 865

function assert.isNumber(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'number',
    aMessage,
    sFmt("Expected %s to be a number.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 903

function assert.isGT(objA, objB, aMessage)
  return reportLuaAssertion(
    objA > objB,
    aMessage,
    sFmt("Expected %s > %s.", toStr(objA), toStr(objB))
  )
end

-- from file: luaTests.tex starting line: 964

function assert.isGTE(objA, objB, aMessage)
  return reportLuaAssertion(
    objA >= objB,
    aMessage,
    sFmt("Expected %s >= %s.", toStr(objA), toStr(objB))
  )
end

-- from file: luaTests.tex starting line: 1005

function assert.isLT(objA, objB, aMessage)
  return reportLuaAssertion(
    objA < objB,
    aMessage,
    sFmt("Expected %s < %s.", toStr(objA), toStr(objB))
  )
end

-- from file: luaTests.tex starting line: 1068

function assert.isLTE(objA, objB, aMessage)
  return reportLuaAssertion(
    objA <= objB,
    aMessage,
    sFmt("Expected %s <= %s.", toStr(objA), toStr(objB))
  )
end

-- from file: luaTests.tex starting line: 1129

function assert.isNotNumber(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'number',
    aMessage,
    sFmt("Expected %s to be a number.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1166

function assert.isString(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'string',
    aMessage,
    sFmt("Expected [%s] to be a string.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1204

function assert.matches(anObj, aPattern, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'string' and type(aPattern) == 'string'
    and anObj:match(aPattern),
    aMessage,
    sFmt("Expected [%s] to match [%s].",
      toStr(anObj), toStr(aPattern))
  )
end

-- from file: luaTests.tex starting line: 1254

function assert.doesNotMatch(anObj, aPattern, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'string' or type(aPattern) ~= 'string'
    or not anObj:match(aPattern),
    aMessage,
    sFmt("Expected [%s] to not match [%s].",
      toStr(anObj), toStr(aPattern))
  )
end

-- from file: luaTests.tex starting line: 1303

function assert.length(anObj, aLength, aMessage)
  return reportLuaAssertion(
    #anObj == aLength,
    aMessage,
    sFmt("Expected %s to have length %s.",
      toStr(anObj), toStr(aLength))
  )
end

-- from file: luaTests.tex starting line: 1343

function assert.isNotLength(anObj, aLength, aMessage)
  return reportLuaAssertion(
    #anObj ~= aLength,
    aMessage,
    sFmt("Expected %s to not have length %s.",
      toStr(anObj), toStr(aLength))
  )
end

-- from file: luaTests.tex starting line: 1391

function assert.isNotString(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'string',
    aMessage,
    sFmt("Expected [%s] to not be a string.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1428

function assert.isTable(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table',
    aMessage,
    sFmt("Expected %s to be a table.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1467

function assert.hasKey(anObj, aKey, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table' and anObj[aKey] ~= nil,
    aMessage,
    sFmt("Expected %s to have the key %s.",
      toStr(anObj), toStr(aKey))
  )
end

-- from file: luaTests.tex starting line: 1518

function assert.doesNotHaveKey(anObj, aKey, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table' and anObj[aKey] == nil,
    aMessage,
    sFmt("Expected %s to not have the key %s.",
      toStr(anObj), toStr(aKey))
  )
end

-- from file: luaTests.tex starting line: 1570

function assert.isNotTable(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'table',
    aMessage,
    sFmt("Expected %s to not be a table.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1608

function assert.isFunction(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'function',
    aMessage,
    sFmt("Expected %s to be a function.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1645

function assert.isNotFunction(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'function',
    aMessage,
    sFmt("Expected %s to not be a function.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1683

function assert.hasMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) ~= nil,
    aMessage,
    sFmt("Expected %s to have a meta table.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1719

function assert.metaTableEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) == aMetaTable,
    aMessage,
    sFmt("Expected %s to have the meta table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

-- from file: luaTests.tex starting line: 1759

function assert.metaTableNotEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) ~= aMetaTable,
    aMessage,
    sFmt("Expected %s to not have the meta-table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

-- from file: luaTests.tex starting line: 1797

function assert.doesNotHaveMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) == nil,
    aMessage,
    sFmt("Expected %s to not have a meta table.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1832

function assert.isThread(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'thread',
    aMessage,
    sFmt("Expected %s to be a thread.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1871

function assert.isNotThread(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'thread',
    aMessage,
    sFmt("Expected %s to not be a thread.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1911

function assert.isUserData(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'userdata',
    aMessage,
    sFmt("Expected %s to be user data.", toStr(anObj))
  )
end

-- from file: luaTests.tex starting line: 1945

function assert.isNotUserData(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'userdata',
    aMessage,
    sFmt("Expected %s to not be user data.", toStr(anObj))
  )
end

-- from file: cTests.tex starting line: 29

function contests.addCTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.ansiC  = case.ansiC or {}
  tInsert(case.ansiC, bufferContents)
end

function contests.collectCTest()

end
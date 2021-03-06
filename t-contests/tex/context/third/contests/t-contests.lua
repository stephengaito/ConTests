-- A Lua file

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/conclusion.tex after line: 0

-- Copyright 2019 PerceptiSys Ltd (Stephen Gaito)
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
--
--    The above copyright notice and this permission notice shall
--    be included in all copies or substantial portions of the
--    Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/preamble.tex after line: 0

-- This is the lua code associated with t-contests.mkiv

if not modules then modules = { } end modules ['t-contests'] = {
    version   = 1.000,
    comment   = "ConTests Unit testing - lua",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata            = thirddata          or {}
thirddata.contests   = thirddata.contests or {}

local contests       = thirddata.contests
contests.tests       = {}
local tests          = contests.tests
tests.suites         = {}
tests.failures       = {}
contests.assert      = {}
local assert         = contests.assert
contests.testRunners = {}
contests.expInfo     = {}
local expInfo        = contests.expInfo

local litProgs       = thirddata.literateProgs
local setDefs        = litProgs.setDefs
local templates      = setDefs(litProgs, 'templates')
local build          = setDefs(litProgs, 'build')

local function initRawStats()
  local raw = {}
  raw.attempted  = 0
  raw.passed     = 0
  raw.failed     = 0
  raw.skipped    = 0
  return raw
end
contests.initRawStats = initRawStats

local function initStats()
  local stats = {}
  stats.assertions = initRawStats()
  stats.cases      = initRawStats()
  stats.suites     = initRawStats()
  return stats
end
contests.initStats = initStats

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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/testSuites.tex after line: 50

local function initSuite()
  tests.stage     = ''
  local curSuite  = {}
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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/testSuites.tex after line: 150

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
  for runnerName, runner in pairs(contests.testRunners) do
    if type(runner) == 'function' then
      runner(curSuite, curCase)
    end
  end
  tInsert(curSuite.cases, curCase)
end

function contests.skipTestCase()
  local curSuite   = tests.curSuite
  local curCase    = curSuite.curCase
  curCase.lastLine = status.linenumber
  tInsert(curSuite.cases, curCase)
  if curCase.mkiv and 0 < #curCase.mkiv then
    local caseStats = mkivStats.cases
    caseStats.skipped = caseStats.skipped + 1
  end
  if curCase.lua and 0 < #curCase.lua then
    local caseStats = luaStats.cases
    caseStats.skipped = caseStats.skipped + 1
  end
  curCase.cTests = curCase.cTests or { }
  curCase.cTests.default = { "SkipTestCase();" }
  tex.print('{\\magenta SKIPPED}')
end

function contests.ignoreTestCase()
  local curSuite   = tests.curSuite
  local curCase    = curSuite.curCase
  curCase.lastLine = status.linenumber
  curCase.cTests = { }
  tex.print('{\\magenta IGNORED}')
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/testSuites.tex after line: 200

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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/testSuites.tex after line: 250

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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/testSuites.tex after line: 250

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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/testSuites.tex after line: 300

function contests.reportStats(statsType)
  local stats = tests.stats[statsType]
  local rows = { 'cases', 'assertions' }
  local cols =
    { 'attempted', 'passed', 'failed', 'skipped' }
  local colCol = { '', '\\green', '\\red', '\\magenta' }
  tex.print("\\placetable[force,none]{}{")
  tex.print("\\starttabulate[|r|c|c|c|c|]\\HL\\NC")
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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 0

local function addConTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.mkiv   = case.mkiv or {}
  tInsert(case.mkiv, bufferContents)
end

contests.addConTest = addConTest

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 50

local function runCurMkIVTestCase(suite, case)
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

contests.testRunners.runCurMkIVTestCase = runCurMkIVTestCase

local function startConTestImplementation()
  -- nothing to do at the moment
end

contests.startConTestImplementation = startConTestImplementation

local function stopConTestImplementation()
  local curCase  = tests.curSuite.curCase
  local caseStats = mkivStats.cases
  if curCase.passed then
    caseStats.passed = caseStats.passed + 1
  else
    caseStats.failed = caseStats.failed + 1
  end
end

contests.stopConTestImplementation = stopConTestImplementation

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 100

function reportMkIVAssertion(theCondition, aMessage, theReason)
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
      theReason = sFmt('Expected inner assertion [%s] to fail',
        innerMessage)
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

contests.reportMkIVAssertion = reportMkIVAssertion

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 200

function contests.mkivAssertShouldFail(messagePattern, reasonPattern, aMessage)
  local curCase = tests.curSuite.curCase
  curCase.shouldFail = { }
  local shouldFail = curCase.shouldFail
  shouldFail.messagePattern = messagePattern
  shouldFail.reasonPattern  = reasonPattern
  shouldFail.message        = aMessage
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 700

local function clearAllExpansionInfo()
  contests.expansionInfo = { }
  expInfo                = contests.expansionInfo
  expInfo.logginOn       = false
end

contests.clearAllExpansionInfo = clearAllExpansionInfo

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 700

local function clearExpansionInfoFor(expandedMacro)
  expandedMacro = expandedMacro:gsub('^%s+', ''):gsub('%s+$', '')
  expInfo[expandedMacro] = { }
end

contests.clearExpansionInfoFor = clearExpansionInfoFor

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 750

local function setExpansionLogging(logExpansion)
  expInfo.loggingOn = logExpansion
  if logExpansion then
    texio.write_nl('>>---------------------------------------->>')
    texio.write_nl('AT: '..status.filename..'::'..status.linenumber)
    texio.write_nl('>>---------------------------------------->>')
  else
    texio.write_nl('<<----------------------------------------<<')
    texio.write_nl('AT: '..status.filename..'::'..status.linenumber)
    texio.write_nl('<<----------------------------------------<<')
  end
end

contests.setExpansionLogging = setExpansionLogging

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 800

local function recordExpansion(macroName,
                               callType,
                               macroArguments)
  if expInfo.loggingOn then
    texio.write_nl(
      'EXPANSION '..callType..
      ' macro expanded ['..macroName..']'
    )
    for i, anArg in ipairs(macroArguments) do
      texio.write_nl(
        '  args['..toStr(i)..'] = ['..toStr(anArg)..']'
      )
    end
    texio.write_nl('AT: '..status.filename..'::'..status.linenumber)
  end
  macroName = macroName:gsub('^%s+', ''):gsub('%s+$', '')
  local macroInfo    = setDefs(expInfo, macroName)
  macroInfo.calls    = macroInfo.calls or { }
  tInsert(macroInfo.calls, { callType, macroArguments})
  return macroInfo
end

contests.recordExpansion = recordExpansion

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 800

local function returnMockedResults(expandedMacro)
  expandedMacro.returns = expandedMacro.returns or { }
  local result = tRemove(expandedMacro.returns, 1)
  if result and
     type(result) == 'string' and
     not result:match('^%s*$') then
    tex.print(result)
  end
end

contests.returnMockedResults = returnMockedResults

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 850

local function addMockResult(mockedMacro, returnValue)
  mockedMacro = mockedMacro:gsub('^%s+', ''):gsub('%s+$', '')
  mockedMacro          = setDefs(expInfo, mockedMacro)
  mockedMacro.returns  = mockedMacro.returns or { }
  tInsert(mockedMacro.returns, returnValue)
end

contests.addMockResult = addMockResult

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 850

local function mockExpansion(expandedMacro,
                               macroArguments,
                               callType)
  expandedMacro = recordExpansion(expandedMacro,
                               macroArguments,
                               callType)
  returnMockedResults(expandedMacro)
end

contests.mockExpansion = mockExpansion

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 1100

local function createMacro(theMacroName,
                           numArgs,
                           theArgType,
                           theActionType,
                           aTracingOn)
  local theArgList = { }
  for argNum = 1, numArgs, 1 do
    tInsert(theArgList, argNum)
  end
  local theArgTemplate = 'cmTexFormalArgs'
  if theArgType == 'context' then
    theArgTemplate = 'cmContextFormalArgs'
  end
  local theArgUseTemplate = 'cmTexUseArgs'
  if theArgType == 'context' then
    theArgUseTemplate = 'cmContextFormalArgs'
  end
  --
  local theEnv     = {
    tracingOn      = aTracingOn,
    macroName      = theMacroName,
    argList        = theArgList,
    argType        = theArgType,
    argTemplate    = theArgTemplate,
    argUseTemplate = theArgUseTemplate,
    emptyStr       = '',
    commaNewLine   = ',\n'
  }
  --
  local mainName   = 'ctmMain'
  if theActionType == 'mock' then
    mainName = 'cmmMain'
  end
  local mainPath     = litProgs.parseTemplatePath(mainName, theEnv)
  local mainTemplate = litProgs.navigateToTemplate(mainPath)
  local result       = litProgs.renderer(mainTemplate, theEnv, true)
  --
  result            = litProgs.splitString(result)
  tex.print(result)
  return result
end

contests.createMacro = createMacro

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 1250

function assertMacroExpanded(macroName, callNum, aMessage)
  local expectedMsg = 'Expected ['..macroName..']'
  local macroInfo   = expInfo[macroName]
  contests.reportMkIVAssertion(
    macroInfo ~= nil
    and macroInfo.calls ~= nil
    and macroInfo.calls[callNum] ~= nil,
    aMessage,
    expectedMsg..' to have been expanded at least '..
      toStr(callNum)..' times.'
  )
end

contests.assertMacroExpanded = assertMacroExpanded

function assertMacroNeverExpanded(macroName, callNum, aMessage)
  local expectedMsg = 'Expected ['..macroName..']'
  local macroInfo   = expInfo[macroName]
  contests.reportMkIVAssertion(
    macroInfo == nil
    or macroInfo.calls == nil
    or macroInfo.calls[callNum] == nil,
    aMessage,
    expectedMsg..' to have never been expanded '..
      toStr(callNum)..' times.'
  )
end

contests.assertMacroNeverExpanded = assertMacroNeverExpanded

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 1350

function assertMacroArguments(macroName,
                              callNum,
                              argNum,
                              aPattern,
                              aMessage)
  local expectedMsg = 'Expected ['..macroName..'] '
  local macroInfo = expInfo[macroName]
  if macroInfo then
    local calls = macroInfo.calls
    if calls then
      local aCall = calls[callNum]
      if aCall then
        local anArg = aCall[2][argNum]
        if anArg then
          if sMatch(anArg, aPattern) then
            reportMkIVAssertion(true, aMessage, '')
          else
            reportMkIVAssertion(false, aMessage,
              expectedMsg..'the '..
              toStr(argNum)..' argument on the '..
              toStr(callNum)..' expansion to match ['..
              aPattern..']')
          end
        else
          reportMkIVAssertion(false, aMessage,
            expectedMsg..'to have supplied '..
            toStr(argNum)..' arguments on the '..
            toStr(callNum)..' expansion')
        end
      else
        reportMkIVAssertion(false, aMessage,
          expectedMsg..'to have been expanded '..
          toStr(callNum)..' times')
      end
    else
      reportMkIVAssertion(false, aMessage,
        expectedMsg..'to have been expanded')
    end
  else
    reportMkIVAssertion(false, aMessage,
      expectedMsg..'to be defined')
  end
end

contests.assertMacroArguments = assertMacroArguments

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 0

function showValue(aValue, aMessage)
  texio.write_nl('-----------------------------------------------')
  if aMessage and type(aMessage) == 'string' and 0 < #aMessage then
    texio.write_nl(aMessage)
  end
  texio.write_nl(litProgs.prettyPrint(aValue))
  texio.write_nl('AT: '..status.filename..'::'..status.linenumber)
  texio.write_nl('-----------------------------------------------')
end

contests.showValue = showValue

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 50

local function addLuaTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.lua    = case.lua or {}
  tInsert(case.lua, bufferContents)
end

contests.addLuaTest = addLuaTest

local function buildLuaChunk(luaChunk)
  if type(luaChunk) == 'table' then
    luaChunk = tConcat(luaChunk, '\n')
  end

  if type(luaChunk) ~= 'string' then
    return nil
  end

  if luaChunk:match('^%s*$') then
    return nil
  end

  return [=[
---
local assert    = thirddata.contests.assert
local showValue = thirddata.contests.showValue
---
]=]..luaChunk..[=[

---
return true
]=]
end

contests.buildLuaChunk = buildLuaChunk

local function showLuaTest()
  texio.write_nl('-----------------------------------------------')
  local luaChunk = buildLuaChunk(tests.curSuite.curCase.lua)
  if luaChunk then
    texio.write_nl('Lua Test: ')
    texio.write_nl(luaChunk)
  else
    texio.write_nl('NO Lua Test could be built')
  end
  texio.write_nl('AT: '..status.filename..'::'..status.linenumber)
  texio.write_nl('-----------------------------------------------')
end

contests.showLuaTest = showLuaTest

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 100

local function runALuaTest(luaTest, suite, case)
  case.passed = case.passed or true
  local luaChunk = buildLuaChunk(luaTest)
  if not luaChunk then
    -- nothing to test
    return true
  end

  local caseStats = tests.stats.lua.cases
  caseStats.attempted = caseStats.attempted + 1
  local luaFunc, errMessage = load(luaChunk)
  if not luaFunc then
    -- could not compile the lua chunk
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
    return false
  end

  local ok, errObj = pcall(luaFunc)
  if not ok then
    -- could not run the tests or one failed
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
    return false
  end

  -- all tests passed
  caseStats.passed = caseStats.passed + 1
  tex.print("\\noindent{\\green PASSED}")
  return true
end

contests.runALuaTest = runALuaTest

local function runCurLuaTestCase(suite, case)
  runALuaTest(case.lua, suite, case)
end

contests.testRunners.runCurLuaTestCase = runCurLuaTestCase

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 250

local function runLuaConTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local curSuite       = tests.curSuite
  local curCase        = curSuite.curCase
  local result         = runALuaTest(bufferContents, curSuite, curCase)
  reportMkIVAssertion(
    result,
    'LuaConTest failed',
    'expected LuaConTest ['..bufferContents..'] to succeed'
  )
end

contests.runLuaConTest = runLuaConTest

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 250

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
    local info     = { }
    info['currentline'] = 'no information -- run with --debug'
    if debug.getinfo then
      info     = debug.getinfo(2,'l')
    end
    test.line      = info.currentline
    assertionStats.failed = assertionStats.failed + 1
    error(test, 0) -- throw an error to be captured by an error_handler
  end
  assertionStats.passed = assertionStats.passed + 1
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 300

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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 400

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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 450

function assert.fail(aMessage)
  return reportLuaAssertion(
    false,
    aMessage,
    "(Failed)"
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 500

function assert.succeed(aMessage)
  return reportLuaAssertion(
    true,
    aMessage,
    "(Succeed)"
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 500

function assert.isBoolean(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'boolean',
    aMessage,
    sFmt("Expected %s to be a boolean.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 550

function assert.isNotBoolean(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'boolean',
    aMessage,
    sFmt("Expected %s to not be a boolean.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 600

function assert.isTrue(aBoolean, aMessage)
  return reportLuaAssertion(
    aBoolean,
    aMessage,
    sFmt("Expected true, got %s.", toStr(aBoolean))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 650

function assert.isFalse(aBoolean, aMessage)
  return reportLuaAssertion(
    not aBoolean,
    aMessage,
    sFmt("Expected false, got %s.", toStr(aBoolean))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 700

function assert.isNil(anObj, aMessage)
  return reportLuaAssertion(
    anObj == nil,
    aMessage,
    sFmt("Expected nil, got %s.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 700

function assert.isNotNil(anObj, aMessage)
  return reportLuaAssertion(
    anObj ~= nil,
    aMessage,
    sFmt("Expected non-nil, got %s.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 750

function assert.isEqual(objA, objB, aMessage)
  return reportLuaAssertion(
    objA == objB,
    aMessage,
    sFmt("Expected %s to equal %s.",
      toStr(objA), toStr(objB))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 800

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

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 850

function assert.isNotEqual(objA, objB, aMessage)
  return reportLuaAssertion(
    objA ~= objB,
    aMessage,
    sFmt("Expected %s to not equal %s.",
      toStr(objA), toStr(objB))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 900

function assert.isNotEqualWithIn(numA, numB, tolerance, aMessage)
  return reportLuaAssertion(
    type(numA) ~= 'number' or type(numB) ~= 'number'
    or tolerance < math.abs(numA - numB),
    aMessage,
    sFmt("Expected %s to not equal %s with tolerance %s.",
      toStr(numA), toStr(numB), toStr(tolerance))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 950

function assert.isNumber(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'number',
    aMessage,
    sFmt("Expected %s to be a number.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1000

function assert.isGT(objA, objB, aMessage)
  return reportLuaAssertion(
    objA > objB,
    aMessage,
    sFmt("Expected %s > %s.", toStr(objA), toStr(objB))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1050

function assert.isGTE(objA, objB, aMessage)
  return reportLuaAssertion(
    objA >= objB,
    aMessage,
    sFmt("Expected %s >= %s.", toStr(objA), toStr(objB))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1100

function assert.isLT(objA, objB, aMessage)
  return reportLuaAssertion(
    objA < objB,
    aMessage,
    sFmt("Expected %s < %s.", toStr(objA), toStr(objB))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1150

function assert.isLTE(objA, objB, aMessage)
  return reportLuaAssertion(
    objA <= objB,
    aMessage,
    sFmt("Expected %s <= %s.", toStr(objA), toStr(objB))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1200

function assert.isNotNumber(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'number',
    aMessage,
    sFmt("Expected %s to be a number.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1250

function assert.isString(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'string',
    aMessage,
    sFmt("Expected [%s] to be a string.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1300

function assert.matches(anObj, aPattern, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'string' and type(aPattern) == 'string'
    and anObj:match(aPattern),
    aMessage,
    sFmt("Expected [%s] to match [%s].",
      toStr(anObj), toStr(aPattern))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1350

function assert.doesNotMatch(anObj, aPattern, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'string' or type(aPattern) ~= 'string'
    or not anObj:match(aPattern),
    aMessage,
    sFmt("Expected [%s] to not match [%s].",
      toStr(anObj), toStr(aPattern))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1400

function assert.length(anObj, aLength, aMessage)
  return reportLuaAssertion(
    #anObj == aLength,
    aMessage,
    sFmt("Expected %s to have length %s.",
      toStr(anObj), toStr(aLength))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1450

function assert.isNotLength(anObj, aLength, aMessage)
  return reportLuaAssertion(
    #anObj ~= aLength,
    aMessage,
    sFmt("Expected %s to not have length %s.",
      toStr(anObj), toStr(aLength))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1500

function assert.isNotString(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'string',
    aMessage,
    sFmt("Expected [%s] to not be a string.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1500

function assert.isTable(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table',
    aMessage,
    sFmt("Expected %s to be a table.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1550

function assert.hasKey(anObj, aKey, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table' and anObj[aKey] ~= nil,
    aMessage,
    sFmt("Expected %s to have the key %s.",
      toStr(anObj), toStr(aKey))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1600

function assert.doesNotHaveKey(anObj, aKey, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table' and anObj[aKey] == nil,
    aMessage,
    sFmt("Expected %s to not have the key %s.",
      toStr(anObj), toStr(aKey))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1650

function assert.isNotTable(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'table',
    aMessage,
    sFmt("Expected %s to not be a table.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1700

function assert.isFunction(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'function',
    aMessage,
    sFmt("Expected %s to be a function.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1750

function assert.isNotFunction(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'function',
    aMessage,
    sFmt("Expected %s to not be a function.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1750

function assert.hasMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) ~= nil,
    aMessage,
    sFmt("Expected %s to have a meta table.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1800

function assert.metaTableEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) == aMetaTable,
    aMessage,
    sFmt("Expected %s to have the meta table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1850

function assert.metaTableNotEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) ~= aMetaTable,
    aMessage,
    sFmt("Expected %s to not have the meta-table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1900

function assert.doesNotHaveMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) == nil,
    aMessage,
    sFmt("Expected %s to not have a meta table.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1900

function assert.isThread(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'thread',
    aMessage,
    sFmt("Expected %s to be a thread.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 1950

function assert.isNotThread(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'thread',
    aMessage,
    sFmt("Expected %s to not be a thread.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 2000

function assert.isUserData(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'userdata',
    aMessage,
    sFmt("Expected %s to be user data.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/luaTests.tex after line: 2050

function assert.isNotUserData(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'userdata',
    aMessage,
    sFmt("Expected %s to not be user data.", toStr(anObj))
  )
end

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/cTests.tex after line: 50

local function addCTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local methods        = setDefs(tests, 'methods')
  local suite          = setDefs(tests, 'curSuite')
  local case           = setDefs(suite, 'curCase')
  local cTests         = setDefs(case, 'cTests')
  local curStage       = tests.stage:lower()
  if curStage:find('global') then
    if curStage:find('up') then
      local setup      = setDefs(tests, 'setup')
      cTests           = setDefs(setup, 'cTests')
    elseif curStage:find('down') then
      local teardown   = setDefs(tests, 'teardown')
      cTests           = setDefs(teardown, 'cTests')
    end
  elseif curStage:find('suite') then
    if curStage:find('up') then
      local setup      = setDefs(suite, 'setup')
      cTests           = setDefs(setup, 'cTests')
    elseif curStage:find('down') then
      local teardown   = setDefs(suite, 'teardown')
      cTests           = setDefs(teardown, 'cTests')
    end
  elseif curStage:find('method') then
    if curStage:find('up') then
      local setup      = setDefs(methods, 'setup')
      cTests           = setDefs(setup, 'cTests')
    elseif curStage:find('down') then
      local teardown   = setDefs(methods, 'teardown')
      cTests           = setDefs(teardown, 'cTests')
    end
  end
  tests.stage          = ''
  local cTestStream    = setDefs(tests, 'curCTestStream', 'default')
  cTestStream          = setDefs(cTests, cTestStream)
  tInsert(cTestStream, bufferContents)
end

contests.addCTest = addCTest

local function setCTestStage(suiteCase, setupTeardown)
  tests.stage = suiteCase..'-'..setupTeardown
end

contests.setCTestStage = setCTestStage

local function setCTestStream(aCodeStream)
  if type(aCodeStream) ~= 'string'
    or #aCodeStream < 1 then
    aCodeStream = 'default'
  end
  tests.curCTestStream = aCodeStream
end

contests.setCTestStream = setCTestStream

local function addCTestInclude(anInclude)
  local cIncludes        = setDefs(tests, 'cIncludes')
  local cTestStream      = setDefs(tests, 'curCTestStream', 'default')
  cTestStream            = setDefs(cIncludes, cTestStream)
  tInsert(cTestStream, anInclude)
end

contests.addCTestInclude = addCTestInclude

local function addCTestLibDir(aLibDir)
  local cLibDirs        = setDefs(tests, 'cLibDirs')
  local cTestStream     = setDefs(tests, 'curCTestStream', 'default')
  cTestStream           = setDefs(cLibDirs, cTestStream)
  tInsert(cTestStream, aLibDir)
end

contests.addCTestLibDir = addCTestLibDir

local function addCTestLib(aLib)
  local cLibs          = setDefs(tests, 'cLibs')
  local cTestStream    = setDefs(tests, 'curCTestStream', 'default')
  cTestStream          = setDefs(cLibs, cTestStream)
  tInsert(cTestStream, aLib)
end

contests.addCTestLib = addCTestLib

local function addCTestMITLicense(cTestStream, copyrightOwner)
  local cLicense       = setDefs(tests, 'cLicense')
  local cTestStream    = setDefs(tests, 'curCTestStream', 'default')
  cTestStream          = setDefs(cLicense, cTestStream)
  -- the above does not actual use the provided cTestStream
 
  local commentStart = '//'
  local copyright = { }
  tInsert(copyright, commentStart ..
    ' Copyright '..os.date('%Y')..' '..copyrightOwner)
  tInsert(copyright,  commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' Permission is hereby granted, free of charge, to any person')
  tInsert(copyright, commentStart ..
    ' obtaining a copy of this software and associated documentation')
  tInsert(copyright, commentStart ..
    ' files (the "Software"), to deal in the Software without')
  tInsert(copyright, commentStart ..
    ' restriction, including without limitation the rights to use,')
  tInsert(copyright, commentStart ..
    ' copy, modify, merge, publish, distribute, sublicense, and/or sell')
  tInsert(copyright, commentStart ..
    ' copies of the Software, and to permit persons to whom the')
  tInsert(copyright, commentStart ..
    ' Software is furnished to do so, subject to the following')
  tInsert(copyright, commentStart ..
    ' conditions:')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    '    The above copyright notice and this permission notice shall')
  tInsert(copyright, commentStart ..
    '    be included in all copies or substantial portions of the')
  tInsert(copyright, commentStart ..
    '    Software.')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,')
  tInsert(copyright, commentStart ..
    ' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES')
  tInsert(copyright, commentStart ..
    ' OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND')
  tInsert(copyright, commentStart ..
    ' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT')
  tInsert(copyright, commentStart ..
    ' HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,')
  tInsert(copyright, commentStart ..
    ' WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING')
  tInsert(copyright, commentStart ..
    ' FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR')
  tInsert(copyright, commentStart ..
    ' OTHER DEALINGS IN THE SOFTWARE.')

  copyright = tConcat(copyright, "\n")

  tInsert(cTestStream, copyright)
end

contests.addCTestMITLicense = addCTestMITLicense

local function addCTestApacheLicense(cTestStream, copyrightOwner)
  local cLicense       = setDefs(tests, 'cLicense')
  local cTestStream    = setDefs(tests, 'curCTestStream', 'default')
  cTestStream          = setDefs(cLicense, cTestStream)
  -- the above does not actual use the provided cTestStream

  local  commentStart = '//'
  local  copyright = { }
  tInsert(copyright, commentStart ..
    ' Copyright '..os.date('%Y')..' '..copyrightOwner)
  tInsert(copyright,  commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' Licensed under the Apache License, Version 2.0 (the "License");')
  tInsert(copyright, commentStart ..
    ' you may not use this file except in compliance with the License.')
  tInsert(copyright, commentStart ..
    ' You may obtain a copy of the License at')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    '    http://www.apache.org/licenses/LICENSE-2.0')
  tInsert(copyright, commentStart ..
    '')
  tInsert(copyright, commentStart ..
    ' Unless required by applicable law or agreed to in writing,')
  tInsert(copyright, commentStart ..
    ' software distributed under the License is distributed on an "AS')
  tInsert(copyright, commentStart ..
    ' IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either')
  tInsert(copyright, commentStart ..
    ' express or implied. See the License for the specific language')
  tInsert(copyright, commentStart ..
    ' governing permissions and limitations under the License. end')
  copyright = tConcat(copyright, "\n")

  tInsert(cTestStream, copyright)
end

contests.addCTestApacheLicense = addCTestApacheLicense


local function createCTestFile(aCodeStream, aFilePath, aFileHeader)

  if type(aFilePath) ~= 'string'
    or #aFilePath < 1 then
    texio.write('\nERROR: no file name provided for cTests\n\n')
    return
  end

  build.cTestTargets = build.cTestTargets or { }
  local aTestExec = aFilePath:gsub('%..+$','')
  tInsert(build.cTestTargets, aTestExec)

  local outFile = io.open(aFilePath, 'w')
  if not outFile then
    return
  end

  texio.write('creating CTest file: ['..aFilePath..']\n')

  if type(aFileHeader) == 'string'
    and 0 < #aFileHeader then
    outFile:write(aFileHeader)
    outFile:write('\n\n')
  end

  tests.suites = tests.suites or { }

  if type(aCodeStream) ~= 'string'
    or #aCodeStream < 1 then
    aCodeStream = 'default'
  end

  local cLicense = setDefs(tests, 'cLicense')
  cLicense[aCodeStream] = cLicense[aCodeStream] or { }

--  texio.write_nl(lPPrint(cLicense[aCodeStream]))
  for i, aLicense in ipairs(cLicense[aCodeStream]) do
    outFile:write(aLicense)
  end

  outFile:write('\n\n')
  outFile:write('//-------------------------------------------------------\n')
  outFile:write('\n\n')

  outFile:write('#include <t-contests.h>\n')
  outFile:write('\n\n')

  outFile:write('//-------------------------------------------------------\n')
  local cIncludes = setDefs(tests, 'cIncludes')

  cIncludes[aCodeStream] = cIncludes[aCodeStream] or { }

  for i, anInclude in ipairs(cIncludes[aCodeStream]) do
    outFile:write('#include '..anInclude..'\n')
  end
  outFile:write('\n\n')

  tests.methods = tests.methods or { }
  local methods = tests.methods
  methods.setup = methods.setup or { }
  local mSetup  = methods.setup
  mSetup.cTests = mSetup.cTests or { }
  msCTests      = mSetup.cTests

  --msCTests[aCodeStream] = msCTests[aCodeStream] or { }

  if msCTests and
    msCTests[aCodeStream] then
    outFile:write('  // CTests methods setup\n')
    local setupCode = tConcat(msCTests[aCodeStream],'\n')
    setupCode       = litProgs.splitString(setupCode)
    outFile:write('  '..tConcat(setupCode, '\n  '))
    outFile:write('\n\n')
  end
  outFile:write('\n\n')

  outFile:write('//-------------------------------------------------------\n')
  outFile:write('int main(){\n\n')
  outFile:write('  lua_State *lstate = luaL_newstate();\n')
  outFile:write('  luaL_openlibs(lstate);\n\n')

  outFile:write('  if luaL_dofile(lstate, CTESTS_STARTUP) {\n')
  outFile:write('    fprintf(stderr, "Could not load cTests\\n");\n')
  outFile:write('    fprintf(stderr, "%s\\n", lua_tostring(lstate, 1));\n')
  outFile:write('    exit(-1);\n')
  outFile:write('  }\n\n')

  tests.setup = tests.setup or { }
  if tests.setup.cTests and
    tests.setup.cTests[aCodeStream] then
    outFile:write('  // CTests setup\n')
    local setupCode = tConcat(tests.setup.cTests[aCodeStream],'\n')
    setupCode       = litProgs.splitString(setupCode)
    outFile:write('  '..tConcat(setupCode, '\n  '))
    outFile:write('\n\n')
  end

  for i, aTestSuite in ipairs(tests.suites) do
    aTestSuite.cases = aTestSuite.cases or { }
    local suiteCaseBuf = { }

    for j, aTestCase in ipairs(aTestSuite.cases) do
      local cTests     = setDefs(aTestCase, 'cTests')
      if aTestCase.desc and
        aTestCase.fileName and
        aTestCase.startLine and
        aTestCase.lastLine and
        cTests[aCodeStream] then
        tInsert(suiteCaseBuf, '    for (size_t i = 0; i < 1; i++) {\n\n')
        tInsert(suiteCaseBuf, '      StartTestCase(\n')
        tInsert(suiteCaseBuf, '        "'..aTestCase.desc..'",\n')
        tInsert(suiteCaseBuf, '        "'..aTestCase.fileName..'",\n')
        tInsert(suiteCaseBuf, '        '..toStr(aTestCase.startLine)..',\n')
        tInsert(suiteCaseBuf, '        '..toStr(aTestCase.lastLine)..'\n')
        tInsert(suiteCaseBuf, '      );\n\n  ')
        local cTestsCode = tConcat(cTests[aCodeStream], '\n')
        cTestsCode       = litProgs.splitString(cTestsCode)
        tInsert(suiteCaseBuf, '    '..tConcat(cTestsCode, '\n      '))
        tInsert(suiteCaseBuf, '\n\n      StopTestCase();\n\n')
        tInsert(suiteCaseBuf, '    }\n\n')
      elseif (not aTestCase.desc or
        not aTestCase.fileName or
        not aTestCase.startLine or
        not aTestCase.lastLine) and
        cTests[aCodeStream] then
        texio.write("\nERROR missing \\startTestCase\n")
        texio.write("near:\n")
        texio.write(tConcat(cTests[aCodeStream], '\n'))
        texio.write('\n')
      end
    end

    if aTestSuite.desc and (0 < #suiteCaseBuf) then
      outFile:write('  //-------------------------------------------------------\n')
      outFile:write('  for (size_t i = 0; i < 1; i++) {\n\n')
      outFile:write('    StartTestSuite(\n')
      outFile:write('      "'..aTestSuite.desc..'"\n')
      outFile:write('    );\n\n')

      aTestSuite.setup = aTestSuite.setup or { }
      if aTestSuite.setup.cTests and
        aTestSuite.setup.cTests[aCodeStream] then
        outFile:write('    // TestSuite setup\n')
        local setupCode = tConcat(aTestSuite.setup.cTests[aCodeStream],'\n  ')
        setupCode = litProgs.splitString(setupCode, '\n')
        outFile:write('    '..tConcat(setupCode, '\n    '))
        outFile:write('\n\n')
      end

      outFile:write(tConcat(suiteCaseBuf))

      aTestSuite.teardown = aTestSuite.teardown or { }
      if aTestSuite.teardown.cTests and
        aTestSuite.teardown.cTests[aCodeStream] then
        outFile:write('    // TestSuite teardown\n')
        local teardownCode = tConcat(aTestSuite.teardown.cTests[aCodeStream],'\n  ')
        teardownCode = litProgs.splitString(teardownCode, '\n')
        outFile:write('    '..tConcat(teardownCode, '\n    '))
        outFile:write('\n\n')
      end

      outFile:write('\n    StopTestSuite();\n\n')
      outFile:write('  }\n\n')
    elseif not aTestSuite.desc and (0 < #suiteCaseBuf) then
      texio.write("\nERROR missing \\startTestSuite\n")
      texio.write("near:\n")
      texio.write(tConcat(suiteCaseBuf, '\n'))
      texio.write('\n')
    end
  end

  tests.teardown = tests.teardown or { }
  if tests.teardown.cTests and
    tests.teardown.cTests[aCodeStream] then
    outFile:write('  // CTests teardown\n')
    local teardownCode =tConcat(tests.teardown.cTests[aCodeStream],'\n  ')
    teardownCode = litProgs.splitString(teardownCode, '\n')
    outFile:write('  '..tConcat(teardownCode, '\n  '))
    outFile:write('\n\n')
  end

  outFile:write('\n  fprintf(stdout, "\\n");\n\n')

  outFile:write('\n  lua_getglobal(lstate, "getNumFailures");\n')
  outFile:write(  '  lua_errorCall(0,1);\n')
  outFile:write(  '  int numFailures = lua_tointeger(lstate, -1);\n')
  outFile:write(  '  lua_pop(lstate, 1);\n\n')

  outFile:write(  '  if (0 < numFailures) {\n')
  outFile:write(  '    fprintf(stdout, "FAILURES FOUND: %u\\n",\n')
  outFile:write(  '      numFailures\n')
  outFile:write(  '    );\n')
  outFile:write(  '  }\n')

  outFile:write('\n  return numFailures;\n')
  outFile:write('}\n')

  outFile:close()
end

contests.createCTestFile = createCTestFile

local function addCTestTargets(aCodeStream)
  litProgs.setCodeStream('Lmsfile', aCodeStream)
  litProgs.markCodeOrigin('Lmsfile')
  local lmsfile = {}
  tInsert(lmsfile, "require 'lms.cTests'\n")
  tInsert(lmsfile, "cTests.targets(cTargets, {")
  tInsert(lmsfile, "  testExecs = {")
  if build.cTestTargets then
    for i, aTestExec in ipairs(build.cTestTargets) do
      tInsert(lmsfile, "    '"..aTestExec.."',")
    end
  end
  tInsert(lmsfile, "  },")

  tInsert(lmsfile, "  testLibDirs = {")
  if tests.cLibDirs and tests.cLibDirs[aCodeStream] then
    for i, aLibDir in ipairs(tests.cLibDirs[aCodeStream]) do
      tInsert(lmsfile, "    '"..aLibDir.."',")
    end
  end
  if build.cCodeLibDirs then
    for i, aLibDir in ipairs(build.cCodeLibDirs) do
      tInsert(lmsfile, "    '"..aLibDir.."',")
    end
  end
  tInsert(lmsfile, "  },")
  tInsert(lmsfile, "  testLibs = {")
  if tests.cLibs and tests.cLibs[aCodeStream] then
    for i, aLib in ipairs(tests.cLibs[aCodeStream]) do
      tInsert(lmsfile, "    '"..aLib.."',")
    end
  end
  if build.cCodeLibs then
    for i, aLib in ipairs(build.cCodeLibs) do
      tInsert(lmsfile, "    '"..aLib.."',")
    end
  end
  tInsert(lmsfile, "  },")
  tInsert(lmsfile, "})")
--  litProgs.setPrepend('Lmsfile', aCodeStream, true)
  litProgs.addCode.default('Lmsfile', tConcat(lmsfile, '\n'))
end

contests.addCTestTargets = addCTestTargets


-- A Lua file (the lua code associated with t-contests.mkiv)

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

local function initRawStats()
  local raw = {}
  raw.attempted  = 0
  raw.passed     = 0
  raw.failed     = 0
  raw.expected   = 0
  raw.unexpected = 0
  return raw
end

local function initStats()
  local stats = {}
  stats.assertions = initRawStats()
  stats.cases      = initRawStats()
  stats.suites     = initRawStats()
  return stats
end

tests.stats      = {}
tests.stats.mkiv = initStats()
tests.stats.lua  = initStats()

local pp = require('pl/pretty')
local table_insert = table.insert
local table_concat = table.concat

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

function contests.collectTestSuite()
  table_insert(tests.suites, tests.curSuite)
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

function contests.collectTestCase()
  local curSuite   = tests.curSuite
  local curCase    = curSuite.curCase
  curCase.lastLine = status.linenumber
  contests.runCurLuaTestCase(curSuite, curCase)
  table_insert(curSuite.cases, curCase)
  curSuite.curCase = {}
end

function contests.reportStats(statsType)
  local stats = tests.stats[statsType]
  local rows = { 'cases', 'assertions' }
  local cols =
    { 'attempted', 'passed', 'failed' }
  local colCol = { '', '\\green', '\\red' }
  stats.assertions.unexpected =
    stats.assertions.failed - stats.assertions.expected
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
    tex.print(aFailure.testMsg)
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

local fmt   = string.format
local toStr = tostring

function contests.addLuaTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.lua    = case.lua or {}
  table_insert(case.lua, bufferContents)
end

function contests.runCurLuaTestCase(suite, case)
  case.passed = case.passed or true
  local luaChunk = table_concat(case.lua, '\n')
  if not luaChunk:match('^%s*$') then
    local caseStats = tests.stats.lua.cases
    caseStats.attempted = caseStats.attempted + 1
    luaChunk = [=[
    local assert = thirddata.contests.assert
    ]=]..luaChunk..[=[
    return true
    ]=]
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
        local failure = logFailure(
          "FAILED",
          suite.desc,
          case.desc,
          errObj.message,
          toStr(errObj.reason),
          fmt("in file: %s between lines %s and %s",
            case.fileName, toStr(case.startLine), toStr(case.lastLine))
        )
        reportFailure(failure, false)
        table_insert(tests.failures, failure)
      end
    else
      case.passed  = false
      suite.passed = false
      caseStats.failed = caseStats.failed + 1
      local failure = logFailure(
        "FAILED TO COMPILE",
        suite.desc,
        case.desc,
        "",
        errMessage,
        fmt("in file: %s between lines %s and %s",
          case.fileName, toStr(case.startLine), toStr(case.lastLine))
      )
      reportFailure(failure, false)
      table_insert(tests.failures, failure)
    end
  end
end

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
    fmt("Expected %s to throw an error.", toStr(aFunction))
  )
end

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
    fmt("Expected %s not to throw an error (%s).",
      toStr(aFunction), toStr(err))
  )
end

function assert.fail(aMessage)
  return reportLuaAssertion(
    false,
    aMessage,
    "(Failed)"
  )
end

function assert.succeed(aMessage)
  return reportLuaAssertion(
    true,
    aMessage,
    "(Succeed)"
  )
end

function assert.isBoolean(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'boolean',
    aMessage,
    fmt("Expected %s to be a boolean.", toStr(anObj))
  )
end

function assert.isNotBoolean(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'boolean',
    aMessage,
    fmt("Expected %s to not be a boolean.", toStr(anObj))
  )
end

function assert.isTrue(aBoolean, aMessage)
  return reportLuaAssertion(
    aBoolean,
    aMessage,
    fmt("Expected true, got %s.", toStr(aBoolean))
  )
end

function assert.isFalse(aBoolean, aMessage)
  return reportLuaAssertion(
    not aBoolean,
    aMessage,
    fmt("Expected false, got %s.", toStr(aBoolean))
  )
end

function assert.isNil(anObj, aMessage)
  return reportLuaAssertion(
    anObj == nil,
    aMessage,
    fmt("Expected nil, got %s.", toStr(anObj))
  )
end

function assert.isNotNil(anObj, aMessage)
  return reportLuaAssertion(
    anObj ~= nil,
    aMessage,
    fmt("Expected non-nil, got %s.", toStr(anObj))
  )
end

function assert.isEqual(objA, objB, aMessage)
  return reportLuaAssertion(
    objA == objB,
    aMessage,
    fmt("Expected %s to equal %s.",
      toStr(objA), toStr(objB))
  )
end

function assert.isEqualWithIn(numA, numB,
  tolerance, aMessage)
  return reportLuaAssertion(
    type(numA) == 'number' and type(numB) == 'number'
    and math.abs(numA - numB) <= tolerance,
    aMessage,
    fmt("Expected %s to equal %s with tolerance %s.",
      toStr(numA), toStr(numB), toStr(tolerance))
  )
end

function assert.isNotEqual(objA, objB, aMessage)
  return reportLuaAssertion(
    objA ~= objB,
    aMessage,
    fmt("Expected %s to not equal %s.",
      toStr(objA), toStr(objB))
  )
end

function assert.isNotEqualWithIn(numA, numB, tolerance, aMessage)
  return reportLuaAssertion(
    type(numA) ~= 'number' or type(numB) ~= 'number'
    or tolerance < math.abs(numA - numB),
    aMessage,
    fmt("Expected %s to not equal %s with tolerance %s.",
      toStr(numA), toStr(numB), toStr(tolerance))
  )
end

function assert.isNumber(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'number',
    aMessage,
    fmt("Expected %s to be a number.", toStr(anObj))
  )
end

function assert.isGT(objA, objB, aMessage)
  return reportLuaAssertion(
    objA > objB,
    aMessage,
    fmt("Expected %s > %s.", toStr(objA), toStr(objB))
  )
end

function assert.isGTE(objA, objB, aMessage)
  return reportLuaAssertion(
    objA >= objB,
    aMessage,
    fmt("Expected %s >= %s.", toStr(objA), toStr(objB))
  )
end

function assert.isLT(objA, objB, aMessage)
  return reportLuaAssertion(
    objA < objB,
    aMessage,
    fmt("Expected %s < %s.", toStr(objA), toStr(objB))
  )
end

function assert.isLTE(objA, objB, aMessage)
  return reportLuaAssertion(
    objA <= objB,
    aMessage,
    fmt("Expected %s <= %s.", toStr(objA), toStr(objB))
  )
end

function assert.isNotNumber(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'number',
    aMessage,
    fmt("Expected %s to be a number.", toStr(anObj))
  )
end

function assert.isString(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'string',
    aMessage,
    fmt("Expected [%s] to be a string.", toStr(anObj))
  )
end

function assert.matches(anObj, aPattern, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'string' and type(aPattern) == 'string'
    and anObj:match(aPattern),
    aMessage,
    fmt("Expected [%s] to match [%s].",
      toStr(anObj), toStr(aPattern))
  )
end

function assert.doesNotMatch(anObj, aPattern, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'string' or type(aPattern) ~= 'string'
    or not anObj:match(aPattern),
    aMessage,
    fmt("Expected [%s] to not match [%s].",
      toStr(anObj), toStr(aPattern))
  )
end

function assert.length(anObj, aLength, aMessage)
  return reportLuaAssertion(
    #anObj == aLength,
    aMessage,
    fmt("Expected %s to have length %s.",
      toStr(anObj), toStr(aMessage))
  )
end

function assert.isNotLength(anObj, aLength, aMessage)
  return reportLuaAssertion(
    #anObj ~= aLength,
    aMessage,
    fmt("Expected %s to not have length %s.",
      toStr(anObj), toStr(aMessage))
  )
end

function assert.isNotString(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'string',
    aMessage,
    fmt("Expected [%s] to not be a string.", toStr(anObj))
  )
end

function assert.isTable(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table',
    aMessage,
    fmt("Expected %s to be a table.", toStr(anObj))
  )
end

function assert.hasKey(anObj, aKey, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table' and anObj[aKey] ~= nil,
    aMessage,
    fmt("Expected %s to have the key %s.",
      toStr(anObj), toStr(aKey))
  )
end

function assert.doesNotHaveKey(anObj, aKey, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'table' and anObj[aKey] == nil,
    aMessage,
    fmt("Expected %s to not have the key %s.",
      toStr(anObj), toStr(aKey))
  )
end

function assert.isNotTable(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'table',
    aMessage,
    fmt("Expected %s to not be a table.", toStr(anObj))
  )
end

function assert.isFunction(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'function',
    aMessage,
    fmt("Expected %s to be a function.", toStr(anObj))
  )
end

function assert.isNotFunction(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'function',
    aMessage,
    fmt("Expected %s to not be a function.", toStr(anObj))
  )
end

function assert.hasMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) ~= nil,
    aMessage,
    fmt("Expected %s to have a meta table.", toStr(anObj))
  )
end

function assert.metaTableEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) == aMetaTable,
    aMessage,
    fmt("Expected %s to have the meta table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

function assert.metaTableNotEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) ~= aMetaTable,
    aMessage,
    fmt("Expected %s to not have the meta-table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

function assert.doesNotHaveMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getmetatable(anObj) == nil,
    aMessage,
    fmt("Expected %s to not have a meta table.", toStr(anObj))
  )
end

function assert.isThread(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'thread',
    aMessage,
    fmt("Expected %s to be a thread.", toStr(anObj))
  )
end

function assert.isNotThread(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'thread',
    aMessage,
    fmt("Expected %s to not be a thread.", toStr(anObj))
  )
end

function assert.isUserData(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) == 'userdata',
    aMessage,
    fmt("Expected %s to be user data.", toStr(anObj))
  )
end

function assert.isNotUserData(anObj, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'userdata',
    aMessage,
    fmt("Expected %s to not be user data.", toStr(anObj))
  )
end

function contests.addCTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.ansiC  = case.ansiC or {}
  table_insert(case.ansiC, bufferContents)
end

function contests.collectCTest()

end

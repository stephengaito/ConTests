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
contests.assert = {}
local assert    = contests.assert

local pp = require('pl/pretty')
local table_insert = table.insert
local table_concat = table.concat

function contests.startTestSuite(aDesc)
  tests.curSuite       = {}
  tests.curSuite.cases = {}
  tests.curSuite.desc  = aDesc
end

function contests.collectTestSuite()
  table_insert(tests.suites, tests.curSuite)
  tests.curSuite = {}
end

function contests.startTestCase(aDesc)
  local suite = tests.curSuite
  suite.curCase = {}
  suite.curCase.desc = aDesc
end

function contests.collectTestCase()
  local suite = tests.curSuite
  contests.runCurLuaTestCase(suite.curCase)
  table_insert(suite.cases, suite.curCase)
  suite.curCase = {}
end

function contests.addLuaTest(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  local suite = tests.curSuite
  local case  = suite.curCase
  case.lua    = case.lua or {}
  table_insert(case.lua, bufferContents)
end

function contests.runCurLuaTestCase(case)
  local luaChunk = table_concat(case.lua, '\n')
  if not luaChunk:match('^%s*$') then
    luaChunk = [=[
    local assert = thirddata.contests.assert
    ]=]..luaChunk..[=[
    return true
    ]=]
    local luaFunc, errMessage = load(luaChunk)
    if luaFunc then
      local ok, errObj = pcall(luaFunc)
      if ok then
        tex.print("\\noindent{\\green PASSED}")
      else
        tex.print("\\noindent{\\red FAILED}: \\\\")
        tex.cprint(12, pp.write(errObj))
        tex.print("\\\\ on \\ConTeXt\\ line number \\the\\inputlineno")
      end
    else
      tex.print("\\noindent{\\red FAILED TO COMPILE}: \\\\")
      tex.cprint(12, errMessage)
      tex.print("\\\\ on \\ConTeXt\\ line number \\the\\inputlineno")      
    end
    tex.print("\\hairline")
  end
end

function reportLuaAssertion(theCondition, aMessage, theReason)
  -- we do not need to do anything unless theCondition if false!
  if not theCondition then
    local test     = { }
    test.message   = aMessage
    test.reason    = theReason
    test.condition = theCondition
    local info     = debug.getinfo(2,'l')
    test.line      = info.currentline
    error(test, 0) -- throw an error to be captured by an error_handler
  end
end

local fmt   = string.format
local toStr = tostring

function assert.throwsError(aFunction, aMessage, ...)
  local ok, err = pcall(aFunction, ...)
  return reportLuaAssertion(
    not ok,
    aMessage,
    fmt("Expected %s to throw an error.", toStr(aFunction))
  )
end

function assert.throwsNoError(aFunction, aMessage, ...)
  local ok, err = pcall(aFunction, ...)
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
    and anObj:matches(aPattern),
    aMessage,
    ftm("Expected [%s] to match [%s].",
      toStr(anObj), toStr(aPattern))
  )
end

function assert.doesNotMatch(anObj, aPattern, aMessage)
  return reportLuaAssertion(
    type(anObj) ~= 'string' or type(aPattern) ~= 'string'
    or not anObj:matches(aPattern),
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
    anObj[aKey] ~= nil,
    aMessage,
    fmt("Expected %s to have the key %s.",
      toStr(anObj), toStr(aKey))
  )
end

function assert.doesNotHaveKey(anObj, aKey, aMessage)
  return reportLuaAssertion(
    anObj[aKey] == nil,
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

function assert.hasMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getMetaTable(anObj) ~= nil,
    aMessage,
    fmt("Expected %s to have a meta table.", toStr(anObj))
  )
end

function assert.metaTableEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getMetaTable(anObj) == aMetaTable,
    aMessage,
    fmt("Expected %s to have the meta table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

function assert.metaTableNotEqual(anObj, aMetaTable, aMessage)
  return reportLuaAssertion(
    getMetaTable(anObj) ~= aMetaTable,
    aMessage,
    fmt("Expected %s to not have the meta table %s.",
      toStr(anObj), toStr(aMetaTable))
  )
end

function assert.hasMetaTable(anObj, aMessage)
  return reportLuaAssertion(
    getMetaTable(anObj) == nil,
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

function contests.collectCTest()

end

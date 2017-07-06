// An ANSI-C header file

// from file: cTests.tex after line: 100

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef NULL
#define NULL 0
#endif

#define lua_errorCall(numArgs, numRtn)             \
  if (lua_pcall(lstate, (numArgs), (numRtn), 0)) { \
    fprintf(stderr,                                \
      "LUA error in file %s at line %d\n",         \
      __FILE__, __LINE__                           \
    );                                             \
  }
 
#define lua_CTestCall(numArgs)        \
  lua_pushstring(lstate, __FILE__);   \
  lua_pushunsigned(lstate, __LINE__); \
  lua_errorCall((numArgs)+2, 0)

#define StartTestSuite(aDesc)              \
  lua_getglobal(lstate, "startTestSuite"); \
  lua_pushstring(lstate, (aDesc));         \
  lua_CTestCall(1)

#define StopTestSuite                     \
  lua_getglobal(lstate, "stopTestSuite"); \
  lua_CTestCall(0)

#define StartTestCase(aDesc, aFileName, startLine, lastLine) \
  lua_getglobal(lstate, "startTestCase");                    \
  lua_pushstring(lstate, (aDesc));                           \
  lua_pushstring(lstate, (aFileName));                       \
  lua_pushunsigned(lstate, (startLine));                     \
  lua_pushunsigned(lstate, (lastLine));                      \
  lua_CTestCall(4)

#define StopTestCase                     \
  lua_getglobal(lstate, "stopTestCase"); \
  lua_CTestCall(0)

// from file: cTests.tex after line: 300

#define StartAssertShouldFail(messagePattern, reasonPattern, aMessage) \
  lua_getglobal(lstate, "startCShouldFail");                           \
  lua_pushstring(lstate, (messagePattern));                            \
  lua_pushstring(lstate, (reasonPattern));                             \
  lua_pushstring(lstate, (aMessage));                                  \
  lua_CTestCall(3)

#define StopAssertShouldFail                \
  lua_getglobal(lstate, "stopCShouldFail"); \
  lua_CTestCall(0)

// from file: cTests.tex after line: 350

#define AssertFailMsg(aMessage)              \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, FALSE);            \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushstring(lstate, "Failed");          \
  lua_CTestCall(3)
 
#define AssertFail() \
  AssertFailMsg("")

// from file: cTests.tex after line: 350

#define AssertSucceedMsg(aMessage)           \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, TRUE);             \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushstring(lstate, "Succeeded");       \
  lua_CTestCall(3)

#define AssertSucceed() \
  AssertSucceedMsg("")

// from file: cTests.tex after line: 400

#define AssertIntTrueMsg(anInt, aMessage)    \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, (anInt));          \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushfstring(lstate,                    \
      "Expected %d to be TRUE.",             \
      (anInt)                                \
    );                                       \
  lua_CTestCall(3)

#define AssertIntTrue(anInt) \
  AssertIntTrueMsg(anInt, "")

// from file: cTests.tex after line: 400

#define AssertIntFalseMsg(anInt, aMessage)   \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, !(anInt));         \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushfstring(lstate,                    \
      "Expected %d to be FALSE.",            \
      (anInt)                                \
    );                                       \
  lua_CTestCall(3)

#define AssertIntFalse(anInt) \
  AssertIntFalseMsg(anInt, "")

// from file: cTests.tex after line: 450

#define AssertIntEqualsMsg(intA, intB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");     \
  lua_pushboolean(lstate, (intA) == (intB));     \
  lua_pushstring(lstate, (aMessage));            \
  lua_pushfstring(lstate,                        \
      "Expected %d to be equal to %d.",          \
      (intA),                                    \
      (intB)                                     \
    );                                           \
  lua_CTestCall(3)

#define AssertIntEquals(intA, intB) \
  AssertIntEqualsMsg(intA, intB, "")

// from file: cTests.tex after line: 450

#define AssertIntNotEqualsMsg(intA, intB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");        \
  lua_pushboolean(lstate, (intA) != (intB));        \
  lua_pushstring(lstate, (aMessage));               \
  lua_pushfstring(lstate,                           \
      "Expected %d not to be equal to %d.",         \
      (intA),                                       \
      (intB)                                        \
    );                                              \
  lua_CTestCall(3)

#define AssertIntNotEquals(intA, intB) \
  AssertIntNotEqualsMsg(intA, intB, "")

// from file: cTests.tex after line: 450

#define AssertPtrNullMsg(aPtr, aMessage)     \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, (aPtr) == (NULL)); \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushfstring(lstate,                    \
      "Expected %p to be NULL.",             \
      (aPtr)                                 \
    );                                       \
  lua_CTestCall(3)

#define AssertPtrNull(aPtr) \
  AssertPtrNullMsg(aPtr, "")

// from file: cTests.tex after line: 500

#define AssertPtrNotNullMsg(aPtr, aMessage)  \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, (aPtr) != (NULL)); \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushfstring(lstate,                    \
      "Expected %p not to be NULL.",         \
      (aPtr)                                 \
    );                                       \
  lua_CTestCall(3)

#define AssertPtrNotNull(aPtr) \
  AssertPtrNotNullMsg(aPtr, "")

// from file: cTests.tex after line: 500

#define AssertPtrEqualsMsg(ptrA, ptrB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");     \
  lua_pushboolean(lstate, (ptrA) == (ptrB));     \
  lua_pushstring(lstate, (aMessage));            \
  lua_pushfstring(lstate,                        \
      "Expected %p to be equal to %p.",          \
      (ptrA),                                    \
      (ptrB)                                     \
    );                                           \
  lua_CTestCall(3)

#define AssertPtrEquals(ptrA, ptrB) \
  AssertPtrEqualsMsg(ptrA, ptrB, "")

// from file: cTests.tex after line: 550

#define AssertPtrNotEqualsMsg(ptrA, ptrB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");        \
  lua_pushboolean(lstate, (ptrA) != (ptrB));        \
  lua_pushstring(lstate, (aMessage));               \
  lua_pushfstring(lstate,                           \
      "Expected %p not to be equal to %p.",         \
      (ptrA),                                       \
      (ptrB)                                        \
    );                                              \
  lua_CTestCall(3)

#define AssertPtrNotEquals(ptrA, ptrB) \
  AssertPtrNotEqualsMsg(ptrA, ptrB, "")

// from file: cTests.tex after line: 550

#define AssertStrEmptyMsg(aStr, aMessage)    \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, *(aStr) == 0);     \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushfstring(lstate,                    \
      "Expected [%s] to be empty.",          \
      (aStr)                                 \
    );                                       \
  lua_CTestCall(3)

#define AssertStrEmpty(aStr) \
  AssertStrEmptyMsg(aStr, "")

// from file: cTests.tex after line: 550

#define AssertStrNotEmptyMsg(aStr, aMessage) \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, *(aStr) != 0);     \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushfstring(lstate,                    \
      "Expected [%s] not to be empty.",      \
      (aStr)                                 \
    );                                       \
  lua_CTestCall(3)

#define AssertStrNotEmpty(aStr) \
  AssertStrNotEmptyMsg(aStr, "")

// from file: cTests.tex after line: 600

#define AssertStrEqualsMsg(strA, strB, aMessage)        \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, strcmp((strA), (strB)) == 0); \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected [%s] to be equal to [%s].",             \
      (strA),                                           \
      (strB)                                            \
    );                                                  \
  lua_CTestCall(3)

#define AssertStrEquals(strA, strB) \
  AssertStrEqualsMsg(strA, strB, "")

// from file: cTests.tex after line: 600

#define AssertStrNotEqualsMsg(strA, strB, aMessage)     \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, strcmp((strA), (strB)) != 0); \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected [%s] not to be equal to [%s].",         \
      (strA),                                           \
      (strB)                                            \
    );                                                  \
  lua_CTestCall(3)

#define AssertStrNotEquals(strA, strB) \
  AssertStrNotEqualsMsg(strA, strB, "")

// from file: cTests.tex after line: 650

#define AssertStrMatchesMsg(aStr, aPattern, aMessage) \
{                                                     \
  lua_getglobal(lstate, "string");                    \
  lua_getfield(lstate, -1, "match")                   \
  lua_remove(lstate, -2);                             \
  lua_pushstring(lstate, (aStr));                     \
  lua_pushstring(lstate, (aPattern));                 \
  lua_errorCall(2, 1);                                \
  int matched = lua_isnil(lstate, 1);                 \
  lua_pop(lstate, 1);                                 \
  lua_getglobal(lstate, "reportCAssertion");          \
  lua_pushboolean(lstate, matched);                   \
  lua_pushstring(lstate, (aMessage));                 \
  lua_pushfstring(lstate,                             \
      "Expected [%s] to match pattern [%s].",         \
      (aStr),                                         \
      (aPattern)                                      \
    );                                                \
  lua_CTestCall(3);                                   \
}

#define AssertStrMatches(aStr, aPattern) \
  AssertStrMatchesMsg(aStr, aPattern, "")

// from file: cTests.tex after line: 650

#define AssertStrDoesNotMatchMsg(aStr, aPattern, aMessage) \
{                                                          \
  lua_getglobal(lstate, "string");                         \
  lua_getfield(lstate, -1, "match")                        \
  lua_remove(lstate, -2);                                  \
  lua_pushstring(lstate, (aStr));                          \
  lua_pushstring(lstate, (aPattern));                      \
  lua_errorCall(2, 1);                                     \
  int matched = lua_isnil(lstate, 1);                      \
  lua_pop(lstate, 1);                                      \
  lua_getglobal(lstate, "reportCAssertion");               \
  lua_pushboolean(lstate, ! matched);                      \
  lua_pushstring(lstate, (aMessage));                      \
  lua_pushfstring(lstate,                                  \
      "Expected [%s] to not match pattern [%s].",          \
      (aStr),                                              \
      (aPattern)                                           \
    );                                                     \
  lua_CTestCall(3);                                        \
}

#define AssertStrDoesNotMatch(aStr, aPattern) \
  AssertStrDoesNotMatchMsg(aStr, aPattern, "")

// from file: cTests.tex after line: 700

#define AssertDblEqualsMsg(dblA, dblB, tol, aMessage)        \
  lua_getglobal(lstate, "reportCAssertion");                 \
  lua_pushboolean(lstate, fabs((dblA) - (dblB)) < (tol));    \
  lua_pushstring(lstate, (aMessage));                        \
  lua_pushfstring(lstate,                                    \
      "Expected %f to be equal to %f with tolerance of %f.", \
      (dblA),                                                \
      (dblB),                                                \
      (tol)                                                  \
    );                                                       \
  lua_CTestCall(3)

#define AssertDblEquals(dblA, dblB, tol) \
  AssertDblEqualsMsg(dblA, dblB, tol, "")

// from file: cTests.tex after line: 700

#define AssertDblNotEqualsMsg(dblA, dblB, tol, aMessage)         \
  lua_getglobal(lstate, "reportCAssertion");                     \
  lua_pushboolean(lstate, (tol) <= fabs((dblA) - (dblB)));       \
  lua_pushstring(lstate, (aMessage));                            \
  lua_pushfstring(lstate,                                        \
      "Expected %f not to be equal to %f with tolerance of %f.", \
      (dblA),                                                    \
      (dblB),                                                    \
      (tol)                                                      \
    );                                                           \
  lua_CTestCall(3)

#define AssertDblNotEquals(dblA, dblB, tol) \
  AssertDblNotEqualsMsg(dblA, dblB, "")

// end of t-contests.h
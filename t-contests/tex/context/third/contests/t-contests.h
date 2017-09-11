// An ANSI-C header file

// from file: cTests.tex after line: 150

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
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

#define lua_errorCall(numArgs, numRtn)                     \
{                                                          \
  int pResult = lua_pcall(lstate, (numArgs), (numRtn), 0); \
  if (pResult) {                                           \
    fprintf(stderr,                                        \
      "LUA error (%d) in file %s at line %d\n",            \
      pResult, __FILE__, __LINE__                          \
    );                                                     \
    fprintf(stderr, "%s\n", lua_tostring(lstate, -1));     \
    lua_pop(lstate, 1);                                    \
  }                                                        \
}

#define lua_fileCall(numArgs, numRtn)            \
  lua_pushstring(lstate, __FILE__);              \
  lua_pushunsigned(lstate, __LINE__);            \
  lua_errorCall((numArgs)+2, numRtn)

#define StartTestSuite(aDesc)              \
  lua_getglobal(lstate, "startTestSuite"); \
  lua_pushstring(lstate, (aDesc));         \
  lua_fileCall(1, 0)

#define StopTestSuite()                   \
  lua_getglobal(lstate, "stopTestSuite"); \
  lua_fileCall(0, 0)

#define StartTestCase(aDesc, aFileName, startLine, lastLine) \
  lua_getglobal(lstate, "startTestCase");                    \
  lua_pushstring(lstate, (aDesc));                           \
  lua_pushstring(lstate, (aFileName));                       \
  lua_pushunsigned(lstate, (startLine));                     \
  lua_pushunsigned(lstate, (lastLine));                      \
  lua_fileCall(4, 0)

#define StopTestCase()                   \
  lua_getglobal(lstate, "stopTestCase"); \
  lua_fileCall(0, 0)

#define lua_CTestCall(numArgs, shouldStop)       \
  lua_pushstring(lstate, __FILE__);              \
  lua_pushunsigned(lstate, __LINE__);            \
  lua_fileCall((numArgs)+2, 1);                  \
  {                                              \
    int theCondition = lua_toboolean(lstate, 1); \
    lua_pop(lstate, 1);                          \
    if (shouldStop & (!theCondition)) return;    \
  }

// from file: cTests.tex after line: 450

#define StartAssertShouldFail(messagePattern, reasonPattern, aMessage) \
  lua_getglobal(lstate, "startCShouldFail");                           \
  lua_pushstring(lstate, (messagePattern));                            \
  lua_pushstring(lstate, (reasonPattern));                             \
  lua_pushstring(lstate, (aMessage));                                  \
  lua_fileCall(3, 0)

#define StopAssertShouldFail()              \
  lua_getglobal(lstate, "stopCShouldFail"); \
  lua_fileCall(0, 0)

// from file: cTests.tex after line: 500

#define AssertFailMsg(aMessage)              \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, FALSE);            \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushstring(lstate, "Failed");          \
  lua_CTestCall(3, TRUE)
 
#define AssertFail() \
  AssertFailMsg("")

// from file: cTests.tex after line: 550

#define AssertSucceedMsg(aMessage)           \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, TRUE);             \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushstring(lstate, "Succeeded");       \
  lua_CTestCall(3, FALSE)

#define AssertSucceed() \
  AssertSucceedMsg("")

// from file: cTests.tex after line: 550

#define AssertIntTrueMsg(anInt, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");     \
  lua_pushboolean(lstate, (anInt));              \
  lua_pushstring(lstate, (aMessage));            \
  lua_pushfstring(lstate,                        \
      "Expected %d to be TRUE.",                 \
      (anInt)                                    \
    );                                           \
  lua_CTestCall(3, sStop)

#define AssertIntTrueStop(anInt)    \
  AssertIntTrueMsg(anInt, "", TRUE)

#define AssertIntTrue(anInt)         \
  AssertIntTrueMsg(anInt, "", FALSE)

// from file: cTests.tex after line: 600

#define AssertIntFalseMsg(anInt, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");      \
  lua_pushboolean(lstate, !(anInt));              \
  lua_pushstring(lstate, (aMessage));             \
  lua_pushfstring(lstate,                         \
      "Expected %d to be FALSE.",                 \
      (anInt)                                     \
    );                                            \
  lua_CTestCall(3, sStop)

#define AssertIntFalseStop(anInt)    \
  AssertIntFalseMsg(anInt, "", TRUE)

#define AssertIntFalse(anInt)         \
  AssertIntFalseMsg(anInt, "", FALSE)

// from file: cTests.tex after line: 650

#define AssertIntEqualsMsg(intA, intB, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, (intA) == (intB));            \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected %d to be equal to %d.",                 \
      (intA),                                           \
      (intB)                                            \
    );                                                  \
  lua_CTestCall(3, sStop)

#define AssertIntEqualsStop(intA, intB)    \
  AssertIntEqualsMsg(intA, intB, "", TRUE)

#define AssertIntEquals(intA, intB)         \
  AssertIntEqualsMsg(intA, intB, "", FALSE)

// from file: cTests.tex after line: 650

#define AssertIntNotEqualsMsg(intA, intB, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");               \
  lua_pushboolean(lstate, (intA) != (intB));               \
  lua_pushstring(lstate, (aMessage));                      \
  lua_pushfstring(lstate,                                  \
      "Expected %d not to be equal to %d.",                \
      (intA),                                              \
      (intB)                                               \
    );                                                     \
  lua_CTestCall(3, sStop)

#define AssertIntNotEqualsStop(intA, intB)    \
  AssertIntNotEqualsMsg(intA, intB, "", TRUE)

#define AssertIntNotEquals(intA, intB)         \
  AssertIntNotEqualsMsg(intA, intB, "", FALSE)

// from file: cTests.tex after line: 700

#define AssertPtrNullMsg(aPtr, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");    \
  lua_pushboolean(lstate, (aPtr) == (NULL));    \
  lua_pushstring(lstate, (aMessage));           \
  lua_pushfstring(lstate,                       \
      "Expected %p to be NULL.",                \
      (aPtr)                                    \
    );                                          \
  lua_CTestCall(3, sStop)

#define AssertPtrNullStop(aPtr)    \
  AssertPtrNullMsg(aPtr, "", TRUE)

#define AssertPtrNull(aPtr)         \
  AssertPtrNullMsg(aPtr, "", FALSE)

// from file: cTests.tex after line: 750

#define AssertPtrNotNullMsg(aPtr, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");       \
  lua_pushboolean(lstate, (aPtr) != (NULL));       \
  lua_pushstring(lstate, (aMessage));              \
  lua_pushfstring(lstate,                          \
      "Expected %p not to be NULL.",               \
      (aPtr)                                       \
    );                                             \
  lua_CTestCall(3, sStop)

#define AssertPtrNotNull(aPtr)        \
  AssertPtrNotNullMsg(aPtr, "", TRUE)

#define AssertPtrNotNullCont(aPtr)     \
  AssertPtrNotNullMsg(aPtr, "", FALSE)

// from file: cTests.tex after line: 750

#define AssertPtrEqualsMsg(ptrA, ptrB, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, (ptrA) == (ptrB));            \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected %p to be equal to %p.",                 \
      (ptrA),                                           \
      (ptrB)                                            \
    );                                                  \
  lua_CTestCall(3, sStop)

#define AssertPtrEqualsStop(ptrA, ptrB)    \
  AssertPtrEqualsMsg(ptrA, ptrB, "", TRUE)

#define AssertPtrEquals(ptrA, ptrB)         \
  AssertPtrEqualsMsg(ptrA, ptrB, "", FALSE)

// from file: cTests.tex after line: 800

#define AssertPtrNotEqualsMsg(ptrA, ptrB, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");               \
  lua_pushboolean(lstate, (ptrA) != (ptrB));               \
  lua_pushstring(lstate, (aMessage));                      \
  lua_pushfstring(lstate,                                  \
      "Expected %p not to be equal to %p.",                \
      (ptrA),                                              \
      (ptrB)                                               \
    );                                                     \
  lua_CTestCall(3, sStop)

#define AssertPtrNotEqualsStop(ptrA, ptrB)    \
  AssertPtrNotEqualsMsg(ptrA, ptrB, "", TRUE)

#define AssertPtrNotEquals(ptrA, ptrB)         \
  AssertPtrNotEqualsMsg(ptrA, ptrB, "", FALSE)

// from file: cTests.tex after line: 850

#define AssertStrEmptyMsg(aStr, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");     \
  lua_pushboolean(lstate, *(aStr) == 0);         \
  lua_pushstring(lstate, (aMessage));            \
  lua_pushfstring(lstate,                        \
      "Expected [%s] to be empty.",              \
      (aStr)                                     \
    );                                           \
  lua_CTestCall(3, sStop)

#define AssertStrEmptyStop(aStr)    \
  AssertStrEmptyMsg(aStr, "", TRUE)
#define AssertStrEmpty(aStr)         \
  AssertStrEmptyMsg(aStr, "", FALSE)

// from file: cTests.tex after line: 900

#define AssertStrNotEmptyMsg(aStr, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");        \
  lua_pushboolean(lstate, *(aStr) != 0);            \
  lua_pushstring(lstate, (aMessage));               \
  lua_pushfstring(lstate,                           \
      "Expected [%s] not to be empty.",             \
      (aStr)                                        \
    );                                              \
  lua_CTestCall(3, sStop)

#define AssertStrNotEmptyStop(aStr)    \
  AssertStrNotEmptyMsg(aStr, "", TRUE)
 
#define AssertStrNotEmpty(aStr)         \
  AssertStrNotEmptyMsg(aStr, "", FALSE)

// from file: cTests.tex after line: 900

#define AssertStrEqualsMsg(strA, strB, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, strcmp((strA), (strB)) == 0); \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected [%s] to be equal to [%s].",             \
      (strA),                                           \
      (strB)                                            \
    );                                                  \
  lua_CTestCall(3, sStop)

#define AssertStrEqualsStop(strA, strB)    \
  AssertStrEqualsMsg(strA, strB, "", TRUE)
 
#define AssertStrEquals(strA, strB)         \
  AssertStrEqualsMsg(strA, strB, "", FALSE)

// from file: cTests.tex after line: 950

#define AssertStrNotEqualsMsg(strA, strB, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");               \
  lua_pushboolean(lstate, strcmp((strA), (strB)) != 0);    \
  lua_pushstring(lstate, (aMessage));                      \
  lua_pushfstring(lstate,                                  \
      "Expected [%s] not to be equal to [%s].",            \
      (strA),                                              \
      (strB)                                               \
    );                                                     \
  lua_CTestCall(3, sStop)

#define AssertStrNotEqualsStop(strA, strB)    \
  AssertStrNotEqualsMsg(strA, strB, "", TRUE)
 
#define AssertStrNotEquals(strA, strB)         \
  AssertStrNotEqualsMsg(strA, strB, "", FALSE)

// from file: cTests.tex after line: 1000

#define AssertStrMatchesMsg(aStr, aPattern, aMessage, sStop) \
{                                                            \
  lua_getglobal(lstate, "string");                           \
  lua_getfield(lstate, -1, "match");                         \
  lua_remove(lstate, -2);                                    \
  lua_pushstring(lstate, (aStr));                            \
  lua_pushstring(lstate, (aPattern));                        \
  lua_errorCall(2, 1);                                       \
  int matched = !lua_isnil(lstate, -1);                      \
  lua_pop(lstate, 1);                                        \
  lua_getglobal(lstate, "reportCAssertion");                 \
  lua_pushboolean(lstate, matched);                          \
  lua_pushstring(lstate, (aMessage));                        \
  lua_pushfstring(lstate,                                    \
      "Expected [%s] to match pattern [%s].",                \
      (aStr),                                                \
      (aPattern)                                             \
    );                                                       \
  lua_CTestCall(3, sStop);                                   \
}

#define AssertStrMatchesStop(aStr, aPattern)    \
  AssertStrMatchesMsg(aStr, aPattern, "", TRUE)

#define AssertStrMatches(aStr, aPattern)         \
  AssertStrMatchesMsg(aStr, aPattern, "", FALSE)

// from file: cTests.tex after line: 1050

#define AssertStrDoesNotMatchMsg(aStr, aPattern, aMessage, sStop) \
{                                                                 \
  lua_getglobal(lstate, "string");                                \
  lua_getfield(lstate, -1, "match");                              \
  lua_remove(lstate, -2);                                         \
  lua_pushstring(lstate, (aStr));                                 \
  lua_pushstring(lstate, (aPattern));                             \
  lua_errorCall(2, 1);                                            \
  int matched = !lua_isnil(lstate, -1);                           \
  lua_pop(lstate, 1);                                             \
  lua_getglobal(lstate, "reportCAssertion");                      \
  lua_pushboolean(lstate, !matched);                              \
  lua_pushstring(lstate, (aMessage));                             \
  lua_pushfstring(lstate,                                         \
      "Expected [%s] to not match pattern [%s].",                 \
      (aStr),                                                     \
      (aPattern)                                                  \
    );                                                            \
  lua_CTestCall(3, sStop);                                        \
}

#define AssertStrDoesNotMatchStop(aStr, aPattern)    \
  AssertStrDoesNotMatchMsg(aStr, aPattern, "", TRUE)
 
#define AssertStrDoesNotMatch(aStr, aPattern)         \
  AssertStrDoesNotMatchMsg(aStr, aPattern, "", FALSE)

// from file: cTests.tex after line: 1100

#define AssertDblEqualsMsg(dblA, dblB, tol, aMessage, sStop) \
  lua_getglobal(lstate, "reportCAssertion");                 \
  lua_pushboolean(lstate, fabs((dblA) - (dblB)) < (tol));    \
  lua_pushstring(lstate, (aMessage));                        \
  lua_pushfstring(lstate,                                    \
      "Expected %f to be equal to %f with tolerance of %f.", \
      (dblA),                                                \
      (dblB),                                                \
      (tol)                                                  \
    );                                                       \
  lua_CTestCall(3, sStop)

#define AssertDblEqualsStop(dblA, dblB, tol)    \
  AssertDblEqualsMsg(dblA, dblB, tol, "", TRUE)

#define AssertDblEquals(dblA, dblB, tol)         \
  AssertDblEqualsMsg(dblA, dblB, tol, "", FALSE)

// from file: cTests.tex after line: 1150

#define AssertDblNotEqualsMsg(dblA, dblB, tol, aMessage, sStop)  \
  lua_getglobal(lstate, "reportCAssertion");                     \
  lua_pushboolean(lstate, (tol) <= fabs((dblA) - (dblB)));       \
  lua_pushstring(lstate, (aMessage));                            \
  lua_pushfstring(lstate,                                        \
      "Expected %f not to be equal to %f with tolerance of %f.", \
      (dblA),                                                    \
      (dblB),                                                    \
      (tol)                                                      \
    );                                                           \
  lua_CTestCall(3, sStop)

#define AssertDblNotEqualsStop(dblA, dblB, tol) \
  AssertDblNotEqualsMsg(dblA, dblB, tol, "", TRUE)

#define AssertDblNotEquals(dblA, dblB, tol)    \
  AssertDblNotEqualsMsg(dblA, dblB, tol, "", FALSE)

// end of t-contests.h
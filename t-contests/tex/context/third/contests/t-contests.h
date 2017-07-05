// An ANSI-C header file

// from file: cTests.tex after line: 100

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

typedef struct TestCase_struc TestCase;

typedef void (*TestCaseFunc)(TestCase*);

struct TestCase_struc {
  char*         desc;
  TestCaseFunc  testCaseFunc;
  int           failed;
  const char*   message;
  const char*   reason;
  jmp_buf      *jumpBuf;
};

extern void TestCaseRun(TestCase *tc);

#define lua_errorCall(numArgs, numRtn)        \
  if lua_pcall(lstate, (numArgs), (numRtn)) { \
    fprintf(stderr,                           \
      "LUA error in file %s at line %d\n",    \
      __FILE__, __LINE__                      \
    )                                         \
  }
 
#define lua_CTestCall(numArgs)        \
  lua_pushstring(lstate, __FILE__);   \
  lua_pushunsigned(lstate, __LINE__); \
  lua_errorCall((numArgs)+2)

#define StartTestSuite(aDesc)              \
  lua_getglobal(lstate, "startTestSuite"); \
  lua_pushstring(lstate, (aDesc));         \
  lua_CTestCall(1)

#define StopTestSuite                     \
  lua_getglobal(lstate, "stopTestSuite"); \
  lua_CTestCall(0)

#define StartTestCase(aDesc)              \
  lua_getglobal(lstate, "startTestCase"); \
  lua_pushstring(lstate, (aDesc));        \
  lua_CTestCall(1)

#define StopTestCase                     \
  lua_getglobal(lstate, "stopTestCase"); \
  lua_CTestCall(0)

// from file: cTests.tex after line: 150

#define StartAssertShouldFail(messagePattern, reasonPattern, aMessage) \
  lua_getglobal(lstate, "startCShouldFail");                           \
  lua_pushstring(lstate, (messagePattern));                            \
  lua_pushstring(lstate, (reasonPattern));                             \
  lua_pushstring(lstate, (aMessage));                                  \
  lua_CTestCall(3)

#define StopAssertShouldFail                \
  lua_getglobal(lstate, "stopCShouldFail"); \
  lua_CTestCall(0)

// from file: cTests.tex after line: 200

#define AssertFailMsg(tc, aMessage)          \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, FALSE);            \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushstring(lstate, "Failed");          \
  lua_CTestCall(3)
 
#define AssertFail(tc) \
  AssertFailMsg(tc, "")

// from file: cTests.tex after line: 200

#define AssertSucceedMsg(tc, aMessage)       \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, TRUE);             \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushstring(lstate, "Succeeded");       \
  lua_CTestCall(3)

#define AssertSucceed(tc) \
  AssertSucceedMsg(tc, "")

// from file: cTests.tex after line: 200

#define AssertIntTrueMsg(tc, anInt, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");  \
  lua_pushboolean(lstate, (anInt));           \
  lua_pushstring(lstate, (aMessage));         \
  lua_pushfstring(lstate,                     \
      "Expected %d to be TRUE.",              \
      (anInt)                                 \
    );                                        \
  lua_CTestCall(3)

#define AssertIntTrue(tc, anInt) \
  AssertIntTrueMsg(tc, anInt, "")

// from file: cTests.tex after line: 250

#define AssertIntFalseMsg(tc, anInt, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");   \
  lua_pushboolean(lstate, !(anInt));           \
  lua_pushstring(lstate, (aMessage));          \
  lua_pushfstring(lstate,                      \
      "Expected %d to be FALSE.",              \
      (anInt)                                  \
    );                                         \
  lua_CTestCall(3)

#define AssertIntFalse(tc, anInt) \
  AssertIntFalseMsg(tc, anInt, "")

// from file: cTests.tex after line: 250

#define AssertIntEqualsMsg(tc, intA, intB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");         \
  lua_pushboolean(lstate, (intA) == (intB));         \
  lua_pushstring(lstate, (aMessage));                \
  lua_pushfstring(lstate,                            \
      "Expected %d to be equal to %d.",              \
      (intA),                                        \
      (intB)                                         \
    );                                               \
  lua_CTestCall(3)

#define AssertIntEquals(tc, intA, intB) \
  AssertIntEqualsMsg(tc, intA, intB, "")

// from file: cTests.tex after line: 300

#define AssertIntNotEqualsMsg(tc, intA, intB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, (intA) != (intB));            \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected %d not to be equal to %d.",             \
      (intA),                                           \
      (intB)                                            \
    );                                                  \
  lua_CTestCall(3)

#define AssertIntNotEquals(tc, intA, intB) \
  AssertIntNotEqualsMsg(tc, intA, intB, "")

// from file: cTests.tex after line: 300

#define AssertPtrNullMsg(tc, aPtr, aMessage) \
  lua_getglobal(lstate, "reportCAssertion"); \
  lua_pushboolean(lstate, (aPtr) == (NULL)); \
  lua_pushstring(lstate, (aMessage));        \
  lua_pushfstring(lstate,                    \
      "Expected %p to be NULL.",             \
      (aPtr)                                 \
    );                                       \
  lua_CTestCall(3)

#define AssertPtrNull(tc, aPtr) \
  AssertPtrNullMsg(tc, aPtr, "")

// from file: cTests.tex after line: 300

#define AssertPtrNotNullMsg(tc, aPtr, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");    \
  lua_pushboolean(lstate, (aPtr) != (NULL));    \
  lua_pushstring(lstate, (aMessage));           \
  lua_pushfstring(lstate,                       \
      "Expected %p not to be NULL.",            \
      (aPtr)                                    \
    );                                          \
  lua_CTestCall(3)

#define AssertPtrNotNull(tc, aPtr) \
  AssertPtrNotNullMsg(tc, aPtr, "")

// from file: cTests.tex after line: 350

#define AssertPtrEqualsMsg(tc, ptrA, ptrB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");         \
  lua_pushboolean(lstate, (ptrA) == (ptrB));         \
  lua_pushstring(lstate, (aMessage));                \
  lua_pushfstring(lstate,                            \
      "Expected %p to be equal to %p.",              \
      (ptrA),                                        \
      (ptrB)                                         \
    );                                               \
  lua_CTestCall(3)

#define AssertPtrEquals(tc, ptrA, ptrB) \
  AssertPtrEqualsMsg(tc, ptrA, ptrB, "")

// from file: cTests.tex after line: 350

#define AssertPtrNotEqualsMsg(tc, ptrA, ptrB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, (ptrA) != (ptrB));            \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected %p not to be equal to %p.",             \
      (ptrA),                                           \
      (ptrB)                                            \
    );                                                  \
  lua_CTestCall(3)

#define AssertPtrNotEquals(tc, ptrA, ptrB) \
  AssertPtrNotEqualsMsg(tc, ptrA, ptrB, "")

// from file: cTests.tex after line: 400

#define AssertStrEmptyMsg(tc, aStr, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");  \
  lua_pushboolean(lstate, *(aStr) == 0);      \
  lua_pushstring(lstate, (aMessage));         \
  lua_pushfstring(lstate,                     \
      "Expected [%s] to be empty.",           \
      (aStr)                                  \
    );                                        \
  lua_CTestCall(3)

#define AssertStrEmpty(tc, aStr) \
  AssertStrEmptyMsg(tc, aStr, "")

// from file: cTests.tex after line: 400

#define AssertStrNotEmptyMsg(tc, aStr, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");     \
  lua_pushboolean(lstate, *(aStr) != 0);         \
  lua_pushstring(lstate, (aMessage));            \
  lua_pushfstring(lstate,                        \
      "Expected [%s] not to be empty.",          \
      (aStr)                                     \
    );                                           \
  lua_CTestCall(3)

#define AssertStrNotEmpty(tc, aStr) \
  AssertStrNotEmptyMsg(tc, aStr, "")

// from file: cTests.tex after line: 400

#define AssertStrEqualsMsg(tc, strA, strB, aMessage)    \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, strcmp((strA), (strB)) == 0); \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected [%s] to be equal to [%s].",             \
      (strA),                                           \
      (strB)                                            \
    );                                                  \
  lua_CTestCall(3)

#define AssertStrEquals(tc, strA, strB) \
  AssertStrEqualsMsg(tc, strA, strB, "")

// from file: cTests.tex after line: 450

#define AssertStrNotEqualsMsg(tc, strA, strB, aMessage) \
  lua_getglobal(lstate, "reportCAssertion");            \
  lua_pushboolean(lstate, strcmp((strA), (strB)) != 0); \
  lua_pushstring(lstate, (aMessage));                   \
  lua_pushfstring(lstate,                               \
      "Expected [%s] not to be equal to [%s].",         \
      (strA),                                           \
      (strB)                                            \
    );                                                  \
  lua_CTestCall(3)

#define AssertStrNotEquals(tc, strA, strB) \
  AssertStrNotEqualsMsg(tc, strA, strB, "")

// from file: cTests.tex after line: 450

#define AssertStrMatchesMsg(tc, aStr, aPattern, aMessage) \
{                                                         \
  lua_getglobal(lstate, "string");                        \
  lua_getfield(lstate, -1, "match")                       \
  lua_remove(lstate, -2);                                 \
  lua_pushstring(lstate, (aStr));                         \
  lua_pushstring(lstate, (aPattern));                     \
  lua_errorCall(2, 1);                                    \
  int matched = lua_isnil(lstate, 1);                     \
  lua_pop(lstate, 1);                                     \
  lua_getglobal(lstate, "reportCAssertion");              \
  lua_pushboolean(lstate, matched);                       \
  lua_pushstring(lstate, (aMessage));                     \
  lua_pushfstring(lstate,                                 \
      "Expected [%s] to match pattern [%s].",             \
      (aStr),                                             \
      (aPattern)                                          \
    );                                                    \
  lua_CTestCall(3);                                       \
}

#define AssertStrMatches(tc, strA, strB) \
  AssertStrMatchesMsg(tc, strA, strB, "")

// from file: cTests.tex after line: 500

#define AssertStrNotMatchMsg(tc, strA, strB, aMessage) \
{                                                      \
  lua_getglobal(lstate, "string");                     \
  lua_getfield(lstate, -1, "match")                    \
  lua_remove(lstate, -2);                              \
  lua_pushstring(lstate, (aStr));                      \
  lua_pushstring(lstate, (aPattern));                  \
  lua_errorCall(2, 1);                                 \
  int matched = lua_isnil(lstate, 1);                  \
  lua_pop(lstate, 1);                                  \
  lua_getglobal(lstate, "reportCAssertion");           \
  lua_pushboolean(lstate, ! matched);                  \
  lua_pushstring(lstate, (aMessage));                  \
  lua_pushfstring(lstate,                              \
      "Expected [%s] to not match pattern [%s].",      \
      (aStr),                                          \
      (aPattern)                                       \
    );                                                 \
  lua_CTestCall(3);                                    \
}

#define AssertStrNotEquals(tc, strA, strB) \
  AssertStrNotEqualsMsg(tc, strA, strB, "")

// from file: cTests.tex after line: 500

#define AssertDblEqualsMsg(tc, dblA, dblB, tol, aMessage)    \
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

#define AssertDblEquals(tc, dblA, dblB) \
  AssertDblEqualsMsg(tc, dblA, dblB, "")

// from file: cTests.tex after line: 550

#define AssertDblNotEqualsMsg(tc, dblA, dblB, tol, aMessage)     \
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

#define AssertDblNotEquals(tc, dblA, dblB) \
  AssertDblNotEqualsMsg(tc, dblA, dblB, "")
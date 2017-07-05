// from file: cTests.tex after line: 0

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

extern void ReportCAssert(TestCase *tc,
                          int theCondition,
                          const char* aMessage,
                          const char* theReson,
                          const char* fileName,
                          int lineNum);

// from file: cTests.tex after line: 100

#define AssertFailMsg(tc, aMessage) \
  ReportCAssert(                    \
    (tc),                           \
    FALSE,                          \
    (aMessage),                     \
    "Assert Failed",                \
    __FILE__,                       \
    __LINE__)

#define AssertFail(tc) \
  AssertFailMsg(tc, "")

// from file: cTests.tex after line: 100

#define AssertSucceedMsg(tc, aMessage) \
  ReportCAssert(                       \
    (tc),                              \
    TRUE,                              \
    (aMessage),                        \
    "Assert Succeeded",                \
    __FILE__,                          \
    __LINE__)

#define AssertSucceed(tc) \
  AssertSucceedMsg(tc, "")

// from file: cTests.tex after line: 100

#define AssertIntTrueMsg(tc, anInt, aMessage) \
  ReportCAssert(                              \
    (tc),                                     \
    (anInt),                                  \
    (aMessage),                               \
    sprintf("Expected %d to be TRUE.",        \
      (anInt)                                 \
    ),                                        \
    __FILE__,                                 \
    __LINE__)

#define AssertIntTrue(tc, anInt) \
  AssertIntTrueMsg(tc, anInt, "")

// from file: cTests.tex after line: 150

#define AssertIntFalseMsg(tc, anInt, aMessage) \
  ReportCAssert(                               \
    (tc),                                      \
    !(anInt),                                  \
    (aMessage),                                \
    sprintf("Expected %d to be FALSE.",        \
      (anInt)                                  \
    ),                                         \
    __FILE__,                                  \
    __LINE__)

#define AssertIntFalse(tc, anInt) \
  AssertIntFalseMsg(tc, anInt, "")

// from file: cTests.tex after line: 150

#define AssertIntEqualsMsg(tc, intA, intB, aMessage) \
  ReportCAssert(                                     \
    (tc),                                            \
    (intA) == (intB),                                \
    (aMessage),                                      \
    sprintf("Expected %d to be equal to %d.",        \
      (intA),                                        \
      (intB)                                         \
    ),                                               \
    __FILE__,                                        \
    __LINE__)

#define AssertIntEquals(tc, intA, intB) \
  AssertIntEqualsMsg(tc, intA, intB, "")

// from file: cTests.tex after line: 200

#define AssertIntNotEqualsMsg(tc, intA, intB, aMessage) \
  ReportCAssert(                                        \
    (tc),                                               \
    (intA) != (intB),                                   \
    (aMessage),                                         \
    sprintf("Expected %d not to be equal to %d.",       \
      (intA),                                           \
      (intB)                                            \
    ),                                                  \
    __FILE__,                                           \
    __LINE__)

#define AssertIntNotEquals(tc, intA, intB) \
  AssertIntNotEqualsMsg(tc, intA, intB, "")

// from file: cTests.tex after line: 200

#define AssertPtrNullMsg(tc, aPtr, aMessage) \
  ReportCAssert(                             \
    (tc),                                    \
    (aPtr) == (NULL),                        \
    (aMessage),                              \
    sprintf("Expected %p to be NULL.",       \
      (aPtr),                                \
    ),                                       \
    __FILE__,                                \
    __LINE__)

#define AssertPtrNull(tc, aPtr) \
  AssertPtrNullMsg(tc, aPtr, "")

// from file: cTests.tex after line: 200

#define AssertPtrNotNullMsg(tc, aPtr, aMessage) \
  ReportCAssert(                                \
    (tc),                                       \
    (aPtr) != (NULL),                           \
    (aMessage),                                 \
    sprintf("Expected %p not to be NULL.",      \
      (aPtr),                                   \
    ),                                          \
    __FILE__,                                   \
    __LINE__)

#define AssertPtrNotNull(tc, aPtr) \
  AssertPtrNotNullMsg(tc, aPtr, "")

// from file: cTests.tex after line: 250

#define AssertPtrEqualsMsg(tc, ptrA, ptrB, aMessage) \
  ReportCAssert(                                     \
    (tc),                                            \
    (ptrA) == (ptrB),                                \
    (aMessage),                                      \
    sprintf("Expected %p to be equal to %p.",        \
      (ptrA),                                        \
      (ptrB)                                         \
    ),                                               \
    __FILE__,                                        \
    __LINE__)

#define AssertPtrEquals(tc, ptrA, ptrB) \
  AssertPtrEqualsMsg(tc, ptrA, ptrB, "")

// from file: cTests.tex after line: 250

#define AssertPtrNotEqualsMsg(tc, ptrA, ptrB, aMessage) \
  ReportCAssert(                                        \
    (tc),                                               \
    (ptrA) != (ptrB),                                   \
    (aMessage),                                         \
    sprintf("Expected %p not to be equal to %p.",       \
      (ptrA),                                           \
      (ptrB)                                            \
    ),                                                  \
    __FILE__,                                           \
    __LINE__)

#define AssertPtrNotEquals(tc, ptrA, ptrB) \
  AssertPtrNotEqualsMsg(tc, ptrA, ptrB, "")

// from file: cTests.tex after line: 300

#define AssertStrEmptyMsg(tc, aStr, aMessage) \
  ReportCAssert(                              \
    (tc),                                     \
    *(aStr) == 0,                             \
    (aMessage),                               \
    sprintf("Expected [%s] to be empty.",     \
      (aStr),                                 \
    ),                                        \
    __FILE__,                                 \
    __LINE__)

#define AssertStrEmpty(tc, aStr) \
  AssertStrEmptyMsg(tc, aStr, "")

// from file: cTests.tex after line: 300

#define AssertStrNotEmptyMsg(tc, aStr, aMessage) \
  ReportCAssert(                                 \
    (tc),                                        \
    *(aStr) != 0,                                \
    (aMessage),                                  \
    sprintf("Expected [%s] not to be empty.",    \
      (aStr),                                    \
    ),                                           \
    __FILE__,                                    \
    __LINE__)

#define AssertStrNotEmpty(tc, aStr) \
  AssertStrNotEmptyMsg(tc, aStr, "")

// from file: cTests.tex after line: 300

#define AssertStrEqualsMsg(tc, strA, strB, aMessage) \
  ReportCAssert(                                     \
    (tc),                                            \
    strcmp((strA), (strB)) == 0,                     \
    (aMessage),                                      \
    sprintf("Expected [%s] to be equal to [%s].",    \
      (strA),                                        \
      (strB)                                         \
    ),                                               \
    __FILE__,                                        \
    __LINE__)

#define AssertStrEquals(tc, strA, strB) \
  AssertStrEqualsMsg(tc, strA, strB, "")

// from file: cTests.tex after line: 350

#define AssertStrNotEqualsMsg(tc, strA, strB, aMessage) \
  ReportCAssert(                                        \
    (tc),                                               \
    strcmp((strA), (strB)) != 0,                        \
    (aMessage),                                         \
    sprintf("Expected [%s] not to be equal to [%s].",   \
      (strA),                                           \
      (strB)                                            \
    ),                                                  \
    __FILE__,                                           \
    __LINE__)

#define AssertStrNotEquals(tc, strA, strB) \
  AssertStrNotEqualsMsg(tc, strA, strB, "")

// from file: cTests.tex after line: 350

#define AssertDblEqualsMsg(tc, dblA, dblB, tol, aMessage)     \
  ReportCAssert(                                              \
    (tc),                                                     \
    fabs((dblA) - (dblB)) < (tol),                            \
    (aMessage),                                               \
    sprintf(                                                  \
      "Expected %e to be equal to %e with tollerance of %e.", \
      (dblA),                                                 \
      (dblB)                                                  \
    ),                                                        \
    __FILE__,                                                 \
    __LINE__)

#define AssertDblEquals(tc, dblA, dblB) \
  AssertDblEqualsMsg(tc, dblA, dblB, "")

// from file: cTests.tex after line: 400

#define AssertDblNotEqualsMsg(tc, dblA, dblB, tol, aMessage)      \
  ReportCAssert(                                                  \
    (tc),                                                         \
    (tol) <= fabs((dblA) - (dblB)),                               \
    (aMessage),                                                   \
    sprintf(                                                      \
      "Expected %e not to be equal to %e with tollerance of %e.", \
      (dblA),                                                     \
      (dblB)                                                      \
    ),                                                            \
    __FILE__,                                                     \
    __LINE__)

#define AssertDblNotEquals(tc, dblA, dblB) \
  AssertDblNotEqualsMsg(tc, dblA, dblB, "")
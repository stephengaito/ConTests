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

#define AssertFail(tc, aMessage)  \
  ReportCAssert(                  \
    (tc),                         \
    FALSE,                        \
    (aMessage),                   \
    "Assert Failed",              \
    __FILE__,                     \
    __LINE__)

// from file: cTests.tex after line: 100

#define AssertSucceed(tc, aMessage)  \
  ReportCAssert(                     \
    (tc),                            \
    TRUE,                            \
    (aMessage),                      \
    "Assert Succeeded",              \
    __FILE__,                        \
    __LINE__)

// from file: cTests.tex after line: 100

#define AssertIntTrue(tc, anInt, aMessage)  \
  ReportCAssert(                            \
    (tc),                                   \
    (anInt),                                \
    (aMessage),                             \
    sprintf("Expected %d to be TRUE.",      \
      (anInt)                               \
    ),                                      \
    __FILE__,                               \
    __LINE__)

// from file: cTests.tex after line: 150

#define AssertIntFalse(tc, anInt, aMessage)  \
  ReportCAssert(                             \
    (tc),                                    \
    !(anInt),                                \
    (aMessage),                              \
    sprintf("Expected %d to be FALSE.",      \
      (anInt)                                \
    ),                                       \
    __FILE__,                                \
    __LINE__)

// from file: cTests.tex after line: 150

#define AssertIntEquals(tc, intA, intB, aMessage)  \
  ReportCAssert(                                   \
    (tc),                                          \
    (intA) == (intB),                              \
    (aMessage),                                    \
    sprintf("Expected %d to be equal to %d.",      \
      (intA),                                      \
      (intB)                                       \
    ),                                             \
    __FILE__,                                      \
    __LINE__)

// from file: cTests.tex after line: 150

#define AssertIntNotEquals(tc, intA, intB, aMessage)  \
  ReportCAssert(                                      \
    (tc),                                             \
    (intA) != (intB),                                 \
    (aMessage),                                       \
    sprintf("Expected %d not to be equal to %d.",     \
      (intA),                                         \
      (intB)                                          \
    ),                                                \
    __FILE__,                                         \
    __LINE__)

// from file: cTests.tex after line: 200

#define AssertPtrNull(tc, aPtr, aMessage)  \
  ReportCAssert(                           \
    (tc),                                  \
    (aPtr) == (NULL),                      \
    (aMessage),                            \
    sprintf("Expected %p to be NULL.",     \
      (aPtr),                              \
    ),                                     \
    __FILE__,                              \
    __LINE__)

// from file: cTests.tex after line: 200

#define AssertPtrNotNull(tc, aPtr, aMessage)  \
  ReportCAssert(                              \
    (tc),                                     \
    (aPtr) != (NULL),                         \
    (aMessage),                               \
    sprintf("Expected %p not to be NULL.",    \
      (aPtr),                                 \
    ),                                        \
    __FILE__,                                 \
    __LINE__)

// from file: cTests.tex after line: 200

#define AssertPtrEquals(tc, ptrA, ptrB, aMessage)  \
  ReportCAssert(                                   \
    (tc),                                          \
    (ptrA) == (ptrB),                              \
    (aMessage),                                    \
    sprintf("Expected %p to be equal to %p.",      \
      (ptrA),                                      \
      (ptrB)                                       \
    ),                                             \
    __FILE__,                                      \
    __LINE__)

// from file: cTests.tex after line: 250

#define AssertPtrNotEquals(tc, ptrA, ptrB, aMessage)  \
  ReportCAssert(                                      \
    (tc),                                             \
    (ptrA) != (ptrB),                                 \
    (aMessage),                                       \
    sprintf("Expected %p not to be equal to %p.",     \
      (ptrA),                                         \
      (ptrB)                                          \
    ),                                                \
    __FILE__,                                         \
    __LINE__)

// from file: cTests.tex after line: 250

#define AssertStrEmpty(tc, aStr, aMessage)  \
  ReportCAssert(                            \
    (tc),                                   \
    *(aStr) == 0,                           \
    (aMessage),                             \
    sprintf("Expected [%s] to be empty.",   \
      (aStr),                               \
    ),                                      \
    __FILE__,                               \
    __LINE__)

// from file: cTests.tex after line: 250

#define AssertStrNotEmpty(tc, aStr, aMessage)  \
  ReportCAssert(                               \
    (tc),                                      \
    *(aStr) != 0,                              \
    (aMessage),                                \
    sprintf("Expected [%s] not to be empty.",  \
      (aStr),                                  \
    ),                                         \
    __FILE__,                                  \
    __LINE__)

// from file: cTests.tex after line: 300

#define AssertStrEquals(tc, strA, strB, aMessage)  \
  ReportCAssert(                                   \
    (tc),                                          \
    strcmp((strA), (strB)) == 0,                   \
    (aMessage),                                    \
    sprintf("Expected [%s] to be equal to [%s].",  \
      (strA),                                      \
      (strB)                                       \
    ),                                             \
    __FILE__,                                      \
    __LINE__)

// from file: cTests.tex after line: 300

#define AssertStrNotEquals(tc, strA, strB, aMessage)  \
  ReportCAssert(                                      \
    (tc),                                             \
    strcmp((strA), (strB)) != 0,                      \
    (aMessage),                                       \
    sprintf("Expected [%s] not to be equal to [%s].", \
      (strA),                                         \
      (strB)                                          \
    ),                                                \
    __FILE__,                                         \
    __LINE__)

// from file: cTests.tex after line: 300

#define AssertDblEquals(tc, dblA, dblB, tol, aMessage)        \
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

// from file: cTests.tex after line: 350

#define AssertDblNotEquals(tc, dblA, dblB, tol, aMessage)         \
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
// An ANSI-C code file

// from file: cTests.tex after line: 50

void TestCaseRun(TestCase *tc) {
  tc->attempted = 0;
  tc->passed    = 0;
  tc->failed    = FALSE;
  jmp_buf jumpBuf;
  tc->jumpBuf = &jumpBuf;
  (tc->testCaseFunc)(tc);
  tc->jumpBuf = 0;
}

void ReportCAssert(TestCase *tc,
                   int theCondition,
                   const char* aMessage,
                   const char* theReason,
                   const char* fileName,
                   int lineNum) {
  tc->attempted++;
  if ! theCondition {
    tc->message  = aMessage;
    tc->reason   = theReason;
    tc->fileName = fileName;
    tc->lineNum  = lineNum;
    tc->failed   = TRUE;
    // Now do a long jump back to the TestCaseFunc
    //
    if (tc->jumpBuf) longjump(*(tc->jumpBuf), 0);
  }
  tc->passed++;
}

#define getBuffer(bufferSize) (char*)calloc(1, bufferSize)

char* sprintf2Int(const char* fmt,
                  int intA, int intB) {
  size_t bufferSize = strlen(fmt) + 20*2;
  char* buffer = getBuffer(bufferSize);
  snprintf(buffer, bufferSize, fmt, intA, intB);
  return buffer;
}

char* sprintf2Ptr(const char* fmt,
                  void* ptrA, void* ptrB) {
  size_t bufferSize = strlen(fmt) + 20*2;
  char* buffer = getBuffer(bufferSize);
  snprintf(buffer, bufferSize, fmt, ptrA, ptrB);
  return buffer;

char* sprintf2Str(const char* fmt,
                  const char* strA,
                  const char* strB) {
  size_t bufferSize = strlen(fmt)
    + strlen(strA) + strlen(strB) + 10;
  char* buffer = getBuffer(bufferSize);
  snprintf(buffer, bufferSize, fmt, strA, strB);
  return buffer;
}

char* sprintf2Dbl(const char* fmt,
                  double dblA, double dblB) {
  size_t bufferSize = strlen(fmt) + 20*2;
  char* buffer = getBuffer(bufferSize);
  snprintf(buffer, bufferSize, fmt, dblA, dblB);
  return buffer;
}
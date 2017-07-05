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
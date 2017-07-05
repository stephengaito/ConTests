// An ANSI-C code file

// from file: cTests.tex after line: 150

void TestCaseRun(TestCase *tc) {
  tc->attempted = 0;
  tc->passed    = 0;
  tc->failed    = FALSE;
  jmp_buf jumpBuf;
  tc->jumpBuf = &jumpBuf;
  (tc->testCaseFunc)(tc);
  tc->jumpBuf = 0;
}
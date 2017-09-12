// A CTests file

#include <t-contests.h>


//-------------------------------------------------------


//-------------------------------------------------------
void ts62_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if an inner assertion fails",
    "cTests.tex",
    537,
    544
  );

  StartAssertShouldFail("Inner message", "Failed","Outer message");
    AssertFailMsg("Inner message");
  StopAssertShouldFail();

  StopTestCase();

}

void ts62_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if an inner assertion does not fail",
    "cTests.tex",
    546,
    556
  );

  StartAssertShouldFail(
    "Inner message","Expected inner","Outer message");
    StartAssertShouldFail("","","Inner message");
      AssertSucceedMsg("no flies on us.");
    StopAssertShouldFail();
  StopAssertShouldFail();

  StopTestCase();

}

void ts62_tc3(lua_State *lstate){

  StartTestCase(
    "should fail if inner assertion fails with wrong message or reason",
    "cTests.tex",
    558,
    573
  );

  StartAssertShouldFail("First outer message","","First outermost message");
  StartAssertShouldFail("wrong","","First outer message");
    AssertFailMsg("First inner message");
  StopAssertShouldFail();
  StopAssertShouldFail();
  StartAssertShouldFail("Second outer message","","Second outermost message");
  StartAssertShouldFail("","wrong","Second outer message");
    AssertFailMsg("Second inner message");
  StopAssertShouldFail();
  StopAssertShouldFail();

  StopTestCase();

}

void ts62(lua_State *lstate){

  StartTestSuite(
    "assertShouldFail environment"
  );

  ts62_tc1(lstate);
  ts62_tc2(lstate);
  ts62_tc3(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts63_tc1(lua_State *lstate){

  StartTestCase(
    "assertFail should always fail",
    "cTests.tex",
    591,
    599
  );

  StartAssertShouldFail(".*", ".*", "outerMessage");
    AssertFail();
  StopAssertShouldFail();

  StopTestCase();

}

void ts63(lua_State *lstate){

  StartTestSuite(
    "assertFail"
  );

  ts63_tc1(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts64_tc1(lua_State *lstate){

  StartTestCase(
    "should always succeed",
    "cTests.tex",
    617,
    622
  );

  AssertSucceed();

  StopTestCase();

}

void ts64(lua_State *lstate){

  StartTestSuite(
    "assertSucceed"
  );

  ts64_tc1(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts65_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if true",
    "cTests.tex",
    646,
    650
  );

  AssertIntTrue(TRUE);

  StopTestCase();

}

void ts65_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if false",
    "cTests.tex",
    652,
    658
  );

  StartAssertShouldFail("","","");
    AssertIntTrue(FALSE);
  StopAssertShouldFail();

  StopTestCase();

}

void ts65(lua_State *lstate){

  StartTestSuite(
    "assertIntTrue"
  );

  ts65_tc1(lstate);
  ts65_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts66_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if false",
    "cTests.tex",
    681,
    685
  );

  AssertIntFalse(FALSE);

  StopTestCase();

}

void ts66_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if true",
    "cTests.tex",
    687,
    696
  );

  StartAssertShouldFail("","","");
    AssertIntFalse(TRUE);
  StopAssertShouldFail();
  StartAssertShouldFail("","","");
    AssertIntFalse(42);
  StopAssertShouldFail();

  StopTestCase();

}

void ts66(lua_State *lstate){

  StartTestSuite(
    "assertIntFalse"
  );

  ts66_tc1(lstate);
  ts66_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts67_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two integers are equal",
    "cTests.tex",
    720,
    724
  );

  AssertIntEquals(42, 42);

  StopTestCase();

}

void ts67_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two integers are not equal",
    "cTests.tex",
    726,
    732
  );

  StartAssertShouldFail("","","");
    AssertIntEquals(3,42);
  StopAssertShouldFail();

  StopTestCase();

}

void ts67(lua_State *lstate){

  StartTestSuite(
    "assertIntEquals"
  );

  ts67_tc1(lstate);
  ts67_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts68_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two integers are not equal",
    "cTests.tex",
    756,
    760
  );

  AssertIntNotEquals(3,42);

  StopTestCase();

}

void ts68_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two integers are equal",
    "cTests.tex",
    762,
    768
  );

  StartAssertShouldFail("","","");
    AssertIntNotEquals(42,42);
  StopAssertShouldFail();

  StopTestCase();

}

void ts68(lua_State *lstate){

  StartTestSuite(
    "assertIntNotEquals"
  );

  ts68_tc1(lstate);
  ts68_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts69_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if pointer is NULL",
    "cTests.tex",
    791,
    795
  );

  AssertPtrNull(NULL);

  StopTestCase();

}

void ts69_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if pointer is not NULL",
    "cTests.tex",
    797,
    803
  );

  StartAssertShouldFail("","","");
    AssertPtrNull("this is a pointer which is not null");
  StopAssertShouldFail();

  StopTestCase();

}

void ts69(lua_State *lstate){

  StartTestSuite(
    "assertPrtNull"
  );

  ts69_tc1(lstate);
  ts69_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts70_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if a pointer is not NULL",
    "cTests.tex",
    826,
    830
  );

  AssertPtrNotNull("this is another pointer which is not null");

  StopTestCase();

}

void ts70_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if a pointer is NULL",
    "cTests.tex",
    832,
    838
  );

  StartAssertShouldFail("","","");
    AssertPtrNotNull(NULL);
  StopAssertShouldFail();

  StopTestCase();

}

void ts70(lua_State *lstate){

  StartTestSuite(
    "assertPtrNotNull"
  );

  ts70_tc1(lstate);
  ts70_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts71_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two pointers are equal",
    "cTests.tex",
    862,
    867
  );

  char* aTest = "aTest";
  AssertPtrEquals(aTest, aTest);

  StopTestCase();

}

void ts71_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two pointers are not equal",
    "cTests.tex",
    869,
    875
  );

  StartAssertShouldFail("","","");
    AssertPtrEquals("ptr1", "ptr2");
  StopAssertShouldFail();

  StopTestCase();

}

void ts71(lua_State *lstate){

  StartTestSuite(
    "assertPtrEquals"
  );

  ts71_tc1(lstate);
  ts71_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts72_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two pointers are not equal",
    "cTests.tex",
    899,
    903
  );

  AssertPtrNotEquals("ptr1","ptr2");

  StopTestCase();

}

void ts72_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two pointers are equal",
    "cTests.tex",
    905,
    912
  );

  StartAssertShouldFail("","","");
    char* aTest = "aTest";
    AssertPtrNotEquals(aTest, aTest);
  StopAssertShouldFail();

  StopTestCase();

}

void ts72(lua_State *lstate){

  StartTestSuite(
    "assertPtrNotEquals"
  );

  ts72_tc1(lstate);
  ts72_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts73_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if a string is empty",
    "cTests.tex",
    934,
    938
  );

  AssertStrEmpty("");

  StopTestCase();

}

void ts73_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if a string is empty",
    "cTests.tex",
    940,
    946
  );

  StartAssertShouldFail("","","");
    AssertStrEmpty("a non empty string");
  StopAssertShouldFail();

  StopTestCase();

}

void ts73(lua_State *lstate){

  StartTestSuite(
    "assertStrEmpty"
  );

  ts73_tc1(lstate);
  ts73_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts74_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if a string is not empty",
    "cTests.tex",
    969,
    973
  );

  AssertStrNotEmpty("a non empty string");

  StopTestCase();

}

void ts74_tc2(lua_State *lstate){

  StartTestCase(
    "should fail is a string is empty",
    "cTests.tex",
    975,
    981
  );

  StartAssertShouldFail("","","");
    AssertStrNotEmpty("");
  StopAssertShouldFail();

  StopTestCase();

}

void ts74(lua_State *lstate){

  StartTestSuite(
    "assertStrNotEmpty"
  );

  ts74_tc1(lstate);
  ts74_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts75_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two strings are equal",
    "cTests.tex",
    1006,
    1015
  );

  char* str1 = "aString";
  char str2[256];
  strncpy(str2, str1, 255);
  AssertPtrNotEquals(str1, str2);
  AssertStrEquals(str1, str2);

  StopTestCase();

}

void ts75_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two strings are not equal",
    "cTests.tex",
    1017,
    1023
  );

  StartAssertShouldFail("","","");
    AssertStrEquals("str1", "str2");
  StopAssertShouldFail();

  StopTestCase();

}

void ts75(lua_State *lstate){

  StartTestSuite(
    "assertStrEquals"
  );

  ts75_tc1(lstate);
  ts75_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts76_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two strings are not equal",
    "cTests.tex",
    1048,
    1052
  );

  AssertStrNotEquals("str1", "str2");

  StopTestCase();

}

void ts76_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two strings are equal",
    "cTests.tex",
    1054,
    1065
  );

  char* str1 = "aString";
  char str2[256];
  strncpy(str2, str1, 255);
  AssertPtrNotEquals(str1, str2);
  StartAssertShouldFail("","","");
    AssertStrNotEquals(str1, str2);
  StopAssertShouldFail();

  StopTestCase();

}

void ts76(lua_State *lstate){

  StartTestSuite(
    "assertStrNotEquals"
  );

  ts76_tc1(lstate);
  ts76_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts77_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if a string mathces a pattern",
    "cTests.tex",
    1100,
    1105
  );

  AssertStrMatches("a test string", "test");
  AssertStrMatches("a test string", "te%a+");

  StopTestCase();

}

void ts77_tc2(lua_State *lstate){

  StartTestCase(
    "should fail is a string does not match a pattern",
    "cTests.tex",
    1107,
    1113
  );

  StartAssertShouldFail("","","");
    AssertStrMatches("a test string", "no match");
  StopAssertShouldFail();

  StopTestCase();

}

void ts77(lua_State *lstate){

  StartTestSuite(
    "assertStrMatches"
  );

  ts77_tc1(lstate);
  ts77_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts78_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if a string does not match a pattern",
    "cTests.tex",
    1148,
    1152
  );

  AssertStrDoesNotMatch("a test string", "no match");

  StopTestCase();

}

void ts78_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if a string does match a pattern",
    "cTests.tex",
    1154,
    1160
  );

  StartAssertShouldFail("","","");
    AssertStrDoesNotMatch("a test string", "test");
  StopAssertShouldFail();

  StopTestCase();

}

void ts78(lua_State *lstate){

  StartTestSuite(
    "assertStrNotMatch"
  );

  ts78_tc1(lstate);
  ts78_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts79_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two doubles are equal",
    "cTests.tex",
    1186,
    1191
  );

  AssertDblEquals(0.1, 0.1, 0.1);
  AssertDblEquals(0.11, 0.1, 0.2);

  StopTestCase();

}

void ts79_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two doubles are not equal",
    "cTests.tex",
    1193,
    1199
  );

  StartAssertShouldFail("","","");
    AssertDblEquals(1.1, 2.1, 0.1);
  StopAssertShouldFail();

  StopTestCase();

}

void ts79(lua_State *lstate){

  StartTestSuite(
    "assertDblEquals"
  );

  ts79_tc1(lstate);
  ts79_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
void ts80_tc1(lua_State *lstate){

  StartTestCase(
    "should succeed if two doubles are not equal",
    "cTests.tex",
    1226,
    1230
  );

  AssertDblNotEquals(1.1, 2.1, 0.1);

  StopTestCase();

}

void ts80_tc2(lua_State *lstate){

  StartTestCase(
    "should fail if two doubles are equal",
    "cTests.tex",
    1232,
    1241
  );

  StartAssertShouldFail("","","");
    AssertDblNotEquals(0.1, 0.1, 0.1);
  StopAssertShouldFail();
  StartAssertShouldFail("","","");
    AssertDblNotEquals(0.11, 0.1, 0.2);
  StopAssertShouldFail();

  StopTestCase();

}

void ts80(lua_State *lstate){

  StartTestSuite(
    "assertDblNotEqals"
  );

  ts80_tc1(lstate);
  ts80_tc2(lstate);

  StopTestSuite();

}

//-------------------------------------------------------
int main(){

  lua_State *lstate = luaL_newstate();
  luaL_openlibs(lstate);
  if luaL_dofile(lstate, "build/t-contests-cTests.lua") {
    fprintf(stderr, "Could not load cTests\n");
    fprintf(stderr, "%s\n", lua_tostring(lstate, 1));
    exit(-1);
  }

  ts62(lstate);
  ts63(lstate);
  ts64(lstate);
  ts65(lstate);
  ts66(lstate);
  ts67(lstate);
  ts68(lstate);
  ts69(lstate);
  ts70(lstate);
  ts71(lstate);
  ts72(lstate);
  ts73(lstate);
  ts74(lstate);
  ts75(lstate);
  ts76(lstate);
  ts77(lstate);
  ts78(lstate);
  ts79(lstate);
  ts80(lstate);

  fprintf(stdout, "\n");

  return 0;
}

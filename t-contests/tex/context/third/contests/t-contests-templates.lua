-- A Lua template file

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/conclusion.tex after line: 50

-- Copyright 2019 PerceptiSys Ltd (Stephen Gaito)
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
--
--    The above copyright notice and this permission notice shall
--    be included in all copies or substantial portions of the
--    Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/preamble.tex after line: 100

-- t-contests templates

if not modules then modules = { } end
modules ['t-contests-templates'] = {
    version   = 1.000,
    comment   = "ConTests Unit testing - templates",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata               = thirddata               or {}
thirddata.literateProgs = thirddata.literateProgs or {}
local litProgs          = thirddata.literateProgs
local setDefs           = litProgs.setDefs
local templates         = setDefs(litProgs, 'templates')

local tInsert = table.insert
local tConcat = table.concat

local addTemplate = litProgs.addTemplate

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 950

addTemplate(
  'cmTexFormalArgs',
  { 'anArg' },
  '#{{= anArg}}'
)

addTemplate(
  'cmTexUseArgs',
  { 'anArg' },
  '{#{{= anArg}}}'
)

addTemplate(
  'cmContextFormalArgs',
  { 'anArg' },
  '[#{{= anArg}}]'
)

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 1000

addTemplate(
  'cmFormalArgs',
  { 'anArg', 'argTemplate' },
  '{{! *argTemplate, anArg }}'
)

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 1000

addTemplate(
  'cmLuaArgUse',
  { 'anArg' },
  "        '#{{= anArg}}'"
)

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 1000

addTemplate(
  'ctmMain',
  { 'macroName', 'argList', 'argType',
    'argTemplate', 'argUseTemplate',
    'emptyStr', 'commaNewLine' },
  [=[
\let\old{{= macroName}}=\{{= macroName}}
\clearExpansionInfoFor{ {{= macroName}} }
\def\{{= macroName}}{{| argList, emptyStr, cmFormalArgs,
                        anArg, argTemplate }}{
  \directlua{
    thirddata.contests.recordExpansion(
      '{{= macroName}}',
      '{{= argType}}',
      {
{{| argList, commaNewLine, cmLuaArgUse, anArg }}
      }
    )
  }
  \old{{= macroName}}{{| argList, emptyStr, cmFormalArgs,
                         anArg, argUseTemplate }}
}
]=]
)

-- from file: ~/ExpositionGit/tools/conTeXt/ConTests/t-contests/doc/context/third/contests/mkivTests.tex after line: 1050

addTemplate(
  'cmmMain',
  { 'macroName', 'argList', 'argType',
    'argTemplate', 'argUseTemplate',
    'emptyStr', 'commaNewLine' },
  [=[
\let\old{{= macroName}}=\{{= macroName}}
\clearExpansionInfoFor{ {{= macroName}} }
\def\{{= macroName}}{{| argList, emptyStr, cmFormalArgs,
                        anArg, argTemplate }}{
  \directlua{
    thirddata.contests.mockExpansion(
      '{{= macroName}}',
      '{{= argType}}',
      {
{{| argList, commaNewLine, cmLuaArgUse, anArg }}
      }
    )
  }
}
]=]
)


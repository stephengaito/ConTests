-- A Lua template file

-- from file: preamble.tex after line: 100

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
litProgs.templates      = litProgs.templates      or {}
local templates         = litProgs.templates

local tInsert = table.insert
local tConcat = table.concat

local addTemplate = litProgs.addTemplate

-- from file: mkivTests.tex after line: 950

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

-- from file: mkivTests.tex after line: 950

addTemplate(
  'cmFormalArgs',
  { 'anArg', 'argTemplate' },
  '{{! *argTemplate, anArg }}'
)

-- from file: mkivTests.tex after line: 1000

addTemplate(
  'cmLuaArgUse',
  { 'anArg' },
  "        '#{{= anArg}}'"
)

-- from file: mkivTests.tex after line: 1000

addTemplate(
  'ctmMain',
  { 'macroName', 'argList', 'argType',
    'argTemplate', 'argUseTemplate',
    'emptyStr', 'commaNewLine' },
  [=[
\let\old{{= macroName}}=\{{= macroName}}
\clearExpansionInfoFor{ {{= macroName}} }
\def\{{= macroName}}{{| argList, emptyStr, cmFormalArgs,
                        anArg, argTemplate }}{%
  \directlua{%
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

-- from file: mkivTests.tex after line: 1050

addTemplate(
  'cmmMain',
  { 'macroName', 'argList', 'argType',
    'argTemplate', 'argUseTemplate',
    'emptyStr', 'commaNewLine' },
  [=[
\let\old{{= macroName}}=\{{= macroName}}
\clearExpansionInfoFor{ {{= macroName}} }
\def\{{= macroName}}{{| argList, emptyStr, cmFormalArgs,
                        anArg, argTemplate }}{%
  \directlua{%
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
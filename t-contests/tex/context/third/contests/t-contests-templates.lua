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

-- from file: mkivTests.tex after line: 700

addTemplate(
  'ctmTexFormalArgs',
  { 'anArg' },
  '#{{= anArg}}'
)

addTemplate(
  'ctmContextFormalArgs',
  { 'anArg' },
  '[#{{= anArg}}]'
)

-- from file: mkivTests.tex after line: 700

addTemplate(
  'ctmFormalArgs',
  { 'anArg', 'argTemplate' },
  '{{! *argTemplate, anArg }}'
)

-- from file: mkivTests.tex after line: 750

addTemplate(
  'ctmArgUse',
  { 'anArg' },
  "        '#{{= anArg}}'"
)

-- from file: mkivTests.tex after line: 750

addTemplate(
  'ctmMain',
  { 'macroName', 'argList', 'argType', 'argTemplate',
    'emptyStr', 'commaNewLine' },
  [=[
\let\old{{= macroName}}=\{{= macroName}}
\def\{{= macroName}}{{| argList, emptyStr, ctmFormalArgs,
                        anArg, argTemplate }}{%
  \directlua{%
    thirddata.contests.traceMacro(
      '{{= macroName}}',
      '{{= argType}}',
      {
{{| argList, commaNewLine, ctmArgUse, anArg }}
      }
    )
  }
}
]=]
)
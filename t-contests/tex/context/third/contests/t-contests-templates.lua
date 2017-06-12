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

-- from file: mkivTests.tex after line: 675

addTemplate(
  'ctmTexFormalArgs',
  { 'anArg' },
  '[#{{= anArg}}]'
)

addTemplate(
  'ctmContextFormalArgs',
  { 'anArg' },
  '#{{= anArg}}'
)

addTemplate(
  'ctmArgUse',
  { 'anArg' },
[=[
        '#{{= anArg}}'
]=]
)

addTemplate(
  'ctmFormalArgs',
  { 'anArg', 'argTemplate' },
  [=[{{! *argTemplate, anArg }}]=]
)

addTemplate(
  'ctmMain',
  { 'macroName', 'argList', 'argType', 'argTemplate' },
  [=[
\let\old{{= macroName}}=\{{= macroName}}
\def\{{= macroName}}{{| argList, '', ctmFormalArgs, anArg, argTemplate }}{%
  \directlua{%
    thirddata.contests.traceMacro(
      '{{= macroName}}',
      '{{= argType}}',
      {
        {{| argList, ',\n', ctmArgUse }}
      }
    )
  }
}
  ]=]
)
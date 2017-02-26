if not modules then modules = { } end modules ['mtx-xrefs'] = {
    version   = 1.001,
    comment   = "companion to mtxrun.lua",
    author    = "Stephen Gaito, PerceptiSys Ltd",
    copyright = "Stephen Gaito, PerceptiSys Ltd",
    license   = "MIT License"
}

local helpinfo = [[
<?xml version="1.0"?>
<application>
 <metadata>
  <entry name="name">mtx-xrefs</entry>
  <entry name="detail">ConTeXt cross reference builder</entry>
  <entry name="version">0.10</entry>
 </metadata>
 <flags>
  <category name="basic">
   <subcategory>
    <flag name="build"><short>build cross references</short></flag>
   </subcategory>
  </category>
 </flags>
 <examples>
  <category>
   <title>Example</title>
   <subcategory>
    <example><command>mtxrun --script xrefs --build</command></example>
   </subcategory>
  </category>
 </examples>
</application>
]]

local application = logs.application {
  name     = "mtx-xrefs",
  banner   = "ConTeXt cross reference builder 0.10",
  helpinfo = helpinfo,
}

local report = application.report
local lfs    = require('lfs')

scripts       = scripts or { }
scripts.xrefs = scripts.xrefs or { }

function scripts.xrefs.walkDirDoing(aDir, aMethod)
  report('walking ['..aDir..']')
  local oldDir = lfs.currentdir()
  lfs.chdir(aDir)
  for aFile in lfs.dir('.') do
    if aFile:match('^%.+$') then
      -- ignore 
    elseif lfs.attributes(aFile,"mode") == "file" then
      aMethod(aFile)
    elseif lfs.attributes(aFile,"mode")== "directory" then
      scripts.xrefs.walkDirDoing(aDir..'/'..aFile, aMethod)
    end
  end
  lfs.chdir(oldDir)
end

function scripts.xrefs.loadInterfaces(aFile)
  if aFile:match('%.xml$') then
    report(aFile)
  end
end

local countDefs = 0
function scripts.xrefs.loadDefinitions(aFile)
  if aFile:match('%.mkiv$') or aFile:match('%.mkvi$') then
    countDefs = countDefs + 1
    report(aFile)
  end
end

function scripts.xrefs.loadExamples(aFile)
  if aFile:match('%.tex$') then
    report(aFile)
  end
end

function scripts.xrefs.build()
  report("xrefs -build")
  report(lfs.currentdir())
  scripts.xrefs.walkDirDoing(os.getenv('SELFAUTOPARENT'), scripts.xrefs.loadDefinitions)
  report(countDefs)
  report(lfs.currentdir())
end

if environment.argument("build") then
  scripts.xrefs.build()
else
  application.help()
end

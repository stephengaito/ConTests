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
    <flag name="verbose"><short>provide verbose narative of actions</short></flag>
   </subcategory>
  </category>
 </flags>
 <examples>
  <category>
   <title>Example</title>
   <subcategory>
    <example><command>mtxrun --script xrefs --build [xrefsHtmlDirectory]</command></example>
    <example><command>mtxrun --script xrefs --verbose --build [xrefsHtmlDirectory]</command></example>
   </subcategory>
   <subcategory>
    <example><command>The parameter xrefsHtmlDirectory is optional.</command></example>
    <example><command>If xrefsHtmlDirecotry is not provided it defaults</command></example>
    <example><command>to the top-level 'xrefs' subdirectory</command></example>
    <example><command>of the context installation.</command></example>
    <example><command>In either case the xrefsHtmlDirectory</command></example>
    <example><command>must allready exist and be writable by the user.</command></example>
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
local pp     = require('pl.pretty') -- for use while debugging

scripts               = scripts or { }
scripts.xrefs         = scripts.xrefs or { }
scripts.xrefs.verbose = false

local mtxDir = os.getenv('SELFAUTOPARENT')..'/texmf-context/scripts/context/lua'
dofile(mtxDir..'/mtx-xrefs-html.lua')
--print(pp.write(xml))

function scripts.xrefs.walkDirDoing(parentDir, subDir, parentFilesTable, filesMethod, dirMethod)
  parentFilesTable[subDir] = { }
  local curFilesTable = parentFilesTable[subDir]
  local curDir = parentDir..'/'..subDir
  if scripts.xrefs.verbose then report('walking ['..curDir..']') end
  local oldDir = lfs.currentdir()
  lfs.chdir(curDir)
  for aFile in lfs.dir('.') do
    if aFile:match('^%.+$') then
      -- ignore 
    elseif lfs.isfile(aFile) then
      if type(filesMethod) == 'function' then filesMethod(curFilesTable, aFile) end
    elseif lfs.isdir(aFile) then
      scripts.xrefs.walkDirDoing(curDir, aFile, curFilesTable, filesMethod, dirMethod)
      if type(dirMethod) == 'function' then dirMethod(curFileTable, aFile) end
    end
  end
  if next(curFilesTable) == nil then parentFilesTable[subDir] = nil end
  lfs.chdir(oldDir)
end

local function buildInterfaceSyntax(interfaceSyntax, someXml)
  local tag = (someXml['ns']..':' or '')..someXml['tg']
  interfaceSyntax[tag] = { }
  local dt = someXml['dt']
  for i, value in ipairs(dt) do
    if type(value) == 'table' and value['special'] == nil then
      buildInterfaceSyntax(interfaceSyntax[tag], value)
    end
  end
end

function scripts.xrefs.findInterfacesNamespaces(parentFilesTable, aFile)
  if aFile:match('%.xml$') then
    parentFilesTable[aFile] = 'interface'
    if scripts.xrefs.verbose then report('interface '..aFile) end
    local interfaceFile = io.open(aFile, 'r')
    local interfaceStr  = interfaceFile:read('*all')
    interfaceFile:close()
    if interfaceStr:match('%<cd%:interface') then
      -- we only care about interface definitions
      --print(interfaceStr)
      print(aFile)
      local interfaceXml  = xml.convert(interfaceStr)
      --print(pp.write(interfaceXml))
      buildInterfaceSyntax(scripts.xrefs.interfaceSyntax, interfaceXml)
      --print(pp.write(scripts.xrefs.interfaceSyntax))
      --os.exit(-1)
    end
  elseif aFile:match('%.mkiv') or aFile:match('%.mkvi') then
    parentFilesTable[aFile] = 'definition'
    if scripts.xrefs.verbose then report('definition '..aFile) end
  end
end

local countDefs = 0
function scripts.xrefs.loadDefinitions(parentFilesTable, aFile)
  if aFile:match('%.mkiv$') or aFile:match('%.mkvi$') then
    countDefs = countDefs + 1
    report(aFile)
  end
end

function scripts.xrefs.loadExamples(parentFilesTable, aFile)
  if aFile:match('%.tex$') then
    report(aFile)
  end
end

function scripts.xrefs.build()
  --
  -- determine the htmlDir
  --
  local contextDir = os.getenv('SELFAUTOPARENT')
  local subDir = contextDir:match('[^/]+$')
  contextDir = contextDir:gsub('/[^%/]+$', '')
  local htmlDir    = environment.files[1]
  if htmlDir == nil then
    htmlDir = contextDir..'/xrefs'
  end
  --
  -- prove that we can write into the htmlDir
  --
  local testFileName = htmlDir..'/mtx-xrefs-tmp-'..tostring(os.time())
  local testFile, errorStr = io.open(testFileName, 'w')
  if testFile then
    io.close(testFile)
    os.remove(testFileName)
  else
    if scripts.xrefs.verbose then report(errorStr) end
    report('You are not permitted to write into')
    report('  '..htmlDir)
    report('Please ensure this directory exists')
    report('and is writeable by you.\n')
    os.exit(-1)
  end
  scripts.xrefs.htmlDir = htmlDir
  report('Building xrefs into: ['..scripts.xrefs.htmlDir..']')
  --
  -- Now do the work
  --
  
  scripts.xrefs.files = { }
  scripts.xrefs.interfaceSyntax = { }
  scripts.xrefs.walkDirDoing(
    contextDir, subDir, scripts.xrefs.files,
    scripts.xrefs.findInterfacesNamespaces, function() end)
  print(pp.write(scripts.xrefs.interfaceSyntax))
  local filesHtmlFileName = htmlDir..'/files.html'
  local filesHtmlFile = io.open(filesHtmlFileName, 'w')
  if filesHtmlFile then
    scripts.xrefs.writeHtmlHeader(filesHtmlFile)
    scripts.xrefs.writeFilesHtml(filesHtmlFile, ' ', scripts.xrefs.files)
    scripts.xrefs.writeHtmlFooter(filesHtmlFile)
    filesHtmlFile:close()
  end
end

if environment.argument("verbose") then
  scripts.xrefs.verbose = true
end

if environment.argument("build") then
  scripts.xrefs.build()
else
  application.help()
end

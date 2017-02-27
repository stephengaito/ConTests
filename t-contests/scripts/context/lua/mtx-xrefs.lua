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

function scripts.xrefs.writeHtmlHeader(htmlFile)
  htmlFile:write('<html><head></head><body>\n')
end

function scripts.xrefs.writeHtmlFooter(htmlFile)
  htmlFile:write('</body></html>\b')
end

function scripts.xrefs.writeFilesHtml(htmlFile, indent, filesTable)
  local keys = { }
  for aKey in pairs(filesTable) do keys[#keys + 1] = aKey end
  table.sort(keys)
  local newIndent = indent..' '
  htmlFile:write(indent..'<ul>\n')
  for i, aKey in ipairs(keys) do
    htmlFile:write(newIndent..'<li> '..aKey..'\n')
    if type(filesTable[aKey]) == 'table' then
      scripts.xrefs.writeFilesHtml(htmlFile, newIndent..' ', filesTable[aKey])
    end
    htmlFile:write(newIndent..'</li>\n')
  end
  htmlFile:write(indent..'</ul>\n')
end

-- The parseXmlArgs and parseXmlTags functions have been adapted from
-- Roberto Ierusalimschy's Classic Lua-only XML parser
-- see: http://lua-users.org/wiki/LuaXml 

function scripts.xrefs.parseXmlArgs(s)
  local arg = {}
  string.gsub(s, "([%-%w]+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end
    
function scripts.xrefs.parseXmlTags(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=scripts.xrefs.parseXmlArgs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=scripts.xrefs.parseXmlArgs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end

function scripts.xrefs.walkDirDoing(parentDir, subDir, parentFilesTable, aMethod)
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
      aMethod(curFilesTable, aFile)
    elseif lfs.isdir(aFile) then
      scripts.xrefs.walkDirDoing(curDir, aFile, curFilesTable, aMethod)
    end
  end
  if next(curFilesTable) == nil then parentFilesTable[subDir] = nil end
  lfs.chdir(oldDir)
end

function scripts.xrefs.findInterfacesNamespaces(parentFilesTable, aFile)
  if aFile:match('%.xml$') then
    parentFilesTable[aFile] = 'interface'
    if scripts.xrefs.verbose then report('interface '..aFile) end
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
    report(htmlDir)
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
  scripts.xrefs.walkDirDoing(
    contextDir, subDir, scripts.xrefs.files, scripts.xrefs.findInterfacesNamespaces)
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

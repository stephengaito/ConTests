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
    <example><command>mtxrun --script xrefs --build</command></example>
    <example><command>mtxrun --script xrefs --verbose --build</command></example>
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

function scripts.xrefs.walkDirDoing(aDir, aMethod)
  if scripts.xrefs.verbose then report('walking ['..aDir..']') end
  local oldDir = lfs.currentdir()
  lfs.chdir(aDir)
  for aFile in lfs.dir('.') do
    if aFile:match('^%.+$') then
      -- ignore 
    elseif lfs.isfile(aFile) then
      aMethod(aFile)
    elseif lfs.isdir(aFile) then
      scripts.xrefs.walkDirDoing(aDir..'/'..aFile, aMethod)
    end
  end
  lfs.chdir(oldDir)
end

function scripts.xrefs.findInterfacesNamespaces(aFile)
  if aFile:match('%.xml$') then
    report('interface '..aFile)
  elseif aFile:match('%.mkiv') or aFile:match('%.mkvi') then
    report('definition '..aFile)
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
  scripts.xrefs.htmlDir = environment.files
  scripts.xrefs.walkDirDoing(os.getenv('SELFAUTOPARENT'), scripts.xrefs.findInterfacesNamespaces)
end

if environment.argument("verbose") then
  scripts.xrefs.verbose = true
end

if environment.argument("build") then
  scripts.xrefs.build()
else
  application.help()
end

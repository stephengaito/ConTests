local function writeHtmlHeader(htmlFile, breadCrumbs)
  htmlFile:write('<html><head>\n')
  htmlFile:write('  <title>ConTeXt xrefs</title>\n')
  htmlFile:write('</head><body>\n')
  htmlFile:write('  <div>\n')
  htmlFile:write('    <a href="/files/index.html">files</a>\n')
  htmlFile:write('    <a href="/syntax/index.html">syntax</a>\n')
  htmlFile:write('  </div>\n')
  htmlFile:write('  <hr/>\n')
  if 0 < #breadCrumbs then
    htmlFile:write('  <div>\n')
    for i, aCrumb in ipairs(breadCrumbs) do
      htmlFile:write('    <a href="'..aCrumb['url']..'">'..aCrumb['tag']..'</a>\n')
    end
    htmlFile:write('  </div>\n')
    htmlFile:write('  <hr/>\n')
  end
end

local function writeHtmlFooter(htmlFile, breadCrumbs)
  if 0 < #breadCrumbs then
    htmlFile:write('  <hr/>\n')
    htmlFile:write('  <div>\n')
    for i, aCrumb in ipairs(breadCrumbs) do
      htmlFile:write('    <a href="/'..aCrumb['url']..'">'..aCrumb['tag']..'</a>\n')
    end
    htmlFile:write('  </div>\n')
  end
  htmlFile:write('  <hr/>\n')
  htmlFile:write('  <div>\n')
  htmlFile:write('    <a href="/files/index.html">files</a>\n')
  htmlFile:write('    <a href="/syntax/index.html">syntax</a>\n')
  htmlFile:write('  </div>\n')
  htmlFile:write('</body></html>\b')
end

local function writeFilesIndexHtml(keys, filesTable, breadCrumbs)
  local htmlFile = io.open('index.html', 'w')
  if htmlFile then
    writeHtmlHeader(htmlFile, breadCrumbs)
    htmlFile:write('  <ul>\n')
    for i, aKey in ipairs(keys) do
      if type(filesTable[aKey]) == 'table' then
        htmlFile:write('    <li><a href="'..aKey..'/index.html">'..aKey..'</a></li>\n')
      else
        htmlFile:write('    <li><a href="'..aKey..'.html">'..aKey..'</a></li>\n')
      end
    end
    htmlFile:write('  </ul>\n')
    writeHtmlFooter(htmlFile, breadCrumbs)
    htmlFile:close()
  end
end

local function writeAFileListing(aFile, aFullPath, breadCrumbs)
  local theFileName = scripts.xrefs.contextDir..'/'..aFullPath
  local theFile = io.open(theFileName, 'r')
  local fileListing = io.open(aFile..'.html', 'w')
  if theFile and fileListing then
    io.write('.')
    writeHtmlHeader(fileListing, breadCrumbs)
    fileListing:write('  <table>\n')
    local lineNum = 0
    local aLine = theFile:read('*line')
    while aLine do
      lineNum = lineNum + 1
      aLine = aLine:gsub('%<', '&lt;'):gsub('%>','&gt;')
      fileListing:write('    <tr><td><pre>'..tostring(lineNum)..'</pre></td><td><pre>'..aLine..'</pre></td></tr>\n')
      aLine = theFile:read('*line')
    end
    fileListing:write('  </table>\n')
    writeHtmlFooter(fileListing, breadCrumbs)
  else
    if not theFile then print('\ncould not open ['..theFileName..']\n') end
    if not fileListing then print('\ncould not open ['..aFile..'.html]\n') end
  end
end

local function writeFilesHtml(filesTable, aPath, aTag, breadCrumbs)
  --
  -- add this bread crumb
  --
  local aCrumb = { }
  aCrumb['url'] = aPath..'/index.html'
  aCrumb['tag'] = aTag
  local lastBreadCrumb = #breadCrumbs+1
  breadCrumbs[lastBreadCrumb] = aCrumb
  --
  -- sort the keys
  --
  local keys = { }
  for aKey in pairs(filesTable) do keys[#keys + 1] = aKey end
  table.sort(keys)
  --
  -- write out the index file
  --
  writeFilesIndexHtml(keys, filesTable, breadCrumbs)
  --
  -- now process each file or recurse into each subdirectory
  --
  for i, aKey in ipairs(keys) do
    if type(filesTable[aKey]) == 'table' then
      local oldDir = lfs.currentdir()
      lfs.mkdir(aKey)
      lfs.chdir(aKey)
      writeFilesHtml(filesTable[aKey], aPath..'/'..aKey, aKey, breadCrumbs)
      lfs.chdir(oldDir)
    else
      writeAFileListing(aKey, filesTable[aKey], breadCrumbs)
    end
  end
  --
  -- remove the last bread crumb
  --
  breadCrumbs[lastBreadCrumb] = nil
end

function scripts.xrefs.createFileHtml(htmlDir)
  io.write('\n\nProcessing files: ')
  lfs.chdir(htmlDir)
  local oldDir = lfs.currentdir()
  lfs.mkdir('files')
  lfs.chdir('files')
  writeFilesHtml(scripts.xrefs.files, '/files', 'files', { })
  lfs.chdir(oldDir)
end

local function writeSyntaxIndexHtml(keys, fsKeys, syntaxTable, breadCrumbs)
  local htmlFile = io.open('index.html', 'w')
  if htmlFile then
    writeHtmlHeader(htmlFile, breadCrumbs)
    htmlFile:write('  <ul>\n')
    for i, aKey in ipairs(keys) do
      if type(syntaxTable[aKey]) == 'table' then
        htmlFile:write('    <li><a href="'..fsKeys[aKey]..'/index.html">'..aKey..'</a></li>\n')
      else
        htmlFile:write('    <li><a href="/files/'..syntaxTable[aKey]..'/'..aKey..'.html">'..aKey..'</a></li>\n')
      end
    end
    htmlFile:write('  </ul>\n')
    writeHtmlFooter(htmlFile, breadCrumbs)
    htmlFile:close()
  end
end

local function writeInterfaceSyntaxHtml(syntaxTable, aPath, aTag, breadCrumbs)
  io.write('.')
  --
  -- add this bread crumb
  --
  local aCrumb = { }
  aCrumb['url'] = aPath..'/index.html'
  aCrumb['tag'] = aTag
  local lastBreadCrumb = #breadCrumbs+1
  breadCrumbs[lastBreadCrumb] = aCrumb
  --
  -- sort the keys
  --
  local keys = { }
  local fsKeys = { }
  for aKey in pairs(syntaxTable) do
    keys[#keys+1] = aKey
    fsKeys[aKey] = aKey:gsub('[%.%;% %:%+%/%"]', '-')
  end
  table.sort(keys)
  --
  -- write out the index file
  --
  if 0 < #keys then
    writeSyntaxIndexHtml(keys, fsKeys, syntaxTable, breadCrumbs)
  end
  --
  -- now recurse into each subdirectory
  --
  for i, aKey in ipairs(keys) do
    if type(syntaxTable[aKey]) == 'table' then
      local oldDir = lfs.currentdir()
      lfs.mkdir(fsKeys[aKey])
      lfs.chdir(fsKeys[aKey])
      writeInterfaceSyntaxHtml(syntaxTable[aKey], aPath..'/'..fsKeys[aKey], aKey, breadCrumbs)
      lfs.chdir(oldDir)
    end
  end
  --
  -- remove the last bread crumb
  --
  breadCrumbs[lastBreadCrumb] = nil
end

function scripts.xrefs.createInterfaceSyntaxHtml(htmlDir)
  io.write('\n\nProcessing Syntax: ')
  local oldDir = lfs.currentdir()
  lfs.chdir(htmlDir)
  lfs.mkdir('syntax')
  lfs.chdir('syntax')
  writeInterfaceSyntaxHtml(scripts.xrefs.interfaceSyntax, '/syntax', 'syntax', { })
  lfs.chdir(oldDir)
end

function scripts.xrefs.createRootIndexHtml(htmlDir)
  local indexFile = io.open('index.html', 'w')
  if indexFile then
    writeHtmlHeader(indexFile, { })
    writeHtmlFooter(indexFile, { })
  end
end
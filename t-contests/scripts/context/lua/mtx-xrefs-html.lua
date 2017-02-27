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

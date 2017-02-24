# Objectives:

Since this is an explicit lua based module, we will *only* support ConTeXt 
MKiv.

The average ConTeXt module writer, will want to interact with their 
module code at two distinct levels:

1. At the lua level using texlua (instead of luatex) typically during 
development or possibly for user lua scripts,

2. At the ConTeXt level while developing ConTeXt command for end users. 

This suggests that we only need t-contests*.lua and t-contests*.mkiv files. 

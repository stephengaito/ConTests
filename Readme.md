# ConTests

A ConTeXt unit testing module.

# Installation

At some point in the future, this ConTeXt/LuaTeX module may come as part of 
either the main distribution or the 'modules' collection. 

Until then, on a Unix machine, you can use the 'localInstall' script to 
install this module into your TEXMFHOME directory. If TEXMFHOME is owned by 
you as a user you can type: 

> ./localInstall

If TEXMFHOME is owned by root then you will need to be a sudoer and type:

> sudo ./localInstall

The location of your TEXMFHOME can be found by typing:

> kpsewhich -var-value TEXMFHOME

# Development

While developing a ConTeXt/LuaTeX module which uses ConTests, it is useful to 
make a symbolic link from your development directories into somewhere in your 
TEXINPUTS path. You can find out what your TEXINPUTS path is by typing:

> kpsewhich -show-path tex

On my system I have done this in $TEXMFHOME/tex/generic/dev

> cd `kpsewhich -var-value TEXMFHOME`
> ln -s <The full path to your development sources> tex/generic/dev

(NOTE: the back-tick '`' is used on Unix to return the result of the enclosed 
command) 

# Writing ConTeXt module documentation

## MKII 
The mkii way of producing module documentation was to use the following command:

> texexec --module <moduleFileName>.mkii

Taken from texexec.pdf:
> --module
> Create documentation for ConTeXt, MetaPost (see mpost(1)), perl(1), and ruby(1) modules.
> Converts the documentation to ConTeXt format and then typesets a documentated version of the
> source file.
> Documentation lines in ConTeXt source files are specified by beginning lines with these strings:
> %C : Copyright information
> %D : Documentation lines
> %I : TeXEdit information lines (mostly in Dutch)
> %M : Macro code needed to processs the documentation
> %S : Suppressed lines
> The same forms can be used for Perl or ruby scripts, except that the % character (the TeX comment
> character) is replaced by # (the Perl comment character).
> See also the --documentation option to ctxtools(1).

## MKII, MKIV and MKVI

The mkiv and mkvi way of producing module documentation is to use the 
following command: 

> mtxrun --script modules --process <moduleFileName>.{tex, mkii, mkiv, mkvi}

Taken from mtx-modules.lua:
> -- Documentation can be woven into a source file. This script can generates
> -- a file with the documentation and source fragments properly tagged. The
> -- documentation is included as comment:
> --
> -- %D ......  some kind of documentation
> -- %M ......  macros needed for documenation
> -- %S B       begin skipping
> -- %S E       end skipping
> --
> -- The generated file is structured as:
> --
> -- \starttypen
> -- \startmodule[type=suffix]
> -- \startdocumentation
> -- \stopdocumentation
> -- \startdefinition
> -- \stopdefinition
> -- \stopmodule
> -- \stoptypen
> --
> -- Macro definitions specific to the documentation are not surrounded by
> -- start-stop commands. The suffix specification can be overruled at runtime,
> -- but defaults to the file extension. This specification can be used for language
> -- depended verbatim typesetting.
> --
> -- In the mkiv variant we filter the \module settings so that we don't have
> -- to mess with global document settings.

## Notes:

* a grep of contributed modules shows that %S and %I are never used. 

* a grep of the official modules shows that only ppchtex.mkii and 
ppchtex.mkiv use either %I or %S (at the begining of lines) 


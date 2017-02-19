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


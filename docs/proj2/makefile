# Builds the html pages from rst source files

# Target names w/o suffix
targetName = main report source demonstration 
# add '.html' file extension
target_html = $(addsuffix .html,$(targetName))

codeName = microcomputer mips
code_html = $(addsuffix .html,$(codeName))

# required
all: $(target_html) $(code_html)
.PHONY: all

# build html files with pandoc
$(target_html):
	pandoc --highlight-style tango -H pandoc.css --to html $(basename $@).rst -o html/$@ 

$(code_html):
	pygmentize -O full,style=friendly -o html/$@ ../../src/$(basename $@).vhd

clean:
	cd html ; rm -f $(targets)


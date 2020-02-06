# Builds the html pages from rst source files
# TODO figure out how to eliminate ugly `[ Warning ]`'s

# Target names w/o suffix
targetName = main report source demonstration 
# add '.html' file extension
target_html = $(addsuffix .html,$(targetName))

codeName = ALU ALU_32 mips
code_html = $(addsuffix .html,$(codeName))

# required
all: $(target_html) $(code_html)
.PHONY: all

# build html files with pandoc
$(target_html):
	pandoc -f rst -t html $(basename $@).rst -o html/$@

$(code_html):
	pygmentize -O full,style=emacs -o html/$@ ../../src/$(basename $@).vhd

clean:
	cd html ; rm -f $(targets)

# Builds the html pages from rst source files
# TODO figure out how to eliminate ugly `[ Warning ]`'s

# Target names w/o suffix
targetName = main report source demonstration 
# add '.html' file extension
target_html = $(addsuffix .html,$(targetName))

# required
all: $(target_html)
.PHONY: all

# build html files with pandoc
%.html:
	pandoc -f rst -t html $(basename $@).rst -o html/$@


clean:
	cd html ; rm -f $(targets)

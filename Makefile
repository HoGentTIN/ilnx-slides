## Reveal.js presentation Makefile
#
# This Makefile will convert Markdown files into Reveal.js presentations using
# Pandoc.

.POSIX:     # Get reliable POSIX behaviour
.SUFFIXES:  # Ignore built-in inference rules

#
# Variables
#

# Source files: all Markdown files
sources := $(wildcard *.md)

# Directory for presentation files
output_dir := docs
# Output files: Reveal.js presentations
presentations := $(patsubst %.md,$(output_dir)/%.html,$(sources))  # Na

# Directory for PDF handouts
handout_dir := .
# Handout files
handouts := $(patsubst %.md,$(handout_dir)/%.pdf,$(sources))  # Na

## Reveal.js configuration

# Directory for reveal.js
reveal_js_dir := $(output_dir)/reveal.js
# File name of the reveal.js tarball
reveal_js_tar := 3.8.0.tar.gz
# Download URL
reveal_js_url := https://github.com/hakimel/reveal.js/archive/$(reveal_js_tar)

presentation_theme := hogent
presentation_theme_file := $(reveal_js_dir)/css/theme/$(presentation_theme).css

## Handouts configuration

main_font := 'Montserrat'
mono_font := 'Fira Code'
font_size := '11pt'
margin := '1.5cm'
highlight_style := 'haddock'
pdf_engine := 'xelatex'

#
# Build targets
#

help: ## Show this help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\033[36m%-20s\033[0m Generate individual presentations, with NAME one of:\n" "$(output_dir)/NAME.html"
	@printf "                         \033[36m%s\033[0m\n" $(presentations)
	@printf "\033[36m%-20s\033[0m Generate individual handouts, with NAME one of:\n" "$(handout_dir)/NAME.pdf"
	@printf "                         \033[36m%s\033[0m\n" $(handouts)

all: $(presentations) ## Convert all Markdown files into a Reveal.js presentation

handouts: $(handouts) ## Convert all Markdown files into handouts (PDF)

## Generate presentation from Markdown source
$(output_dir)/%.html: %.md $(reveal_js_dir) $(presentation_theme_file)
	pandoc \
		--standalone \
		--to=revealjs \
		--template=default.revealjs \
		--variable=theme:$(presentation_theme) \
		--highlight-style=$(highlight_style) \
		--output $@ $<

# Highlight styles: espresso or zenburn (not enough contrast in the others)
# Theme: black, moon, night

## Copy custom style file to the correct location
$(presentation_theme_file): $(presentation_theme).css $(reveal_js_dir)
	cp $(presentation_theme).css $(presentation_theme_file)

## Download and install reveal.js locally
$(reveal_js_dir):
	wget $(reveal_js_url)
	tar xzf $(reveal_js_tar)
	rm $(reveal_js_tar)
	mv -T reveal.js* $(reveal_js_dir)

$(handout_dir)/%.pdf: %.md
	pandoc --variable mainfont=$(main_font) \
		--variable monofont=$(mono_font) \
		--variable fontsize=$(font_size) \
		--variable geometry:margin=$(margin) \
		--highlight-style=$(highlight_style) \
		-f markdown  $< \
		--pdf-engine=$(pdf_engine) \
		-o $@

clean: ## Delete presentations and handouts
	rm -f $(output_dir)/*.html
	rm -f $(handout_dir)/*.pdf

mrproper: clean ## Thorough cleanup (also removes reveal.js)
	rm -rf $(reveal_js_dir)


## Presentation makefile

SOURCE := besturingssystemen-linux.md
OUTPUT := docs

# Directory for reveal.js
REVEAL_JS_DIR := $(OUTPUT)/reveal.js

# File name of the reveal.js tarball
REVEAL_JS_TAR := 3.4.0.tar.gz

# Download URL
REVEAL_JS_URL := https://github.com/hakimel/reveal.js/archive/$(REVEAL_JS_TAR)

STYLE := hogent
STYLE_FILE := $(REVEAL_JS_DIR)/css/theme/$(STYLE).css

## Presentation
$(OUTPUT)/index.html: $(SOURCE) $(REVEAL_JS_DIR) $(STYLE_FILE)
	pandoc \
		--standalone \
		--to=revealjs \
		--template=default.revealjs \
		--variable=theme:hogent \
		--highlight-style=haddock \
		--output $@ $<

# Highlight styles: espresso or zenburn (not enough contrast in the others)
# Theme: black, moon, night

$(STYLE_FILE): $(STYLE).css
	cp $(STYLE).css $(STYLE_FILE)

#$(OUTPUT)/img/*: img/*
#	cp -r img/* $(OUTPUT)/img

## Download and install reveal.js locally
$(REVEAL_JS_DIR):
	wget $(REVEAL_JS_URL)
	tar xzf $(REVEAL_JS_TAR)
	rm $(REVEAL_JS_TAR)
	mv -T reveal.js* $(REVEAL_JS_DIR)

all: $(STYLE_FILE) $(OUTPUT)/index.html

handouts.pdf: $(SOURCE)
	pandoc --variable mainfont="DejaVu Sans" \
		--variable monofont="DejaVu Sans Mono" \
		--variable fontsize=11pt \
		--variable geometry:margin=1.5cm \
		-f markdown  $< \
		--pdf-engine=lualatex \
		-o $@

## Cleanup
clean:
	rm -f $(OUTPUT)/*.html
	rm -f $(OUTPUT)/*.pdf

## Thorough cleanup (also removes reveal.js)
mrproper: clean
	rm -rf $(REVEAL_JS_DIR)


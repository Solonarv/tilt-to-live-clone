all: windows linux android html5zip

.PHONY: windows linux android html5 html5zip all

gdc := godot --no-window
sources := $(shell git ls-files -cmo --exclude-standard | sed -e '/^notes.*/ d' )

windows_files := out/windows/tilt-to-live-clone.exe
windows: $(windows_files)

linux_files := out/linux-x86_64/tilt-to-live-clone
linux: $(linux_files)

android: out/android/tilt-to-live-clone.apk

html5_files := out/html5/index.html
html5: $(html5_files)

html5zip: out/html5zip/tilt-to-live-clone.zip


$(windows_files): $(sources)
	$(gdc) --export-debug "Windows Desktop" $@

$(linux_files): $(sources)
	$(gdc) --export-debug "Linux/X11" $@

out/android/tilt-to-live-clone.apk: $(sources)
	$(gdc) --export-debug "Android" $@

$(html5_files): $(sources)
	$(gdc) --export-debug "HTML5" $@

out/html5zip/tilt-to-live-clone.zip: $(html5_files)
	zip $@ $(wildcard $(dir $^)*)

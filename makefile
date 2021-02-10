#SHELL := pwsh -NoProfile

ifeq ($(OS), Windows_NT)
  COPY=powershell cp
  REMOVE=powershell rm
else
  COPY=cp
  REMOVE=rm
endif

ASSET_DIR=assets
APP_ASSET_DIR=app/assets
TEXTURES=$(wildcard $(ASSET_DIR)/*.png)
APP_TEXTURES=$(patsubst $(ASSET_DIR)/%.png, $(APP_ASSET_DIR)/%.png, $(TEXTURES))

check:
	tl build -p

$(APP_ASSET_DIR)/%.png: $(ASSET_DIR)/%.png
	$(COPY) $< $@

#	Xcopy /E /I .\assets .\app\assets

build: $(APP_TEXTURES)
	tl build

run: build
	love app

clean:
	$(REMOVE) -r app/**/*.*

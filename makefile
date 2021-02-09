check:
	tl build -p

cpassets:
	Xcopy /E /I .\assets .\app\assets

build: #cpassets
	tl build

run: build
	love app

clean:
	rm -r app/*

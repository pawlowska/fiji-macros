xmax = getWidth()
ymax = getHeight()
max16bit = 65535

for (x=0; x< xmax; x++) { 
	for(y=0;y<ymax;y++) { 
		wartosc=getPixel(x,y);
		nowa_wartosc = (wartosc+100)%max16bit;
		print(wartosc+" "+nowa_wartosc);
		setPixel(x,y,nowa_wartosc); 
	}
} 
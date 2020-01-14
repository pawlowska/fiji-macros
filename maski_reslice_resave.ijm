//a=newArray("16_mask", "22_mask", "23_mask", "24_mask", "32_mask")
a=newArray("27_mask", "33_mask", "34_mask", "35_mask", "36_mask", "37_mask", "38_mask")

for (i = 0; i < a.length; i++) {
	selectWindow(a[i]+".nii.gz");
	run("Reslice [/]...", "output=25.022 start=Left avoid");
	run("Slice Keeper", "first=1 last="+nSlices+" increment=5");
	saveAs("Tiff", "D:/mozgi_sredni_sygnal/aw_exp/"+a[i]+".tif");
}


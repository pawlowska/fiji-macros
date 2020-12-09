//Open ASCII image and save as tif

folder="D:/superresolution/";
name='TIRF_2020_11_04/3_10p_avg';
run("Text Image... ", "open="+folder+name+".csv");
saveAs("Tiff", folder+name+".tif");

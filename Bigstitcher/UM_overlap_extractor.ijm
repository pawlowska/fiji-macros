//not working yet!

run("Bio-Formats Macro Extensions");

p="T:/2022_05-dystrofia/220511_mdx_Tudca_BO_PTriceps_15-20-28/15-20-28_mdx_Tudca_BO_PTriceps_UltraII[00 x 00]_C00_xyz-Table Z0000.ome.tif";
Ext.setId(p);
Ext.getSizeX(sizeX);
print(sizeX);
Ext.getMetadataValue("xyz-Table XYOvl",value);
print(value);
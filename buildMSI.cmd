@echo off
call WixEnv.cmd
candle lb450ExampleFiles.wxs lb450ProgFiles.wxs lb450setup.wxs -out wixobj\
light -ext WixUIExtension wixobj\*.wixobj -out installer\lb450setup.msi
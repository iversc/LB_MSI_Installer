@echo off
call WixEnv.cmd
heat dir ProgFiles -cg LBv450ProgFiles -gg -dr LBProgFiles -srd -sw5150 -var var.ProgFilesDir -t lb450-FilesStyle.xslt -out lb450ProgFiles.wxs
heat dir ExampleFiles -cg LBv450ExampleFiles -gg -dr LBExampleFiles -srd -sw5150 -var var.ExampleFilesDir -t lb450-FilesStyle.xslt -out lb450ExampleFiles.wxs

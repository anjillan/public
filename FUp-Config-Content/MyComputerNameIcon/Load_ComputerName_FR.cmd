MyComputerNameIcon\setacl.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ot reg -actn setowner -ownr "n:Administrateurs"
MyComputerNameIcon\SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ot reg -actn ace -ace "n:Administrateurs;p:full"
MyComputerNameIcon\SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ot reg -actn ace -ace "n:SYSTEM;p:full"
reg import MyComputerNameIcon\ComputerName_FR.reg /reg:64
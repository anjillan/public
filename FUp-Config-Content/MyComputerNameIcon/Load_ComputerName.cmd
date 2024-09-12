MyComputerNameIcon\setacl.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ot reg -actn setowner -ownr "n:Administrators"
MyComputerNameIcon\SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ot reg -actn ace -ace "n:Administrators;p:full"
MyComputerNameIcon\SetACL.exe -on "HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ot reg -actn ace -ace "n:SYSTEM;p:full"
reg import MyComputerNameIcon\ComputerName.reg /reg:64
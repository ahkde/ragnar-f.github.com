#NoEnv
#NoTrayIcon
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%
FileEncoding, UTF-8

; Seitenliste erstellen

If !FileExist("liste.txt")
{
	WinGet, CListe, ControlList, AutoWikiBrowser
	Loop, Parse, CListe, `n
		If A_LoopField ~= "LISTBOX\.app\.0\.33c0d9d1"
		{
			ControlGet, CListBox, Hwnd,, % A_LoopField, AutoWikiBrowser
			Break
		}
	ControlGet, Liste, List,,, % "ahk_id " CListBox
	FileOpen("liste.txt", "rw").Write(Liste)
}

; Zeilenposition ermitteln

Loop, Read, liste.txt
	DateiTotal := A_Index

WinGet, CListe, ControlList, AutoWikiBrowser
Loop, Parse, CListe, `n
	If A_LoopField ~= "LISTBOX\.app\.0\.33c0d9d1"
	{
		ControlGet, CListBox, Hwnd,, % A_LoopField, AutoWikiBrowser
		Break
	}
ControlGet, Liste, List,,, % "ahk_id " CListBox
Loop, Parse, Liste, `n
	Total := A_Index

Zeile := (DateiTotal - Total) + 1
If (Zeile = DateiTotal)
	FileDelete, liste.txt

; Wiki-Text einfügen

FileReadLine, Originalname, liste.txt, % Zeile
WinGetTitle, Titel, AutoWikiBrowser
RegExMatch(Titel, "AutoWikiBrowser - Default\.xml - (.*)", s)
Artikel := RegExReplace(s1, "\.", "_")
If (Artikel ~= "^(Hauptseite|AutoHotkey)$") ; Ausnahme überspringen
	Return
FileRead, Inhalt, % "wiki/" Artikel ".wiki"
If ErrorLevel
{
	Originalname := RegExReplace(Originalname, " ", "_")
	FileRead, Inhalt, % "wiki/" Originalname ".wiki"
}
If !ErrorLevel
{
	Datei := FileOpen("iofile.txt", "w")
	Datei.Write(Inhalt)
	Datei.Close()
}
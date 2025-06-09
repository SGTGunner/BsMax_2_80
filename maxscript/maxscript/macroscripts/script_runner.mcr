/*##########################################################################
#	This program is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <https://www.gnu.org/licenses/>.
##########################################################################*/

macroScript script_runner_mcr
    tooltip:"Script Runner"
    category:"Scene Tools"
(
	Global MyScriptpath = getINISetting (getMAXIniFile()) "NevilTools" "LocalScriptPath"
	
    if (quicktoolrunner_to != undefined) and (quicktoolrunner_to.isDisplayed) do(
        destroyDialog quicktoolrunner_to
    )

	Rollout quicktoolrunner_to "Script Runner V01.3.0"
	(
		Global _myfile_, _mydire_
		edittext globalserchtb "" offset:[-4,0] across:2
		edittext localserchtb "" offset:[-2,0]
		listbox Folder_lb "" across:2
		listbox File_lb ""
		Button Change_bt "Change Directory" width:117 offset:[-22,0] across:3 tooltip:"Change the defult folder of script archive"
		Button open_bt "Open Directory" width:117 offset:[-61,0] tooltip:"open selected folder on window explorer"
		checkButton edit_cbt "Edit Script Mode" width:238 offset:[-40,0] tooltip:"if checked script will open in script editor\nif not checked script will run"

		function getfolders_fn =
		(
			_mydire_ = #()
			_mydire_ = getDirectories (MyScriptpath+"*.*")

            for i = 1 to _mydire_.count do (
                _mydire_[i] = substring _mydire_[i] (MyScriptpath.count + 1) (_mydire_[i].count - MyScriptpath.count - 1)
            )

            Folder_lb.items = _mydire_
		)

		function getfiles_fn =
		(
			_myfile_ = #()

            try(
					_myfile_ = getFiles (MyScriptpath + Folder_lb.selected + "\*.ms");
					join _myfile_ (getFiles (MyScriptpath + Folder_lb.selected + "\*.mse"));
					join _myfile_ (getFiles (MyScriptpath + Folder_lb.selected + "\*.mcr"));
					join _myfile_ (getFiles (MyScriptpath + Folder_lb.selected + "\*.mzp"));
			)
            catch(
                -- pass --
            )

            for i = 1 to _myfile_.count do (
                _myfile_[i] = filenameFromPath _myfile_[i]
            )

            File_lb.items = _myfile_
		)

		on quicktoolrunner_to open do
        (
            getfolders_fn()
            getfiles_fn()
        )

        on Folder_lb selected arg do 
        (
            getfiles_fn()
        )

		on globalserchtb changed str do
		(
			newlist = #()

            for i in _mydire_ do (
                if findstring i str != undefined do (
                    append newlist i
                )
            )

            Folder_lb.items = newlist
			getfiles_fn()
		)

        on localserchtb changed str do
		(
			newlist = #()

            for i in _myfile_ do (
                if findstring i str != undefined do (
                    append newlist i
                )
            )

            File_lb.items = newlist
		)

		on File_lb selected  arg do
		(
			if edit_cbt.checked then (
                edit (MyScriptpath+Folder_lb.selected+"\\"+File_lb.selected)
            )
			else (
                try(
                    filein (MyScriptpath+Folder_lb.selected+"\\"+File_lb.selected)
                )
                catch(
                    -- pass --
                )
            )

            destroydialog quicktoolrunner_to
		)

		on Change_bt pressed do
		(
			try(
                MyScriptpath = getSavePath()  + "\\"
            )
            catch(
                MyScriptpath = undefined
            )
			
            if MyScriptpath != undefined do (
				setINISetting (getMAXIniFile()) "NevilTools" "LocalScriptPath" MyScriptpath
				getfolders_fn()
				getfiles_fn()
			)
		)

        on open_bt pressed do
        (
            HiddenDOSCommand ("explorer \""+ MyScriptpath + Folder_lb.selected +"\"")
        )
	)

	if MyScriptpath == "" then (
		try(
            MyScriptpath = getSavePath() + "\\"
        )
        catch(
            MyScriptpath = undefined
        )
		
        if MyScriptpath != undefined do (
			setINISetting (getMAXIniFile()) "NevilTools" "LocalScriptPath" MyScriptpath
			createdialog quicktoolrunner_to width:500
		)
	)
	else(
        createdialog quicktoolrunner_to width:500
    )
)
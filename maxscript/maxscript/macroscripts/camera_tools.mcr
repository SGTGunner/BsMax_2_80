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

macroScript CameraTools
	tooltip:"Time Came Tools"
	category:"Scene Tools"
(
	rollout CameraTools "Time Cam Tools"
	(
		Global SceneCameras = #(), TimeSliderList = #()
		group "Camera"
		(
			dropdownlist CamsDDL ""
			button SelectCambtn "Sel. Camera" width:68 offset:[1,0] across:2 tooltip:"Select the Camera only"
			button SelectTargbtn "Sel. Target" width:68 offset:[2,0] tooltip:"Select the Target only"
			button SelCamTargbtn "Select Camera & Target" width:140 tooltip:"Select the Camera and the target"
			button FlatCamerabtn "Horizon" width:140 tooltip:"Flat the camera in horizon"
			button FOV45btn "F.O.V. 45" width:140 tooltip:"Camera F.O.V. = 45"
		)
		Group "Time Slider"
		(
			listbox Listmlb "" width:140 offset:[-2,0]
			edittext Nameet width:140 offset:[-4,0]
			button Addbtn "+" width:30 across:4 tooltip:"Add current frame range to list"
			button Removebtn "-" width:30 tooltip:"Remove selected preset from list"
			button previewbtn "<" width:30 tooltip:"Previews frame range"
			button Nextbtn ">" width:30 tooltip:"Next frame range"
		)
		button aboutbtn "About" width:155 height:15

		function TimeSliderSavefn = -- Time slider
		(
			Local Holder = $TimeSliderPresetHolder
			if Holder == undefined do -- not exist make a new one --
			(
				Holder = Point pos:[0,0,0] isSelected:off Box:false cross:false axistripod:false centermarker:false name:"TimeSliderPresetHolder"
				TSPHCA = attributes TimeSliderPresetHolderCustomAttribute
				(
					parameters Param
					(
						TimeSliderPresetList type:#stringTab tabSizeVariable:true
					)
					rollout Roll "Holder"
					(
						label lbl "This Node is a Data Holder"
					)
				)
				custAttributes.add Holder TSPHCA
			)
			if TimeSliderList.count > 0 then (
				Holder.TimeSliderPresetList = TimeSliderList -- put data on holder node --
			)
			else (
				if Holder != undefined do (
					delete Holder
				)
			)
		)

		function Loadfn =
		(
			Local Holder = $TimeSliderPresetHolder
			if Holder != undefined then (
				try (
					TimeSliderList = Holder.TimeSliderPresetList as array
				)
				catch(
					TimeSliderList = #()
				)
			)
			else (
				TimeSliderList = #()
			)
		)

		function Updatefn =
		(
			 -- reset values --
			SceneCameras = #()
			TimeSliderList = #()
			-- Camera tools --
			Local CamNames = #()
			for C in Cameras do (
				if superclassof C == camera do (
					append SceneCameras C
					append CamNames C.name
				)
			)
			CamsDDL.Items = CamNames
			-- Time Slider --
			Loadfn()
			Listmlb.items = TimeSliderList
		)

		function GetTarget cam = 
		(
			try(cam.target)catch(Updatefn())4
		)

		function SmartDetect str =
		(
			local num = str as integer, IsCommand = false
			if str != "" do (
				if num != undefined then (
					slidertime = num
					IsCommand = true
				)
				else (
					local nums = filterstring str "-"
					if nums.count == 2 do (
						local Snum = nums[1] as integer
						local Enum = nums[2] as integer
						if Snum != undefined and Enum != undefined do (
							animationRange = (interval Snum enum)
							IsCommand = true
						)
					)
				)
				if str == "<" then (
					animationRange = (interval slidertime animationRange.end)
					IsCommand = true
				)
				else if str == ">" then (
					animationRange = (interval animationRange.start (slidertime + 1))
					IsCommand = true
				)
			)
			return IsCommand
		)
		
		on CameraTools open do (
			Updatefn()
		)

		on CameraTools lbuttondblclk p do (
			Updatefn()
		)

		-- Camera Events --
		on SelectCambtn pressed do 
		(
			if SceneCameras.count > 0 do(
				try(
					if SceneCameras[CamsDDL.selection] != undefined do(
						select SceneCameras[CamsDDL.selection]
					)
				)
				catch(
					Updatefn()
				)
			)
		)
		on SelectTargbtn pressed do
		(
			if SceneCameras.count > 0 do (
				try (
					if SceneCameras[CamsDDL.selection] != undefined do (
						T = GetTarget SceneCameras[CamsDDL.selection]
					)
					if T != undefined do (
						select T
					)
				)
				catch (
					Updatefn()
				)
			)
		)
		on SelCamTargbtn pressed do 
		(
			if SceneCameras.count > 0 do (
				try (
					if SceneCameras[CamsDDL.selection] != undefined do (
						T = GetTarget SceneCameras[CamsDDL.selection]
					)
					S = #()

					if SceneCameras[CamsDDL.selection] != undefined do (
						append S SceneCameras[CamsDDL.selection]
					)

					if T != undefined do (
						append S T
					)

					select S
				)
				catch (
					Updatefn()
				)
			)
		)

		on FlatCamerabtn pressed do 
		(
			if SceneCameras.count > 0 do (
				try (
					local cam = SceneCameras[CamsDDL.selection]
					if cam != undefined do (
						T = SceneCameras[CamsDDL.selection].target
					)

					if T != undefined then (
						T.pos.z = SceneCameras[CamsDDL.selection].pos.z
					)
					else (
						disableSceneRedraw() 

						Tcam = Targetcamera pos:[0, 0, 0] isSelected:off target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [1,0,0]))
						Targ = point pos:[0,0,0] isSelected:off
						Targ.transform = cam.transform
						Targ.Parent = Cam
						in coordsys parent (
							Targ.pos = [0,0,-10]
						)
						Tcam.transform = Cam.transform
						Tcam.target.transform = Targ.transform
						Tcam.target.pos.z = Tcam.pos.z
						Cam.transform = Tcam.transform
						Delete #(Tcam, Targ)
						enableSceneRedraw()
					)
				)
				catch (
					Updatefn()
				)
			)
		)

		on FOV45btn pressed do 
		(
			if SceneCameras.count > 0 do (
				try(
					if SceneCameras[CamsDDL.selection] != undefined do (
						SceneCameras[CamsDDL.selection].fov = 45
					)
				)
				catch (
					Updatefn()
				)
			)
		)

		-- Time slider Events --
		on Addbtn pressed do 
		(
			local UniqueItem = true, TheNewItem = (animationRange.start as string + " " + animationRange.end as string)
			for t in TimeSliderList do (
				Keys = filterstring t ": "
				if TheNewItem == (Keys[1] + " " +Keys[2]) do (
					UniqueItem = false
					break
				)
			)
			if UniqueItem do (
				append TimeSliderList TheNewItem -- append if unique --
			)

			Tarray = #()

			for i = 1 to TimeSliderList.count do (
				index = 0
				newitem = TimeSliderList[1]
				for j = 1 to TimeSliderList.count do (
					Fnum = (filterstring newitem " fF")[1] as integer
					Snum = (filterstring TimeSliderList[j] " fF")[1] as integer
					if Snum < Fnum do (
						newitem = TimeSliderList[j]
						index = j
					)
					if Snum == Fnum do (
						Fnum = (filterstring newitem " fF")[2] as integer
						Snum = (filterstring TimeSliderList[j] " fF")[2] as integer
						if Snum <= Fnum do (
							newitem = TimeSliderList[j]
							index = j
						)
					)
				)
				if index > 0 do (
					append Tarray newitem
					deleteItem TimeSliderList index
				)
			)

			join TimeSliderList Tarray
			TimeSliderSavefn()
			Listmlb.items = TimeSliderList

			for i = 1 to TimeSliderList.count do (
				Keys = filterstring TimeSliderList[i] ": "
				if TheNewItem == (Keys[1] + " " + Keys[2]) do (
					Listmlb.selection = i
					break
				)
			)

			Nameet.text = ""
		)

		on Removebtn pressed do
		(
			try(
				deleteItem TimeSliderList Listmlb.selection
			)
			catch(
				-- pass --
			)

			TimeSliderSavefn()
			Listmlb.items = TimeSliderList
			Nameet.text = ""
		)

		on Listmlb selected arg do 
		(
			if arg > 0 do (
				NameSplit = filterstring TimeSliderList[Listmlb.selection] ": "
				if NameSplit.count > 2 then (
					Nameet.text = NameSplit[3]
				)
				else (
					Nameet.text = ""
				)
			)
		)

		on Listmlb doubleClicked arg do 
		(
			if arg > 0 do (
				execute ("animationRange = interval " + (filterstring Listmlb.items[arg] ":")[1])
				redrawViews()
			)
		)

		on previewbtn pressed do
		(
			if Listmlb.selection > 1 do (
				Listmlb.selection -= 1
			)

			if Listmlb.selection > 0 do (
				execute ("animationRange = interval " + (filterstring Listmlb.items[Listmlb.selection] ":")[1])
			)

			redrawViews() 
		)

		on Nextbtn pressed do
		(
			if Listmlb.selection < Listmlb.items.count do (
				Listmlb.selection += 1
			)
			
			if Listmlb.selection > 0 do (
				execute ("animationRange = interval " + (filterstring Listmlb.items[Listmlb.selection] ":")[1])
			)

			redrawViews() 
		)

		on Nameet entered arg do
		(
			if not SmartDetect arg then (
				Sel = Listmlb.selection
				OrigName = filterstring TimeSliderList[Listmlb.selection] ": "
				if arg == "" then TimeSliderList[Sel] = OrigName[1] + " " + OrigName[2]
				else TimeSliderList[Sel] = OrigName[1] + " " + OrigName[2] + " : " + arg
				Listmlb.items = TimeSliderList
				Listmlb.selection = Sel
				TimeSliderSavefn()
			)
			Nameet.text = ""
		)

		on aboutbtn pressed do
		(
			rollout Aboutro "About"
			(
				label lbl1 "Time And Cam Tool V01.0.2"
				label lbl2 "Contact The Author: NevilArt@Gmail.Com"
				hyperlink web "Www.NevilArt.BlogSpot.Com" address:"www.nevilart.blogspot.com" offset:[45,0]
			)
			createdialog Aboutro modal:true width:250
		)
	)

	createdialog CameraTools
)
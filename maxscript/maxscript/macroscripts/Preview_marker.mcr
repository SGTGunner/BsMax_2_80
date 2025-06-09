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

macroScript preview_marker_mcr
    toolTip:"Preview Marker"
    category:"Animation Tools"
    --buttontext:"Preview Marker"
(
	rollout GetNamero "SM Prev.Marker"
	(
		group "Preview"
		(
			label lbl "User Name" align:#left
			edittext UNET "" width:130 text:sysinfo.username offset:[-9,0] across:2
			checkbox savecb "" width:10 offset:[58,1]  tooltip:"Save this name"
			button Createbtn "Create Preview" width:145 
		)
		group "Option"
		(
			checkbox C01 "Max File Name" checked:true
			checkbox C02 "Camera Name" checked:false
			checkbox C03 "Frame Number" checked:true
			checkbox C04 "Frame Rate" checked:true
			checkbox C05 "User Name" checked:true
			checkbox C06 "Date" checked:true
			checkbox C07 "Clock" checked:false
		)

        function Previewfn =
		(
			createPreview outputAVI:true percentSize:75 \
				start:animationrange.start.frame end:animationrange.end.frame skip:1 fps:25 \
				dspGeometry:true dspShapes:false dspLights:false \
				dspCameras:false dspHelpers:false dspParticles:false dspBones:false \
				dspGrid:false dspSafeFrame:true dspFrameNums:false dspBkg:true \
				rndLevel:#smooth
		)

        function SaveInfo =
		(
			SetINISetting (getMAXIniFile()) "SiyahMartiPreviewMarker" "SaveName" (savecb.state as string)
			SetINISetting (getMAXIniFile()) "SiyahMartiPreviewMarker" "Name"  UNET.text
			Local CBS = #(#("C01", C01),#("C02", C02),#("C03", C03),#("C04", C04),#("C05", C05),#("C06", C06),#("C07", C07))
			for C in CBS do SetINISetting (getMAXIniFile()) "SiyahMartiPreviewMarker" C[1]  (C[2].state as string)
		)

		on GetNamero open do
		(
			Savecb.state = if GetINISetting (getMAXIniFile()) "SiyahMartiPreviewMarker" "SaveName" == "true" then true else false
			Thename = GetINISetting (getMAXIniFile()) "SiyahMartiPreviewMarker" "Name"

			if Thename != undefined and Thename != "" do (
				if Savecb.state do (
					UNET.text = Thename
				)

				Local CBS = #(#("C01", C01),#("C02", C02),#("C03", C03),#("C04", C04),#("C05", C05),#("C06", C06),#("C07", C07))

				for C in CBS do (
					C[2].state = if GetINISetting (getMAXIniFile()) "SiyahMartiPreviewMarker" C[1] == "true" then true else false
				)
			)
		)

		on GetNamero close do (
			SaveInfo()
		)

		function CreatPreviewfn =
		(
			SaveInfo();
			function Markerfn =
			(
				local Marker = ""
				if C01.state do (
					Marker += getFilenameFile maxfilename
				)

				if C02.state do (
					Marker += (if Marker != "" then " : " else "") + (if viewport.getType() == #view_camera then (viewport.getcamera()).name else "")
				)

				if C03.state do (
					Marker += (if Marker != "" then " : " else "") + (slidertime.frame as integer) as string
				)

				if C04.state do (
					Marker += (if Marker != "" then " : " else "") + framerate as string + "fps"
				)

				if C05.state do (
					Marker += (if Marker != "" then " : " else "") + UNET.text
				)

				if C06.state do (
					Marker += (if Marker != "" then " : " else "") + (filterstring localtime " ")[1]
				)

				if C07.state do (
					Marker += (if Marker != "" then " : " else "") + (filterstring localtime " ")[2]
				)

				gw.htext [((gw.getWinSizeX() / 2) - (Marker.count * 6) / 2),3,100] Marker color:(color 255 255 255)
			)

			registerRedrawViewsCallback Markerfn
			max preview
			unregisterRedrawViewsCallback Markerfn

			try(
				destroydialog GetNamero
			)
			catch(
				-- pass --
			)
		)

		on Createbtn pressed do 
		(
			CreatPreviewfn()
		)
	)

	createdialog GetNamero 
)
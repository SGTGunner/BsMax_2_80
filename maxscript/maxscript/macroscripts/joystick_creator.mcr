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

macroScript JoystickCreator
	tooltip:"Joystick Creator"
	category:"Animation Tools"
(
	Global Rects = #(), JoyMode = undefined;
	-- Analioze the object on scene and cose compatibles for create joysticks --
	function Scanfn =
	(
		Rects = #()
		TMode = undefined;
		for R in selection do if classof R == Rectangle do (
			if R.children.count == 0 do (
				if R.width == R.length then (
					NewMode = "J"
				)
				else if R.width > R.Length then (
					if R.Length > R.width / 2.0 then (
						NewMode = "J"
					)
					else (
						NewMode = "H"
					)
				)
				else if R.length > R.width then (
					if R.width > R.length / 2.0 then (
						NewMode = "J"
					)
					else (
						NewMode = "V"
					)
				)

				if TMode == undefined then (
					TMode = NewMode
					append Rects R
				)
				else if NewMode == TMode do (
					append Rects R
					break
				)
			)
		)
		Return TMode
	)

	Global TheMode = Scanfn()

	function JoystickCreatorDialog = 
	(
		if selection.count == 0 do (
			return undefined
		)

		TheMode = Scanfn()

		if Rects.count == 0 do (
			return undefined
		)

		select Rects
		R = Rects[1]

		-- detect Mode --
		Global Horizontal = false, Vertival = false
		
		if R.width == R.length then (
			TheMode = "J"
		)
		else if R.width > R.Length then (
			if R.Length > R.width/2.0 then (
				TheMode = "J"
			)
			else (
				TheMode = "H"
			)
		)
		else if R.length > R.width then (
			if R.width > R.length/2.0 then (
				TheMode = "J"
			)
			else (
				TheMode = "V"
			)
		)

		-- Setup a mode selector dialog --
		rollout JoystickCreatorRo ""
		(
			timer clock interval:30
			button ULbt "" width:50 height:50 across:3
			button UCbt "" width:50 height:50
			button URbt "" width:50 height:50
			button MLbt "" width:50 height:50 across:3
			button MCbt "" width:50 height:50
			button MRbt "" width:50 height:50
			button DLbt "" width:50 height:50 across:3
			button DCbt "" width:50 height:50
			button DRbt "" width:50 height:50

			on clock tick do 
			(
				if keyboard.escPressed do (
					destroydialog JoystickCreatorRo
				)
			)

			on JoystickCreatorRo open do
			(
				buttons = #()
				case TheMode of (
					"J": (
						Horizontal = true
						Vertival = true
					)
					
					"H": (
						buttons = #(ULbt, UCbt, URbt, DLbt, DCbt, DRbt)
						Horizontal = true
						Vertival = false
					)

					"V": (
						buttons = #(ULbt, MLbt, DLbt, URbt, MRbt, DRbt)
						Horizontal = false
						Vertival = true
					)
				)
				for b in buttons do (
					b.visible = false
				)
			)

			function CreateJoystickfn Left Right Up Down =
			(
				for Frame in Rects do (
					--## check if another joy avalible delete older one --
					Frame.cornerRadius = if Horizontal and Vertival then (Frame.width + Frame.length) / 15.0 else if Frame.width < Frame.length then Frame.width / 2.0 else  Frame.length / 2.0 -- Round the corners

					-- create handel and gide lines --
					Handel = if Horizontal and Vertival then circle radius:Frame.cornerRadius else circle radius:Frame.cornerRadius--rectangle width:Frame.cornerRadius length:Frame.cornerRadius cornerRadius:(Frame.cornerRadius / 10.0)
					Handel.transform = Frame.transform
					Handel.parent = Frame

					-- set defoult position --
					XL = if Left then Frame.width / 2.0 - Frame.cornerRadius else 0
					XR = if Right then Frame.width / 2.0 - Frame.cornerRadius else 0
					in coordsys Frame Handel.pos.x += XR - XL
					YU = if Down then Frame.Length / 2.0 - Frame.cornerRadius else 0
					YD = if Up then Frame.Length / 2.0 - Frame.cornerRadius else 0
					in coordsys Frame Handel.pos.Y -= YU - YD

					-- Frease Position -- 
					--TODO clera and test this part
					Handel.pos.controller = Position_List()
					Handel.pos.controller.Position_XYZ.controller = bezier_position()
					Handel.pos.controller.setname 1 "Frozen Position"
					Handel.pos.controller.Available.controller = Position_XYZ()
					Handel.pos.controller.setname 2 "Zero Pos XYZ"
					Handel.position.controller.SetActive 2

					-- Frease rotation --
					Handel.rotation.controller = rotation_list()
					Handel.rotation.controller.setname 1 "Frozen Rotation"
					Handel.rotation.controller.Available.controller  = Euler_XYZ()
					Handel.rotation.controller.setname 2 "Zero Euler XYZ"

					-- Create Limite controllers --
					Handel.pos.controller.Zero_Pos_XYZ.controller.X_Position.controller = float_limit()
					Handel.pos.controller.Zero_Pos_XYZ.controller.X_Position.controller.upper_limit = if not Horizontal then 0 else if Left then Frame.width - Frame.cornerRadius * 2 else if Right then 0 else Frame.width / 2 - Frame.cornerRadius
					Handel.pos.controller.Zero_Pos_XYZ.controller.X_Position.controller.lower_limit = if not Horizontal then 0 else -(if Right then Frame.width - Frame.cornerRadius * 2 else if Left then 0 else Frame.width / 2 - Frame.cornerRadius)

					Handel.pos.controller.Zero_Pos_XYZ.controller.Y_Position.controller = float_limit()
					Handel.pos.controller.Zero_Pos_XYZ.controller.Y_Position.controller.upper_limit = if not Vertival then 0 else if Up then 0 else if Down then Frame.Length - Frame.cornerRadius * 2  else Frame.Length / 2 - Frame.cornerRadius
					Handel.pos.controller.Zero_Pos_XYZ.controller.Y_Position.controller.lower_limit = if not Vertival then 0 else -(if Down then 0 else if Up then Frame.Length - Frame.cornerRadius * 2 else Frame.Length / 2 - Frame.cornerRadius)

					Handel.pos.controller.Zero_Pos_XYZ.controller.Z_Position.controller = float_limit()
					Handel.pos.controller.Zero_Pos_XYZ.controller.Z_Position.controller.upper_limit = 0
					Handel.pos.controller.Zero_Pos_XYZ.controller.Z_Position.controller.lower_limit = 0

					-- Setup tools -------------------------------------------------------------------------------------------------------------------
					AttributeHolder = (EmptyModifier ())
					AttributeHolder.name = "Controller"
					Ca = attributes Joystick
					(
						parameters params_pr rollout:params_ro
						(
							Up type:#float range:[0.0,100.0,0.0] ui:Usp
							Down type:#float range:[0.0,100.0,0.0] ui:Dsp
							Left type:#float range:[0.0,100.0,0.0] ui:Lsp
							Rigth type:#float range:[0.0,100.0,0.0] ui:Rsp
						)
						rollout params_ro "Params"
						( 
							Global _ME_ = undefined
							function Connectfn Controller Target =
							(
								if _ME_ == undefined and Target == undefined do (
									return undefined
								)

								Global _TheSpecialTargetNode_ = Target
								hasmorpher = false

								for i in Target.Modifiers do (
									if IsValidMorpherMod i do (
										hasmorpher = true
										break
									)
								)

								if hasmorpher then (
									Local T = #(), Targets = #()
									for i = 1 to 100 do (
										if WM3_MC_GetName Target.morpher i != "- empty -" do (
											append T #(i, WM3_MC_GetName Target.morpher i)
											if T.count >= 10 do (
												append Targets T
												T = #()
											)
										)
										if i == 100 do (
											if T.count > 0 do (
												append Targets T
											)
										)
									)

									Local BtnWidth = 100, BtnHeight = 23
									Local W = Targets.count * (BtnWidth + 5)

									fn GetPos i j BW BH =
									(
										x = ((i - 1) * (BW + 3)) + 5
										y = ((j - 1) * (BH + 3)) + 5
										return [x ,y ] as string
									)

									S = "rollout Connectorro \"Connector\"\n"
									S += "(\n"

									for i = 1 to Targets.count do (
										for j = 1 to Targets[i].count do (
											S += "	Button Btn" + (i * 10 + j) as string + " \""+ Targets[i][j][2] + "\" width:" + BtnWidth as string + " Pos:" + GetPos i j BtnWidth BtnHeight +"\n"
											S += "	on Btn" + (i * 10 + j) as string + " pressed do\n"
											S += "	(\n"
											--S += "		$" + Target.name + ".morpher[" + Targets[i][j][1] as string +"].controller = $" + _ME_.name + ".modifiers[#Controller]." + Controller + ".controller\n"
											S += "		" + "_TheSpecialTargetNode_" + ".morpher[" + Targets[i][j][1] as string +"].controller = $'" + _ME_.name + "'.modifiers[#Controller]." + Controller + ".controller\n"
											S += "		Destroydialog Connectorro\n"
											S += "	)\n"
										)
									)
									S += ")\n"
									S += "createdialog Connectorro width:" + W as string
									execute S
								)
								else (
									-- pass --
								)
							)

							on params_ro open do 
							(
								if selection.count == 1 do (
									_ME_ = selection[1]
								)
							)

							pickbutton Cubt "Up" width:50 across:2 tooltip:"Connect To.." offset:[-15,0]
							spinner Usp "" type:#float range:[0.0,100.0,0.0] width:70 offset:[-30,3] enabled:false

							on Cubt picked Targ do 
							(
								Connectfn "up" Targ
							)

							pickbutton CDbt "Down" width:50 across:2 tooltip:"Connect To.." offset:[-15,0]
							spinner Dsp "" type:#float range:[0.0,100.0,0.0] width:70 offset:[-30,3] enabled:false

							on CDbt picked Targ do 
							(
								Connectfn "down" Targ
							)

							pickbutton CLbt "Left" width:50 across:2 tooltip:"Connect To.." offset:[-15,0]
							spinner Lsp "" type:#float range:[0.0,100.0,0.0] width:70 offset:[-30,3] enabled:false

							on CLbt picked Targ do
							(
								Connectfn "left" Targ
							)
							
							pickbutton CRbt "Right" width:50 across:2 tooltip:"Connect To.." offset:[-15,0] 
							spinner Rsp "" type:#float range:[0.0,100.0,0.0] width:70 offset:[-30,3] enabled:false

							on CRbt picked Targ do 
							(
								Connectfn "rigth" Targ
							)
						)
					)

					custAttributes.add AttributeHolder Ca
					-- Up --
					AttributeHolder.Joystick.Up.controller = Float_script()
					TheLimit = Handel.pos.controller.Zero_Pos_XYZ.Y_position.controller.Limits.Upper_Limit
					AttributeHolder.Joystick.Up.controller.addTarget "Value" Handel.pos.controller.Zero_Pos_XYZ.Y_position.controller
					AttributeHolder.Joystick.Up.controller.Script = "if Value > 0 then (Value / " + TheLimit as string + ") * 100 else 0"
					-- Down --
					AttributeHolder.Joystick.Down.controller = Float_script()
					TheLimit = Handel.pos.controller.Zero_Pos_XYZ.Y_position.controller.Limits.Lower_Limit
					AttributeHolder.Joystick.Down.controller.addTarget "Value" Handel.pos.controller.Zero_Pos_XYZ.Y_position.controller
					AttributeHolder.Joystick.Down.controller.Script =  "if Value < 0 then (Value / " + TheLimit as string + ") * 100 else 0"
					-- Left --
					AttributeHolder.Joystick.Left.controller = Float_script()
					TheLimit = Handel.pos.controller.Zero_Pos_XYZ.X_position.controller.Limits.Lower_Limit
					AttributeHolder.Joystick.Left.controller.addTarget "Value" Handel.pos.controller.Zero_Pos_XYZ.X_position.controller
					AttributeHolder.Joystick.Left.controller.Script =  "if Value < 0 then (Value / " + TheLimit as string + ") * 100 else 0"
					--Right --
					AttributeHolder.Joystick.Rigth.controller = Float_script()
					TheLimit = Handel.pos.controller.Zero_Pos_XYZ.X_position.controller.Limits.Upper_Limit
					AttributeHolder.Joystick.Rigth.controller.addTarget "Value" Handel.pos.controller.Zero_Pos_XYZ.X_position.controller
					AttributeHolder.Joystick.Rigth.controller.Script =  "if Value > 0 then (Value / " + TheLimit as string + ") * 100 else 0"
						
					addModifier Handel AttributeHolder 
					-----------------------------------------------------------------------------------------------------------------------------------
				)
				destroydialog JoystickCreatorRo
			)
			on ULbt pressed do
			(
				CreateJoystickfn true false true false
			)

			on UCbt pressed do 
			(
				CreateJoystickfn false false true false
			)

			on URbt pressed do 
			(
				CreateJoystickfn false true true false
			)

			on MLbt pressed do 
			(
				CreateJoystickfn true false false false
			)

			on MCbt pressed do 
			(
				CreateJoystickfn false false false false
			)

			on MRbt pressed do 
			(
				CreateJoystickfn false true false false
			)

			on DLbt pressed do 
			(
				CreateJoystickfn true false false true
			)

			on DCbt pressed do 
			(
				CreateJoystickfn false false false true
			)

			on DRbt pressed do 
			(
				CreateJoystickfn false true false true
			)

		)
		createdialog JoystickCreatorRo width:190 --style:#()
	)

	if Rects.count > 0 then (
		JoystickCreatorDialog()
	)
	else (
		rollout JoystickConnectorro "Joystick Creator"
		(
			button Convertobtn "Convert to Joystick" width:150
			on Convertobtn pressed do JoystickCreatorDialog()
			button MorphTargetPickerbtn "Morph Target Picker" width:150
			on MorphTargetPickerbtn pressed do
			(
				rollout MorphargetPicker "Morph Target Picker"
				(
					pickbutton pickmasterpbtn "Pick Master" autoDisplay:true width:150
					label Msglb ""
					button selectionorderbtn "By Selection Order" enabled:false width:150
					button Alphbetorcerbtn "By Alphabet Order" enabled:false width:150
					button DistanceOrder "By Distance Order" enabled:false width:150
					function PickMaster Obj =
					(
						if superclassof Obj.baseobject == GeometryClass then (
							pickmasterpbtn.object = Obj
							Msglb.caption = "Select the targets now"
							selectionorderbtn.enabled = true
							Alphbetorcerbtn.enabled = true
							DistanceOrder.enabled = true
						)
						else (
							pickmasterpbtn.object = undefined
							Msglb.caption = "	Pick a Geometry Object"
							selectionorderbtn.enabled = false
							Alphbetorcerbtn.enabled = false
							DistanceOrder.enabled = false
						)
					)

					on pickmasterpbtn picked obj do 
					(
						PickMaster Obj
					)

					on pickmasterpbtn rightclick do 
					(
						if selection.count == 1 do (
							PickMaster selection[1]
						)
					)

					function AddMorpher obj =
					(
						hasmorpher = false
						for i in pickmasterpbtn.object.Modifiers do (
							if IsValidMorpherMod i do (
								hasmorpher = true 
							)
						)

						if not hasmorpher do (
							addModifier pickmasterpbtn.object (Morpher())
						)
					)

					function NextEmptySlot Obj =
					(
						index = 1
						for i = 100 to 1 by -1 do (
							if WM3_MC_GetTarget Obj.morpher i == undefined do (
								index = i
								break
							)
						)
						return index
					)

					on selectionorderbtn pressed do
					(
						AddMorpher pickmasterpbtn.object
						local Targets = #()
						for Sel in selection do (
							append Targets Sel
						)

						for T in Targets do (
							index = NextEmptySlot pickmasterpbtn.object
							WM3_MC_BuildFromNode pickmasterpbtn.object.morpher index T
						)
					)

					on Alphbetorcerbtn pressed do
					(
						AddMorpher pickmasterpbtn.object
						local SelectedTargets = #(), Targets = #(), Names = #();
						for Sel in selection do (
							append SelectedTargets Sel
							append Names Sel.name
						)

						sort Names

						for N in Names do (
							for ST in SelectedTargets do (
								if ST.Name == N do (
									append Targets ST
									break
								)
							)
						)

						for T in Targets do (
							index = NextEmptySlot pickmasterpbtn.object
							WM3_MC_BuildFromNode pickmasterpbtn.object.morpher index T
						)
					)

					on DistanceOrder pressed do
					(
						AddMorpher pickmasterpbtn.object
						local Targets = #()
						for Sel in selection do (
							append Targets Sel
						)

						for i = 1 to Targets.count do
						(
							Local Dist = Distance pickmasterpbtn.object Targets[i]
							Local index = i

							for j = i + 1 to Targets.count do (
								if Distance pickmasterpbtn.object Targets[j] < Dist do (
									index = j
								)
							)

							if index > i do (
								T = Targets[index]
								DeleteItem Targets index
								InsertItem T Targets i
							)
						)

						for T in Targets do (
							index = NextEmptySlot pickmasterpbtn.object
							WM3_MC_BuildFromNode pickmasterpbtn.object.morpher index T
						)
					)
				)
				createdialog MorphargetPicker
				destroydialog JoystickConnectorro
			)
		)
		createdialog JoystickConnectorro
	)
)
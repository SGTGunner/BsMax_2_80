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

macroScript MorpherConnector
	tooltip:"Morpher Connector"
	category:"Rigging Tools"
(
	rollout MorpherConnectorRO "Morph Chanel Connector"
	(
		local Leftlist = #(), RightList = #()
		pickbutton leftpbtn "Pic object"  width:120 height:30 align:#Left autoDisplay:true across:2
		pickbutton rightpbtn "Pic object"  width:120 height:30 align:#Right autoDisplay:true
		listbox leftlb "" width:120 height:30 align:#Left across:2
		listbox Righttlb "" width:120 height:30 align:#Right
		button CLtRbtn ">" width:25 align:#Center offset:[0, -leftlb.height ] tooltip:"Copy Left to Right"
		button CRtLbtn "<"  width:25 align:#Center tooltip:"Copy Right to Left"
		button ILtRbtn ":>"  width:25 align:#Center tooltip:"Instance left to Right"
		button IRtLbtn "<:"  width:25 align:#Center tooltip:"Instance Right to Left"

		function GetMTList Obj =
		(
			local hasmorpher = false, Targets = #()
			for i in Obj.Modifiers do (
				if IsValidMorpherMod i do (
					hasmorpher = true
					break
				)
			)

			if hasmorpher do (
				Local T = #()
				for i = 1 to 100 do (
					if WM3_MC_GetName Obj.morpher i != "- empty -" do (
						append T #(i, (i as string + ":" + WM3_MC_GetName Obj.morpher i))
						if T.count >= 10 do ( 
							join Targets T
							T = #()
						)
					)
					if i == 100 do (
						if T.count > 0 do (
							join Targets T
						)
					)
				)
			)

			return Targets
		)
		
		function connector Obj1 Obj2 Ind1 Ind2 Mode =
		(
			if Obj1 != undefined and Obj2 != undefined and Ind1 > 0 and Ind2 > 0 do (
				case Mode of (
					"copy": (
						Obj2.morpher[Ind2].controller = copy Obj1.morpher[Ind1].controller
					)

					"instance": (
						Obj2.morpher[Ind2].controller = Obj1.morpher[Ind1].controller
					)
				)
			)
		)
		
		on leftpbtn picked obj do
		(
			LeftObj = leftpbtn.object
			if LeftObj != undefined do (
				Leftlist = GetMTList LeftObj
				leftlb.items = for n in Leftlist collect n[2]
			)
		)
		
		on rightpbtn picked obj do
		(
			RightObj = rightpbtn.object
			if RightObj != undefined do (
				RightList = GetMTList RightObj
				Righttlb.items = for n in RightList collect n[2]
			)
		)
		
		on CLtRbtn pressed do
		(
			connector leftpbtn.object rightpbtn.object leftlb.selection Righttlb.selection "copy"
		)

		on CRtLbtn pressed do
		(
			connector rightpbtn.object leftpbtn.object Righttlb.selection leftlb.selection "copy"
		)

		on ILtRbtn pressed do
		(
			connector leftpbtn.object rightpbtn.object leftlb.selection Righttlb.selection "instance"
		)

		on IRtLbtn pressed do
		(
			connector rightpbtn.object leftpbtn.object Righttlb.selection leftlb.selection "instance"
		)
	)

	Createdialog MorpherConnectorRO width:300
)
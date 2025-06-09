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

macroScript HISolver
	tooltip:"HI Solver"
	category:"BsMax Tools"
(
	function getmasterandtarget_fn =
	(
		local masterbone = undefined, targetbone = undefined
		if selection.count == 1 do (
			if classof selection[1] == BoneGeometry or (filterstring (selection[1] as string) "$:")[1] == "Bone" do (
				masterbone = selection[1]
				targetbone = masterbone.children[1]
				while true do (
					if targetbone.children.count == 1 then (
						targetbone = targetbone.children[1]
					)
					else(
						exit
					)
				)
			)
		)

		if selection.count == 2 do
		(
			local A = selection[1], B = selection[2]
			while true do (
				if A.parent == undefined then (
					exit
				)
				else if A.parent == B then (
					targetbone = selection[1]; masterbone = selection[2]
					exit
				)
				else (
					A = A.parent
				)
			)

			while true do (
				if B.parent == undefined then(
					exit
				)
				else if B.parent == A then (
					targetbone = selection[2]
					masterbone = selection[1]
					exit
				)
				else (
					B = B.parent
				)
			)
		)
		return #(masterbone, targetbone)
	)

	function listofbones_fn =
	(
		local retval = #()
		local MT = getmasterandtarget_fn()
		local masterbone = MT[1], targetbone = MT[2]
		local currentbone = masterbone
		if masterbone != undefined and targetbone != undefined do (
			while true do (
				if currentbone.children[1] != targetbone then (
					append retval currentbone
					currentbone = currentbone.children[1]
				)
				else(
					append retval currentbone; append retval targetbone
					exit
				)
			)
		)

		return retval
	)

	if selection.count != 0 do (
		local Mybone = listofbones_fn()
		local MT = getmasterandtarget_fn()
		local masterbone = MT[1]; targetbone = MT[2]
		if masterbone == undefined and targetbone == undefined then (
			local parents = (
				for i in selection where i.children.count == 1 and (filterstring (i.children[1] as string) "$:")[1] == "Bone" collect i
			)
			
			local IKS = #()

			for i in parents do (
				select i
				Mybone = listofbones_fn()
				MT = getmasterandtarget_fn()
				masterbone = MT[1]
				targetbone = MT[2]

				if masterbone != undefined and targetbone != undefined then (
					local NewIK = IKSys.ikChain masterbone targetbone "IKHISolver"
					try(
						NewIK.transform.controller.VHTarget = upnode_pb.object
					)
					catch(
						-- pass --
					)

					append IKS NewIK
				)
			)
			select IKS
		)
		else (
			NewIK = IKSys.ikChain masterbone targetbone "IKHISolver"
			try(
				NewIK.transform.controller.VHTarget = upnode_pb.object
			)
			catch(
				-- pass --
			)
			select NewIK
		)
	)
)
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

/*########################################################################
# Transfer Camera with keyframes from 3dsMax to Blender
# 1.select camera in 3DsMax
# 2.execute this script
# 	some data will copy to windows clipboard
# 3.in blender script editor
# 4.past the python script text from clipboard
# 5.run the script
#	same camera with same key frames will recreate in blender
#
# Note: for now key types do not transfer.
########################################################################*/
-- 2025/05/06 --

macroscript camera_movment_catcher_mcr
	buttonText:"Camera Movment Catcher"
	category:"BsMax Tools"
(
	function camera_movment_catcher =
	(
		--TODO if no selection try to get scene active camera
		if selection.count != 1 do (
			return undefined
		)

		if superclassof selection[1] != camera do (
			return undefined
		)

		function Compartransform Tr1 Tr2 =
		(
			function ComparP3 P1 P2 Tol =
			(
				function ComparF F1 F2 Tol =
				(
					-- TODO check this function --
					if F1 != F2 do (
						Heigher = undefined
						Lower = undefined

						if F1 >= F2 then (
							Heigher = F1
							Lower = F2
						)
						else (
							Heigher = F2
							Lower = F1
						)

						return Heigher <= Lower + Tol
					)
					return True
				)

				local X = ComparF P1.x P2.x Tol
				local Y = ComparF P1.y P2.y Tol
				local Z = ComparF P1.z P2.z Tol

				return  (X and Y and Z)
			)

			if Tr1 != undefined and Tr2 != undefined do (
				local P1 = Tr1.Pos, P2 = Tr2.Pos
				local Q1 = quatToEuler Tr1.rotation order:1
				local Q2 = quatToEuler Tr2.rotation order:1
				local CP = P1 == P2
				local CQ = ComparP3 Q1 Q2 (0.01) -- <-- Tolerance Value
				return (CP and CQ)
			) 
			return False
		)

		----------------------------------------------------------------------------------------
		local Cam = selection[1], OldCamTransfirm, OldTargTransfirm, Frames = #()
		
		for T = animationRange.start to animationRange.end do (
			at time T (
				NewCamTransfirm = at time T Cam.transform
				if not Compartransform OldCamTransfirm NewCamTransfirm do (
					appendifunique Frames ((T as string) as integer)
				)
				OldCamTransfirm = NewCamTransfirm
			)
		)

		local Str = ""
		append Frames Frames[Frames.count]
		for i = 1 to Frames.count - 1 do (
			if Frames[i] >= 0 then (
				if (Frames[i] + 1 == Frames[i + 1]) then (
					if Str[Str.count] != "-" do (
						if Str.count > 0 and Str[Str.count] != "," do (
							Str += ","
						)

						Str += Frames[i] as string + "-"
					)
				)
				else (
					if Str.count > 0 and Str[Str.count] != "-" and Str[Str.count] != "," do (
						Str += ","
					)

					Str += Frames[i] as string
				)
			)
			else (
				-- Negative numbers not saported on Frames render and have to ignored --
				--if Str.count > 0 and Str[Str.count] != "," do Str += ","
				--Str += Frames[i] as string
			)
		)

		-- write frame list on render output --
		renderSceneDialog.close()
		rendTimeType  = 4
		rendPickupFrames = Str
		renderSceneDialog.open()
	)

	camera_movment_catcher()
)
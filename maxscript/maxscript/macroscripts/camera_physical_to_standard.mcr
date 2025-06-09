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
-- 2025/05/06 --

macroscript physical_camera_convertor_mcr
	buttonText:"Physical Camera to Standard"
	category:"BsMax Tools"
(
	function convert_to_standard_camera cam =
	(
		-- ignore of camera is not pysical --
		if classof cam != Physical do 
			return False

		-- Create a temprary camera --
		new_cam = undefined
		if cam.targeted then (
			new_cam = Targetcamera wirecolor:Cam.wirecolor
		)
		else (
			new_cam = Freecamera wirecolor:C.wirecolor
		)

		-- copy FOV key frames --
		if classof cam.fov.controller == bezier_float do (
			fov_controller = new_cam.fov.controller
			fov_controller = bezier_float()
			for key in cam.fov.controller.keys do (
				fov_controller = 
				NewKey = addNewKey fov_controller K.time
				NewKey.value  = Key.value
			)
		)

		-- repalece new cam darta with the old cam data --
		cam.baseobject = new_cam.baseobject

		-- eremove the Phys from camera name --
		if findString $.name "Phys" != undefined do (
			S = (findString $.name "Phys") + 4 
			cam.name = substring cam.name s cam.name.count
		)

		-- delete the temprary camera --
		delete new_cam
	)

	for cam in Cameras do (
		convert_to_standard_camera cam
	)
)
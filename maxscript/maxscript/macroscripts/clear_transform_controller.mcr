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

macroScript ClearTransformControllers tooltip:"Clear Transform Controllers" category:"Rigging Tools"
(
	local Objs = selection

	for Obj in Objs do (

		local OrigTransform = Obj.transform

		try(
			Obj.Transform.controller = prs()
		)catch()
		
		try(
			Obj.pos.controller = Position_XYZ()
		)catch()

		try(
			Obj.pos.controller.X_Position.controller = bezier_float()
		)catch()

		try(
			Obj.pos.controller.Y_Position.controller = bezier_float()
		)catch()

		try(
			Obj.pos.controller.Z_Position.controller = bezier_float()
		)catch()

		try(
			Obj.rotation.controller = Euler_XYZ()
		)catch()

		try(
			Obj.rotation.controller.X_Rotation.controller = bezier_float()
		)catch()

		try(
			Obj.rotation.controller.Y_Rotation.controller = bezier_float()
		)catch()

		try(
			Obj.rotation.controller.Z_Rotation.controller = bezier_float()
		)catch()

		try(
			Obj.scale.controller = bezier_scale()
		)catch()

		try(
			Obj.transform = OrigTransform
		)catch()
	)
)
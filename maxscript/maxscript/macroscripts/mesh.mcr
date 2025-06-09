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

macroscript turn_to_mesh_if_need
	buttonText:"Turn to Mesh if need"
	category:"BsMax Tools" 
(
	function turn_to_mesh_if_needed =
	(
		for obj in selection do (

			if superclassof obj != GeometryClass do (
				continue
			)

			if ClassOf obj == Editable_mesh do (
				continue
			)
			addModifier Obj (Turn_to_Mesh()) 
		)
	)

	turn_to_mesh_if_needed()
)
print "Turn to Mesh if need installed"

macroscript turn_to_poly_if_need
	buttonText:"Turn to Poly if need"
	category:"BsMax Tools" 
(
	function turn_to_poly_if_needed =
	(
		for obj in selection do (

			if superclassof obj != GeometryClass do (
				continue
			)

			if ClassOf obj == PolyMeshObject do (
				continue
			)
			addModifier Obj (Turn_to_Poly()) 
		)
	)

	turn_to_poly_if_needed()
)
print "Turn to Poly if need installed"
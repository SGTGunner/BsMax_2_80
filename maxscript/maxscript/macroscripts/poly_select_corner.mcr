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

macroScript poly_corner_edge_select_mcr
    tooltip:"Corner Edge Select"
    category:"Modeling Tools" 
(
	--Hid un hid in meno have to add---
	--################################
	-- has to be fix
	--################################

    if selection.count == 1 do (
		obj = Selection[1]

        if classof obj == Editable_Poly and subobjectLevel == 2 do (
			VC = Polyop.getNumVerts obj
			SelectArray = #()

            for i = 1 to VC do (
				V = (polyop.getEdgesUsingVert obj i) as array;
				if V.count == 3 do append SelectArray i;
			)

            polyop.setVertSelection obj SelectArray
			obj.EditablePoly.ConvertSelection #Vertex #Edge
			obj.EditablePoly.SelectEdgeLoop()
		)
	)
)
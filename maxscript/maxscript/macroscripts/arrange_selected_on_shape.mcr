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
-- 2025/05/08 --

macroscript arrange_on_shape
	buttonText:"Arrange Selected on shape"
	category:"BsMax Tools" 
(
	Local selected_objects = Selection

    function shape_filter obj =
    (
        return superClassOf obj == Shape
    )

    if selected_objects.count > 0 do (
        obj = pickObject message:"Now Get a Shap Object" filter:shape_filter
    )
	
    if obj != undefined do (
        undo on (
            --## TODO create 2 method for open and close splines ---
            Local pos = point pos:[0,0,0] 
            Pos.pos.controller = Path_Constraint()
            Pos.pos.controller.follow = on
            Pos.pos.controller.path = obj

            for i = 1 to S.count do (	
                Pos.pos.controller.percent = (100.0 / (S.count - 1)) * (i - 1)
                --S[i].pos = Pos.pos
                selected_objects[i].transform = Pos.transform
            )

            Delete Pos
        )
    )
)
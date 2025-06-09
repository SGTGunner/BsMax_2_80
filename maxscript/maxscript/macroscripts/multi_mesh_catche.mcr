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

macroScript MultiMeshCache tooltip:"Multi Mesh Cache" category:"Animation Tools"
(
	if selection.count > 0 do (
		slidertime = 0
		OrigObjs = selection as array
		NewObjs = #()
		maxOps.CloneNodes OrigObjs cloneType:#instance newNodes:&NewObjs
		select NewObjs
		macros.run "Modifier Stack" "Convert_to_Mesh"
		NewNode = NewObjs[1]
		local OrigTransform = NewNode.transform
		try(
            NewNode.Transform.controller = prs()
        )catch()

        try(
            NewNode.pos.controller = Position_XYZ()
        )catch()

        try(
            NewNode.pos.controller.X_Position.controller = bezier_float()
        )catch()

        try(
            NewNode.pos.controller.Y_Position.controller = bezier_float()
        )catch()

        try(
            NewNode.pos.controller.Z_Position.controller = bezier_float()
        )catch()

        try(
            NewNode.rotation.controller = Euler_XYZ()
        )catch()

        try(
            NewNode.rotation.controller.X_Rotation.controller = bezier_float()
        )catch()

        try(
            NewNode.rotation.controller.Y_Rotation.controller = bezier_float()
        )catch()

        try(
            NewNode.rotation.controller.Z_Rotation.controller = bezier_float()
        )catch()

        try(
            NewNode.scale.controller = bezier_scale()
        )catch()

        try(
            NewNode.transform = OrigTransform
        )catch()

        NewNode.Parent = Undefined	
		NewNode.transform = OrigTransform
		NewNode.name += "_PCache"
		deleteItem NewObjs 1
		addModifier NewNode (Edit_Poly())
		select NewNode
		setCommandPanelTaskMode #modify
		NewNode.modifiers[#Edit_Poly].AttachList NewObjs
		addModifier NewNode (Edit_Mesh())
		maxOps.CollapseNode NewNode true

        --addModifier NewNode (ProOptimizer())
		addModifier NewNode (Skin_Wrap())
		NewNode.modifiers[#Skin_Wrap].engine = 0
		NewNode.modifiers[#Skin_Wrap].meshList = OrigObjs
		addModifier NewNode (Point_Cache())
	)
)
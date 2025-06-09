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

-- Cat Mesh Selectior --
-- TODO make it auto select custom rigg mash layer too --

macroScript mesh_layer_selector_mcr
	tooltip:"Mesh Layer Select"
	category:"BsMax Tools"
(
	MeshLayers = #()
	MeshObjs = #()

	fn GetMaster Layer =
	(
		Ret = undefined
		while true do (
			LP = Layer.getParent()
			if LP != undefined then (
				Ret = LP
				Layer = LP
			)
			else (
				exit
			)
		)
		return ret
	)

	fn HasSkin Obj =
	(
		local result = false
		for m in Obj.modifiers do (
			if classof m == Skin do (
				result = true
				exit
			)
		)
		return result
	)

	fn FindSkin Objs =
	(
		local result = false
		for o in Objs do (
			if HasSkin o do (
				result = true
				exit
			)
		)
		return result
	)

	-- TODO create a beter method to get all characters --

	CatParents = (
		for obj in helpers where classof obj == CATParent collect obj
	)

	for C in CatParents do (
		MasterLayer = GetMaster C.Layer
		for i = 1 to MasterLayer.getNumChildren() do (
			M = MasterLayer.getChild i
			M.Nodes &objs
			if FindSkin objs do (
				append MeshLayers M
				exit
			)
		)
	)

	for M in MeshLayers do (
		M.Nodes &objs
		join MeshObjs objs
	)
	
	select MeshObjs
)
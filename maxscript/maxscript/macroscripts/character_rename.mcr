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
-- 2025/05/14 --
--TODO

-- macroScript CharacterRenamer
-- 	tooltip:"Character Renamer"
-- 	category:"Rigging Tools"
-- (
	rollout CharacterRenamerro "Character renamer"
	(
		radiobuttons mode_rb "" labels:#("Layer", "Scene", "Selection")
		edittext Newnameet ""
		button Reaname "Rename"

		function Newnamefn old_name =
		(
			NewName = ""
			Res = findstring old_name "_"
			if Res == undefined then
				NewName = Newnameet.text + "_" + old_name
			else (
				KeepPart = substring old_name Res old_name.count
				NewName = Newnameet.text + KeepPart )
			return NewName
		)

		function get_objects =
		(
			if mode_rb.state == 1 do
				return #()
			
			if mode_rb.state == 2 do
				return objects as array
			
			return selection as array
		)

		function get_layers =
		(
			layers = #()
			fn getAllSubLayers layer collectedLayers =
			(
				for child in layer.children do (
					append collectedLayers child
					getAllSubLayers child collectedLayers
				)
				return collectedLayers
			)

			layers = getAllSubLayers (LayerManager.current) layers

			for layer in layers do print layer
		)

		on Reaname pressed do
		(
			layers = get_layers()
			Objs = get_objects()

			-- if Newnameet.text != "" do
			-- 	undo on
			-- 		for o in Objs do
			-- 			o.name = Newnamefn o.name
		)
	)

	createdialog CharacterRenamerro
-- )
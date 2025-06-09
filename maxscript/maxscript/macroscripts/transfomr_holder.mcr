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

macroscript transform_holder_mcr
    tooltip:"Transform Holder"
    category:"Animation Tools"
(
	rollout TransformHolderRO "Transform Holder"
	(
		Global Transforms = #()
        Global Objs = #()

        button GetTransformbt "Get Selected transform" width:150
		button SetTransformbt "Set Transfrom" width:150

        on GetTransformbt pressed do
		(
			Transforms = #()
			Objs = #()
			for i in selection do (
				append Transforms i.transform
				append Objs i
			)
		)

        on SetTransformbt pressed do
        (
			for i = 1 to Objs.count do (
				try(
                    Objs[i].transform = Transforms[i]
                )
                catch(
                    -- pass --
                )
            )
        )
	)

    createdialog TransformHolderRO
)
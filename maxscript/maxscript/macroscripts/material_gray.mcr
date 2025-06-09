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

macroScript gray_matt_mcr
    tooltip:"Gray Matt"
    category:"BsMax Tools" 
(
	on isVisible do (
        selection.count > 0
    )

    on execute do (
		$.wirecolor = color 0 0 0

        if classof $ == editable_poly do (
            $.cageColor = color 128 128 128
        )

        $.material = meditMaterials[24]

        meditMaterials[24].name = "Gray"
	)
)
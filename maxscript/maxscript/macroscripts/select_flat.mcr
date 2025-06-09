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

macroScript FlatSelect
	tooltip:"Select Flat"
	category:"Modeling Tools"
(	
	--## TODO Nedd to update
	on isVisible do
	(
		classof $ == Editable_Poly
	) 

	on isChecked do
	(
		$.SelectByAngle == on and $.ignoreBackfacing == on
	)

	on execute do
	(
		if  $.SelectByAngle == on then (
			$.SelectByAngle = off
			$.ignoreBackfacing = off
		)
		else (
			$.SelectByAngle = on
			$.ignoreBackfacing = on
		)

		$.selectAngle = 45
	)
)
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

macroScript pivot_tools_mcr
    tooltip:"Pivot Tools"
    category:"BsMax Tools"
(
	try(
        destroydialog pivottoolsro
    )
    catch(
        -- pass --
    )

    rollout pivottoolsro ""
	(
		--checkbutton apobt "Affect Pivot Only" width:150
		button topcenterbt "Top Center" width:150
        button centerbt "Center" width:150
        button butcenterbt "Button Center" width:150
        button cancelbt "Exit" width:150

        on topcenterbt pressed do 
		(
			for i in selection do (
				i.pivot.x = i.center.x
				i.pivot.y = i.center.y
				i.pivot.z = i.max.z
			)
		)
		
		on centerbt pressed do
        (
            for i in selection do (
                i.pivot = i.center
            )
        )
		
		on butcenterbt pressed do 
		(
			for i in selection do (
				i.pivot.x = i.center.x
				i.pivot.y = i.center.y
				i.pivot.z = i.min.z
			)
		)
		
		on cancelbt pressed do 
        (
            destroydialog pivottoolsro
        )
	)

    createdialog pivottoolsro style:#() pos:mouse.screenpos
)

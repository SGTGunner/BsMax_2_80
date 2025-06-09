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
-- 2025/05/15 --

macroscript display_silhouate_toggle_mcr
	buttonText:"Display Silhouate Toggle"
	category:"BsMax Tools"
(
	isactivesilhouate = false

	for i in objects do (
		if getCVertMode i do (
			isactivesilhouate = true
			exit
		)
	)

	if isactivesilhouate then (
		for o in geometry do (
			setCVertMode o false
		)
		viewPort.setGridVisibility viewport.activeViewport true
	)
	else (
		for o in geometry do (
			setCVertMode o true
		)
		viewPort.setGridVisibility viewport.activeViewport false
	)

	redrawViews()
)
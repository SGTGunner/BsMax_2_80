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

macroscript jump_to_previous_keyframe_mcr
    tooltip:"Previous Key"
    category:"BsMax Tools" 
(
	if keyboard.controlPressed then (
		if trackbar.getPreviousKeyTime() != undefined do (
			slidertime = trackbar.getPreviousKeyTime()
		)
	)
	else if keyboard.shiftPressed then (
		newtime = 	slidertime - 5
		if newtime < animationRange.start do (
			animationrange = interval newtime animationRange.end
		)
		slidertime -= 5
	)
	else if keyboard.altPressed then (
		animationrange = interval slidertime animationRange.end
	)
	else (
		newtime = slidertime - 1
		if newtime < animationRange.start then (
			slidertime = animationRange.end
		)
		else(
			slidertime -= 1
		)
	)
)

macroscript jump_to_next_keyframe_mcr
	tooltip:"Next Key"
	category:"Animation Tools" 
(
	if keyboard.controlPressed then (
		if trackbar.getnextKeyTime() != undefined do (
			slidertime = trackbar.getnextKeyTime()
		)
	)
	else if keyboard.shiftPressed then
	(
		newtime = 	slidertime + 5
		if newtime > animationRange.end do (
			animationrange = interval animationRange.start newtime
		)
		slidertime += 5
	)
	else if keyboard.altPressed then (
		animationrange = interval animationRange.start slidertime
	)
	else 
	(
		newtime = slidertime + 1
		if newtime > animationRange.end then (
			slidertime = animationRange.start
		)
		else (
			slidertime += 1
		)
	)
)
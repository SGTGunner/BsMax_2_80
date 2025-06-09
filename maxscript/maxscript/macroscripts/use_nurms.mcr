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

macroScript UseNSonoff
	tooltip:"Use Nurms 1"
	category:"BsMax Tools"
(
	if classof $ == Editable_Poly do (
		if $.surfSubdivide == true then (
			if $.iterations != 1 then (
				$.iterations = 1
			)
			else (
				$.surfSubdivide = off
			)
		)
		else(
			$.surfSubdivide = on
			$.iterations = 1
		)
	)
)

macroScript UseNSon2
	tooltip:"Use Nurms 2"
	category:"BsMax Tools"
(
	if classof $ == Editable_Poly do (
		if $.surfSubdivide == true then (
			if $.iterations != 2 then (
				$.iterations = 2
			)
			else (
				$.surfSubdivide = off
			)
		)
		else (
			$.surfSubdivide = on
			$.iterations = 2
		)
	)
)

macroScript UseNSon3
	tooltip:"Use Nurms 3"
	category:"BsMax Tools"
(
	if classof $ == Editable_Poly do (
		if $.surfSubdivide == true then (
			if $.iterations != 3 then (
				$.iterations = 3
			)
			else (
				$.surfSubdivide = off
			)
		)
		else(
			$.surfSubdivide = on
			$.iterations = 3
		)
	)
)
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

macroScript selection_set_mcr
	tooltip:"Selection Set"
	category:"BsMax Tools"
(
	rollout Selectionro "Selection Set"
	(
		local items = #(#(), #(), #())

		button Set1 "-" width:150
		button Set2 "-" width:150
		button Set3 "-" width:150
		button Set4 "-" width:150
		button Set5 "-" width:150

		local Btns = #(Set1, Set2, Set3, Set4, Set5)

		function setfn index =
		(
			items[index] = #()
			for S in selection do (
				append items[index] S
			)

			if selection.count > 0 do (
				Btns[index].caption = selection.count as string + " obj(s)"
			)
		)

		function getfn index = (
			try(
				select items[index]
			)
			catch(
				items[index] = #()
				Btns[index].caption = "-"
			)
		)

		on Set1 pressed do
		(
			getfn 1
		)

		on Set1 rightclick do
		(
			setfn 1
		)

		on Set2 pressed do
		(
			getfn 2
		)

		on Set2 rightclick do
		(
			setfn 2
		)

		on Set3 pressed do
		(
			getfn 3
		)

		on Set3 rightclick do
		(
			setfn 3
		)

		on Set4 pressed do
		(
			getfn 4
		)

		on Set4 rightclick do
		(
			setfn 4
		)

		on Set5 pressed do
		(
			getfn 5
		)

		on Set5 rightclick do
		(
			setfn 5
		)
	)
	createdialog Selectionro
)
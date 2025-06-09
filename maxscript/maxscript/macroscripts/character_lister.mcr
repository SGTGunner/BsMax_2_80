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

macroscript CharacterBaseLister
    tooltip:"Character Base Lister"
    category:"Animation Tools"
(
	rollout CBC_ro "Base Lister"
	(
		listbox Blist_lb ""

        on CBC_ro open do
		(
			Barray = #()
			for i in shapes do (
				S = filterstring i.name "_"
				if S.count == 3 do (
					if S[2] == "C" and tolower S[3] == "base" do (
						append Barray i.name
                    )
                )
			)

            Blist_lb.items = Barray
		)

        on Blist_lb selected arg do
		(
			execute("select $" + Blist_lb.selected)
			destroydialog CBC_ro

        )
	)

    createdialog CBC_ro
)
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

macroscript add_note_modifier_mcr
	Tooltip:"Add Note Modifier"
	category:"BsMax Tools"
(
	NoteModifier = (EmptyModifier ())
	NoteModifier.name = "Note"
	addModifier selection NoteModifier 
	ca = attributes addNoteAttribute
	(
		parameters params_pr rollout:params_ro
		(
			note type:#string ui:note_et
		)

		rollout params_ro "Note"
		( 
			edittext note_et "" pos:[-1,3] width:160 height:500
		)
	)

	for i in selection do (
		custAttributes.add i.modifiers[#Note] ca
	)
)
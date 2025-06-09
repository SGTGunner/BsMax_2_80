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

macroScript RSProxyRenew
	tooltip:"ReNew RS Proxy"
	category:"BsMax Tools"
(	
	if classof $ == proxy do (
		old = selection[1]
		new = proxy pos:[0,0,0] isSelected:on
		new.gizmoscale = old.gizmoscale
		new.file = old.file
		new.displaymode = old.displaymode
		new.linkedmesh = old.linkedmesh
		new.displaypct = old.displaypct
		new.issequence = old.issequence
		new.startframe = old.startframe
		new.endframe = old.endframe
		new.pattern = old.pattern
		new.frameoffset = old.frameoffset
		new.outofrangemode = old.outofrangemode
		new.materialmode = old.materialmode
		new.namematchprefix = old.namematchprefix
		new.overrideobjectid = old.overrideobjectid
		new.overridevisibility = old.overridevisibility
		new.overridetessdisp = old.overridetessdisp
		new.overridetracesets = old.overridetracesets
		new.overrideuserdata = old.overrideuserdata
		
		new.transform = old.transform
		new.gbufferchannel = old.gbufferchannel
		new.name = old.name
		old.name += "_old"
		select old
	)
)
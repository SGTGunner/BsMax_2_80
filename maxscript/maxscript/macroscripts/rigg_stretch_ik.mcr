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

macroScript stretck_ik_mcr
    tooltip:"Make Stretch IK"
    category:"BsMax Tools"
(	
	local IKS = (for i in selection where classof i == IK_Chain_Object collect i)

    for i in IKS do (
		mode = ""
		if i.transform.controller[1] as string == "SubAnim:Swivel_Angle" do (
            mode = "HIK"
        )

        if i.transform.controller[1] as string == "SubAnim:Twist_Start_Angle" do (
            mode = "SPIK"
        )

        if mode == "HIK" then (
			select #(i.transform.controller.startJoint,i.transform.controller.endJoint)
			Mybone = listofbones_fn()
			XreftoXYZ_fn Mybone
			bsize = #()
            orig = 0

            for j = 1 to Mybone.count-1 do (
                append bsize (distance Mybone[j] Mybone[j+1])
            )
			
            for j = 1 to bsize.count do (
                orig += bsize[j]
            )

            for j = 2 to Mybone.count do (
				mynewcontroller = float_script()
				mynewcontroller.AddNode "start" Mybone[1]
				mynewcontroller.AddNode "end" i
				myscript = "orig = " + orig as string + "\n"
				myscript += "D = distance start.pos end.pos\n"
				myscript += "if D > orig then xpos = " + bsize[j-1] as string + " + ((D - orig)/ "+ (Mybone.count-1) as string +")\n"
				myscript += "else xpos = "  + bsize[j-1] as string
				mynewcontroller.script = myscript
				Mybone[j].transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller = mynewcontroller
			)
		) 
		else if mode == "SPIK" then
		(
			select #(i.transform.controller.startJoint,i.transform.controller.endJoint)
			Mybone = listofbones_fn()
			XreftoXYZ_fn Mybone
			myspline = i.transform.controller.startJoint.position.controller.path_constraint.path
			bsize = #(); orig = curveLength myspline;

            for j = 1 to Mybone.count-1 do (
                append bsize (distance Mybone[j] Mybone[j+1])
            )

            for j = 1 to bsize.count do (
                orig += bsize[j]
            )

            for j = 2 to Mybone.count do (
				mynewcontroller = float_script()
				mynewcontroller.AddNode "start" Mybone[1]
				mynewcontroller.AddNode "end" i
				mynewcontroller.AddNode "spline" myspline
				myscript = "orig = " + (orig / 2) as string + "\n"
				myscript += "D = curveLength spline\n"
				myscript += "if D > orig then xpos = " + bsize[j-1] as string + " + ((D - orig)/ "+ (Mybone.count-1) as string +")\n"
				myscript += "else xpos = "  + bsize[j-1] as string
				mynewcontroller.script = myscript
				Mybone[j].transform.controller.FK_Sub_Control.controller.Position.controller.X_Position.controller = mynewcontroller
			)

            thepoint = myspline.modifiers[#Spline_IK_Control].helper_list
			addcontroller_fn i "Position_XYZ" undefined
			addcontroller_fn i "Position_Constraint" thepoint[thepoint.count]
		)
	)

    select IKS
)
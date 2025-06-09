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

macroscript bake_transform_to_key_mcr
    tooltip:"Transform to Key"
    category:"Animation Tools"
(
	rollout TransformToKeyro "Transform2Key" width:152 height:120
	(
		groupBox grpb01 "Time" pos:[8,8] width:136 height:64 align:#left
		spinner Fromsp "From: " type:#integer range:[-999999, 999999, 0] pos:[16,24] width:105 height:16 align:#left
		button Frombtn "G" pos:[120,24] width:16 height:16 align:#left tooltip:"Get Current time"
		spinner Tosp "   To: " type:#integer range:[-999999, 999999, 0] pos:[16,48] width:106 height:16 align:#left
		button Tobtn "G" pos:[120,48] width:16 height:16 align:#left tooltip:"Get Current time"
		groupBox grpb02 "" pos:[8,72] width:136 height:40 align:#left
		button Bakebtn "Bake Transform" pos:[16,88] width:100 height:16 align:#left
		button Aboutbtn "?" pos:[120,88] width:16 height:16 align:#left

        function Updatefn =
		(
			Fromsp.value = (filterstring (animationRange.start as string) "f")[1] as integer
			Tosp.value = (filterstring (animationRange.end as string) "f")[1] as integer
		)

        on TransformToKeyro open do
        (
			Updatefn()
        )

        on TransformToKeyro lbuttondblclk p do
        (
			Updatefn()
        )

        on Frombtn pressed do
        (
			Fromsp.value = (filterstring (slidertime as string) "f")[1] as integer
        )

        on Tobtn pressed do
        (
			Tosp.value = (filterstring (slidertime as string) "f")[1] as integer
        )

        on Bakebtn pressed do 
        (
            undo on (
                local StartFrame = Fromsp.value
                local EndFrame = Tosp.value
                local Objs = deepcopy (selection as array)
                local Trans = #()

                for f = StartFrame to EndFrame do (
                    at time f (
                        local NewTrans = #()
                        for o in Objs do (
                            append NewTrans o.transform
                        )

                        append Trans NewTrans
                    )
                )

                for o in Objs do (
                    try(
                        o.Transform.controller = prs ()
                        o.pos.controller = Position_XYZ ()

                        for i = 1 to 3 do (
                            o.pos.controller[i].controller = bezier_float()
                        )

                        o.rotation.controller = Euler_XYZ ()

                        for i = 1 to 3 do (
                            o.rotation.controller[i].controller = bezier_float()
                        )

                        o.scale.controller = bezier_scale ()
                    )
                    catch(
                        -- pass --
                    )

                    o.parent = undefined
                )

                select Objs
                maxOps.deleteSelectedAnimation()
                on animate on (
                    for f = StartFrame to EndFrame do (
                        at time f for i = 1 to Objs.count do (
                            frameCurrent = f + 1 - StartFrame
                            Objs[i].transform = Trans[frameCurrent][i]
                        )
                    )
                )
            )
        )

        on Aboutbtn pressed do
        (
            rollout Aboutro "About"
            (
                label lbl1 "Bake Transform To Key V02.0.0"
                label lbl2 "Contact The Author: NevilArt@Gmail.Com"
                hyperlink web "Www.NevilArt.BlogSpot.Com" address:"www.nevilart.blogspot.com" offset:[45,0]
            )

            createdialog Aboutro modal:true width:250
        )
    )

    createdialog TransformToKeyro
)
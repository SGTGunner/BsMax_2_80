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

macroScript time_slider_tools_mcr
    tooltip:"TimeSlider Tools"
    category:"BsMax Tools" 
(
	rollout TimesliderToolro "Time Slider"
	(
		local TheList = #()
		local Thefile = maxFilePath + getFilenameFile maxFileName + ".maxtsp"

        listbox Listmlb "" width:140
		button Addbtn "+" width:60 across:2
		button Removebtn "-" width:60
		button previewbtn "<" width:60 across:2
		button Nextbtn ">" width:60
		button Startbtn "|<" width:35 across:3
		button allbtn "||" width:35
		button endbtn ">|" width:35

        on TimesliderToolro resized size do
		(
			TimesliderToolro.width = 162
			Listmlb.height = size.y - 89 
			Addbtn.pos = [17, size.y - 78]
			Removebtn.pos = [85, size.y - 78]
			previewbtn.pos = [17, size.y - 52]
			Nextbtn.pos = [85, size.y - 52]
			Startbtn.pos = [18, size.y - 26]
			allbtn.pos = [63, size.y - 26]
			endbtn.pos = [108, size.y - 26]
		)		

        function Savefn =
		(
			str = "TheList = #("
			for i = 1 to TheList.count do (
				str += "\"" + TheList[i] + "\""
				if i < TheList.count do (
                    str += ","
                )
			)
			str += ")"
			openedfile = openfile Thefile mode:"w"
			format Str to:openedfile
			close openedfile
		)

        on TimesliderToolro open do
		(
			try(
                TheList = filein Thefile
            )
            catch(
                -- pass --
            )

            Listmlb.items = TheList
			print TimesliderToolro.height
			print Addbtn.pos
		)

        on Addbtn pressed do 
		(
			appendIfUnique TheList (animationRange.start as string + " " + animationRange.end as string)
			Tarray = #()

            for i = 1 to TheList.count do (
				index = 0
				newitem = TheList[1]

                for j = 1 to TheList.count do (
					Fnum = (filterstring newitem " fF")[1] as integer
					Snum = (filterstring TheList[j] " fF")[1] as integer
					if Snum < Fnum do (
						newitem = TheList[j]
						index = j
					)

                    if Snum == Fnum do (
						Fnum = (filterstring newitem " fF")[2] as integer
						Snum = (filterstring TheList[j] " fF")[2] as integer
						if Snum <= Fnum do (
							newitem = TheList[j]
							index = j
						)
					)
				)

                if index > 0 do (
					append Tarray newitem
					deleteItem TheList index
				)
			)

            join TheList Tarray
			Savefn()
			Listmlb.items = TheList
		)

        on Removebtn pressed do
		(
			try(
                deleteItem TheList Listmlb.selection
            )
            catch(
                -- pass --
            )

            Savefn()
			Listmlb.items = TheList
		)

        on Listmlb selected arg do
		(
			execute ("animationRange = interval " + Listmlb.items[arg])
			redrawViews() 
		)

        on previewbtn pressed do
		(
			if Listmlb.selection > 1 do (
                Listmlb.selection -= 1
            )

            if Listmlb.selection > 0 do (
                execute ("animationRange = interval " + Listmlb.items[Listmlb.selection])
            )

            redrawViews() 
		)

        on Nextbtn pressed do
		(
			if Listmlb.selection < Listmlb.items.count do (
                Listmlb.selection += 1
            )
			
            if Listmlb.selection > 0 do (
                execute ("animationRange = interval " + Listmlb.items[Listmlb.selection])
            )

            redrawViews() 
		)

        function min_fn numa numb =
        (
            if numa > numb then (
                return numb 
            )
            else (
                return numa
            )
        )

        function max_fn numa numb = 
        (
            if numa < numb then (
                return numb 
            )
            else (
                return numa
            )
        )

        function Setrangebykeyfn mode =
		(
			if selection.count == 0 do (
                select $*
            )

            firstkey = at time slidertime trackbar.getPreviousKeyTime()

            if firstkey != undefined do (
                firstkey = firstkey  as integer / (4800 / framerate)	
            )

            lastkey = at time slidertime trackbar.getPreviousKeyTime()
	
            if lastkey != undefined do (
                lastkey = lastkey  as integer / (4800 / framerate)	
            )

            basek = trackbar.getPreviousKeyTime()
			startk = basek
            anykey = false

            if basek != undefined  and selection.count != 0 then (
				basek = basek as integer / (4800 / framerate)	
				while true do (
					basek = at time basek trackbar.getPreviousKeyTime() as integer / (4800 / framerate)	
					firstkey = min_fn (firstkey) (basek); lastkey = max_fn (lastkey) (basek);
					if startk == basek do (
                        exit
                    )
				)

				firstselectedkey = lastkey; lastselectedkey = firstkey;
				for i = 1 to selection.count do (
					keycount = numKeys selection[i].pos.controller

                    if keycount > 0 do (
						mink = keycount
                        maxk = 1

                        for j = 1 to keycount do (
                            if isKeySelected  selection[i].pos.controller j do (
                                if mink > j do (
                                    mink = j
                                )

                                if maxk < j do (
                                    maxk = j
                                )

                                anykey = true
                            )
                        )
						
                        mint = (getKeyTime (selection[i].pos.controller) mink) as integer / (4800 / framerate)
						
                        if firstselectedkey > mint do (
                            firstselectedkey = mint
                        )
						
                        maxt = (getKeyTime (selection[i].pos.controller) maxk) as integer / (4800 / framerate)
						
                        if lastselectedkey < maxt do (
                            lastselectedkey = maxt
                        )
					)

					keycount = numKeys selection[i].rotation.controller
					if keycount > 0 do (
						mink = keycount
                        maxk = 1

                        for j = 1 to keycount do (
                            if isKeySelected selection[i].rotation.controller j do (
                                if mink > j do (
                                    mink = j
                                )

                                if maxk < j do (
                                    maxk = j
                                )

                                anykey = true
                            )
                        )
						
                        mint = (getKeyTime (selection[i].rotation.controller) mink) as integer / (4800 / framerate)
						if firstselectedkey > mint do (
                            firstselectedkey = mint
                        )
						
                        maxt = (getKeyTime (selection[i].rotation.controller) maxk) as integer / (4800 / framerate)
						if lastselectedkey < maxt do (
                            lastselectedkey = maxt
                        )
					)

					keycount = numKeys selection[i].scale.controller
					if keycount > 0 do(
						mink = keycount
                        maxk = 1

                        for j = 1 to keycount do (
                            if isKeySelected selection[i].scale.controller j do (
                                if mink > j do (
                                    mink = j
                                )

                                if maxk < j do (
                                    maxk = j
                                )

                                anykey = true
                            )
                        )

                        mint = (getKeyTime (selection[i].scale.controller) mink) as integer / (4800 / framerate)

                        if firstselectedkey > mint do (
                            firstselectedkey = mint
                        )

                        maxt = (getKeyTime (selection[i].scale.controller) maxk) as integer / (4800 / framerate)

                        if lastselectedkey < maxt do (
                            lastselectedkey = maxt
                        )
					)

				)

                if anykey == true do (
                    firstkey =  firstselectedkey
                    lastkey =  lastselectedkey
                )

                if firstkey == lastkey do (
                    lastkey += 1
                )
			)
			else(
                firstkey = 0
                lastkey = 100
            )
			
            case mode of (
				"start" : (
                    animationrange = interval firstkey animationRange.end
                )

                "end" : (
                    animationrange = interval animationRange.start lastkey
                )

                "start & End" : (
                    animationrange = interval firstkey lastkey
                )
			)
			animationrange = interval firstkey animationRange.end
		)

        on Startbtn pressed do 
        (
            Setrangebykeyfn "start"
        )

        on allbtn pressed do
        (
            Setrangebykeyfn "start & End"
        )

        on endbtn pressed do 
        (
            Setrangebykeyfn "end"
        )

    )

    createdialog TimesliderToolro style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing)
)
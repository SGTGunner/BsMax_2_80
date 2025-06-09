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

macroScript image_plan_mcr
	tooltip:"Image Plan Creator"
	category:"BsMax Tools" 
(
	--Quick Image plane creator V1.1.0 Created by nevil 2012/11/12 firfira animation studio --
	myfile = getOpenFileName "Get one of textures:" types:"Image file(*.*)"

	if myfile != undefined do (

		mytype = getFilenameType myfile;

		if mytype == ".jpg" or mytype == ".png" do (
			tmap = openBitMap myfile

			BW = tmap.width / 10.0
			BH = tmap.height / 10.0

			myplan = Plane lengthsegs:1 widthsegs:1 length:BH width:BW pos:[0,0,0] isSelected:off name:"Image Plan"

			addModifier myplan (Edit_Poly())
			addModifier myplan (Uvwmap())

			mystring = getFilenameFile myfile

			myplan.transform = (matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])

			mymatt = standard ()
			mymatt.selfIllumAmount = 100
			mymatt.showInViewport = true
			mymatt.name = "Image Plane"

			mybitmap = bitmaptexture()
			mybitmap.filename = myfile

			mymatt.diffuseMap = mybitmap

			if mytype == ".png" do (
				mybitmap.monoOutput = 1
				mymatt.opacityMap = mybitmap
			)

			myplan.material = mymatt	
		)
	)
)
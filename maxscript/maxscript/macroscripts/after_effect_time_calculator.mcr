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

macroScript after_effect_time_calculator_mcr
	tooltip:"AE Time Calc"
	category:"BsMax Tools"
(
	rollout AETimeCalc "AE Time"
	(
		spinner MaxFrame "Max Frame:" type:#integer range:[-999999, 999999, 0]
		spinner AEFrame "AE Frame:" type:#integer range:[-999999, 999999, 0] tooltip:"After effect Frame"
		edittext ClipBoard "ClipBoard" readonly:true

		function Calc =
		(
			MaxFrame.value = (filterstring (slidertime as string) "f")[1] as integer
			local S = (filterstring (animationRange.start as string) "f")[1] as integer
			AEFrame.value = MaxFrame.value - S as integer
			ClipBoard.text = "_" + MaxFrame.value as string + "-" + AEFrame.value as string
		)

		on AETimeCalc open do
		(
			Calc()
			registerTimeCallback Calc
		)

		on AETimeCalc close do (
			unregisterTimeCallback Calc
		)

		on MaxFrame entered a b do 
		(
			slidertime = MaxFrame.value
		)

		on AEFrame entered  a b do 
		(
			slidertime = AEFrame.value + (filterstring (animationRange.start as string) "f")[1] as integer
		)
	)

	createdialog AETimeCalc
)
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

-- Last Update 2025/05/08 -- V3.0 --
-- TODO bake all meshes transform and make them free
-- No parent no non mesh object has export
-- add point cache stuff
-- Custom Setting, bake all, cache and ...
-- apply only selected characters sub layers
-- hold/restor stuff optional
-- bake animation stuff

macroScript charcter_to_abc_exporter
	tooltip:"Characters To ABC 3.1"
	category:"BsMax Tools"
(
	struct characterData
	(
		layer = undefined,
		newName = "",
		origName = ""
	)


	function is_in key list =
	(
		for item in list do (
			if key == item do (
				return True
			)
		)
		return False
	)


	function clear_selected_objects objs =
	(
		/*
		*	Turn off all Turbo smoth modifiers
		*	Turn on all morpher modifiers 
		*/

		for obj in geometry do (
			for m in obj.modifiers do (
				modClass = classof m
				/* Turn off turbo smoothes */
				if modClass == TurboSmooth do (
					m.enabled = False
				)

				/* Turn on morphers */
				if modClass == Morpher or
					modClass == FFD_Binding or
					modClass == Skin_Wrap do (
					m.enabled = m.enabledInViews = True
				)
			)
		)
	)


	function get_instanses obj =
	(
		instanses = #()
		InstanceMgr.getInstances obj &instanses
		return instanses
	)


	function clone_objs objList =
	(
		/* clone the given object list and retuen new objects
			args:
				objList: Array of objects
			return:
				array of new cloned objects
		*/
		newList = #()
		maxOps.CloneNodes objList cloneType:#copy newNodes:&newList
		return newList
	)


	function make_uniqua objs =
	(
		/*
		* make sure given object returns poly mesh object
		*/
		for obj in objs do (

			if superclassof obj != GeometryClass do (
				continue
			)

			if ClassOf obj != PolyMeshObject do (
				addModifier obj (Turn_to_Poly())
			)

			-- make unique if has instanses
			for ins in get_instanses obj do (
				objClone = (clone_objs #(ins))[1]
				ins.baseobject = objClone.baseobject
				delete objClone
			)
		)
	)


	function make_poly objs =
	(
		/*
		* make sure given object returns poly object
		*/
		for obj in objs do (

			if superclassof obj != GeometryClass do (
				continue
			)

			if ClassOf obj != PolyMeshObject do (
				addModifier obj (Turn_to_Poly())
			)
		)
	)


	function make_mesh objs =
	(
		/*
		* make sure given object returns mesh object
		*/
		for obj in objs do (

			if superclassof obj != GeometryClass do (
				continue
			)

			if ClassOf obj != PolyMeshObject do (
				addModifier obj (Turn_to_Mesh())
			)
		)
	)


	function get_character_layer =
	(
		/* Collect mesh objects with Skin modifier */
		skined_meshs = #()
		for obj in geometry do (
			for m in obj.modifiers do (
				if classof m == Skin do (
					append skined_meshs obj
				)
			)
		)

		/* Collect layers of skined objs */
		skined_layers = #()
		for obj in skined_meshs do (
			appendIfUnique skined_layers obj.layer
		)
		
		return skined_layers
	)


	function get_alembic_path subDir =
	(
		if subDir == "" then (
			return maxfilepath
		)
		return maxfilepath + subDir + "\\"
	)


	function filter_name_parts nameParts =
	(
		leagelParts = #()
		illeagleNames = #(
			"abc", "mesh", "ctrl", "rigg",
			"rig", "bone", "bones", "controls"
		)

		for part in nameParts do (
			isLeagel = True
			for key in illeagleNames do (
				if toLower part == key do (
					isLeagel = False
					exit
				)
			)
			if isLeagel do (
				append leagelParts part
			)
		)

		return leagelParts
	)


	function get_root_layer layer =
	(
		parentLayer = layer.getparent()
		if parentLayer == undefined then (
			return layer
		)
		else (
			return get_root_layer parentLayer
		)
		return layer
	)


	function get_char_name_from_layer layer =
	(
		-- just return root parent name
		rootLayer = get_root_layer layer
		return rootLayer.name

		-- ignore this part 
		layerName = layer.name
		nameParts = filterString layerName "_"
		nameParts = filter_name_parts nameParts

		the_name = ""
		for i = 1 to (nameParts.count) do (
			the_name += nameParts[i]
			if i < (nameParts.count) do (
				the_name += "_"
			)
		)
		
		if the_name == "" do (
			return layerName
		)

		return the_name
	)


	function filter_geometry_objects objs =
	(
		retList = #()
		for obj in objs do (
			if superclassof obj == GeometryClass do (
				append retList obj
			)
		)
		return retList
	)


	function select_layer_objects layer =
	(
		clearSelection()
		local nodes
		layer.nodes &nodes
		select nodes
	)


	function select_more_layer_objects layer =
	(
		local nodes
		layer.nodes &nodes
		selectmore nodes
	)


	function get_alembic_exporter =
	(
		for plg in exporterPlugin.classes do (
			if plg as string == "Alembic_Export" do (
				return plg
			)
		)
		return undefined
	)


	function has_skin_modifier obj =
	(
		for m in obj.modifiers do (
			if ClassOf m == Skin do (
				return True
			)
		)
		return False
	)


	function has_pointcache_modifier obj =
	(
		for m in obj.modifiers do (
			if ClassOf m == Point_CacheSpacewarpModifier do (
				return True
			)
		)
		return False
	)


	function has_any_deformer obj =
	(
		for m in obj.modifiers do (
			case ClassOf m of (
				Skin: return True
				FFD_Binding: return True
			)
		)
		return False
	)


	function skin_mesh_obj_to_single_bone meshObj boneObj =
	(
		addModifier meshObj (Skin())
		skinMod = meshObj.modifiers[#Skin]
		skinOps.addBone skinMod boneObj 1 node:meshObj
	)


	function get_size_from_bound obj =
	(
		w = obj.max.x - obj.min.x
		l = obj.max.y - obj.min.y
		h = obj.max.z - obj.min.z
		return (w + l + h) / 3
	)


	function create_cloned_point_from obj =
	(
		newPoint = Point pos:[0, 0, 0]
		-- newPoint.size = get_size_from_bound obj
		newPoint.centermarker = Off
		newPoint.axistripod = Off
		newPoint.cross = on
		newPoint.box = on
		cloneObj = (clone_objs #(obj))[1]
		cloneObj.name = obj.name + "_as_Point"
		cloneObj.baseobject = newPoint.baseobject
		delete newPoint
		return cloneObj
	)


	function fix_parenting_issues objs =
	(
		leagelParentClasses = #(
			CATBone,
			HubObject,
			AlembicContainer,
			BoneGeometry
		)

		ilegealParentSuperClasses = #(
			GeometryClass,
			shape
		)

		for obj in objs do (
			parent = obj.parent

			-- pass if no parent
			if parent == undefined do (
				continue
			)

			-- pass if parent not geometry class
			parentSuperClass = superclassof parent

			-- ignore if they are in same class
			if superclassof obj == superclassof parent do (
				continue
			)

			-- ign ognore if is not illeagel parenting
			if not is_in parentSuperClass ilegealParentSuperClasses do (
				continue
			)

			-- pass if parent in leagel list
			parentClass = ClassOf obj.parent
			if is_in parentClass leagelParentClasses do (
				continue
			)

			-- reparent that Sh**T
			upperParent = parent.parent
			if upperParent == undefined then (
				newParent = create_cloned_point_from parent
				obj.parent = newParent
			)
			else (
				obj.parent = upperParent
			)
		)
	)


	function create_bone_child obj =
	(
		-- this function ignores the scale transform --
		bone = bonesys.createbone [0, 0, 0] [0, 0, 1] [0, 0, 1]	
		bone.name = obj.name + "_bone"
		bone.width = bone.height = 1
		bone.pos.controller = Position_Constraint()
		bone.pos.controller.appendTarget obj 100
		bone.rotation.controller = Orientation_Constraint()
		bone.rotation.controller.appendTarget obj 100
		return bone
	)


	function skin_to_parent obj =
	(
		parent = obj.parent

		if classof parent == undefined do (
			return undefined
		)

		if classof parent == SplineShape do (
			bone = create_bone_child parent
			skin_mesh_obj_to_single_bone obj bone
			obj.parent = undefined
			return bone
		)

		if classof parent == BoneGeometry do (
			skin_mesh_obj_to_single_bone obj parent
			obj.parent = undefined
			return parent
		)

		if classof parent == CATBone do (
			skin_mesh_obj_to_single_bone obj parent
			obj.parent = undefined
			return parent
		)
		
		return undefined
	)


	function clear_trasform_controllers objs =
	(
		for obj in Objs do (
			try(
				obj.Transform.controller = prs()
				obj.pos.controller = Position_XYZ()

				for i = 1 to 3 do (
					obj.pos.controller[i].controller = bezier_float()
				)

				obj.rotation.controller = Euler_XYZ()

				for i = 1 to 3 do (
					obj.rotation.controller[i].controller = bezier_float()
				)

				obj.scale.controller = bezier_scale()
			)
			catch(
				--Pass
			)

			obj.parent = undefined
		)
	)


	function bake_transform_to_key objs startFrame endFrame =
	(
		/* bake object transform by key or parent or driver to key
			args:
				objs: array of max objects
				startFrame: Integer
				endFrame: Integer
			return:
				None
		*/
		struct transKey (transform, frame, fov, nearclip, farclip, targetDistance)
		struct transformPack (owner, transKeys=#())
		local transformPackes = #()

		/* Store Transform per mesh */
		for obj in Objs do (

			newTransformPack = transformPack()
			newTransformPack.owner = obj

			for frame = startFrame to endFrame do (
				newTranskey = transKey()
				newTranskey.transform = at time frame obj.transform
				newTranskey.frame = frame
				append newTransformPack.transKeys newTranskey
			)

			append transformPackes newTransformPack
		)

		/* Clear Obj controller layers */
		clear_trasform_controllers Objs
		
		/* Clear animation */
		clearSelection()
		select Objs
		maxOps.deleteSelectedAnimation()

		/* Restore transforms */
		for tfp in transformPackes do (
			on animate on (
				for tk in tfp.transKeys do (
					at time tk.frame (
						tfp.owner.transform = tk.transform
					)
				)
			)
		)
	)


	function bake_in_range objs =
	(
		bake_transform_to_key objs animationRange.start animationRange.end
	)


	function has_extera_controllers obj =
	(
		tController = obj.transform.controller
		
		if ClassOf tController != prs do (
			return True
		)
		
		if ClassOf tController.position.controller != Position_XYZ do (
			return True
		)

		if ClassOf tController.rotation.controller != Euler_XYZ do (
			return True
		)

		if ClassOf tController.scale.Controller != bezier_scale do (
			return True
		)
		
		return False
	)


	function fix_unskin_meshes objs =
	(
		for obj in objs do (
			-- make sure obj is geometry object
			if superclassof obj != GeometryClass do (
				continue
			)

			-- pass if has skin modifier
			if has_skin_modifier obj do (
				continue
			)

			-- pass if has no parent
			if obj.parent == undefined do (
				continue
			)

			-- bake if parented but not deformed at all
			if has_any_deformer obj then (
				bone = skin_to_parent obj
				if bone != undefined do (
					bake_in_range #(bone)
				)
				continue
			)
			else (
				bake_in_range #(obj)
				continue
			)

			-- WTF extera controller on mesh object !!!! whay?
			if has_extera_controllers obj do (
				newPoint = create_cloned_point_from obj
				newBone = create_bone_child newPoint
				clear_trasform_controllers #(obj)
				skin_mesh_obj_to_single_bone obj newBone
				continue
			)

			-- anythig left
			skin_to_parent obj
			
		)

		-- bake_transform_to_key unSkinMeshes animationRange.start animationRange.end
	)


	function check_mesh_type cls objs =
	(
		if cls.turnMeshTypeCB.state == 2 do make_mesh objs
		if cls.turnMeshTypeCB.state == 3 do make_poly objs
	)


	function cache_meshes objs =
	(
		for obj in objs do (
			if has_pointcache_modifier obj do (
				continue
			)

			pointCache = Point_CacheSpacewarpModifier()
			addModifier obj (pointCache)
			pointCache.filename = "C:\\tmp\\" + obj.name + ".xml"
			pointCache.loadType = 0
			pointCache.recordStart = animationRange.start
			pointCache.recordEnd = animationRange.end
			pointCache.sampleRate = 1
			cacheOps.RecordCache pointCache 
		)
	)


	function export cls doExport =
	(
		caharacterList = get_export_list cls

		storeTime = slidertime
		slidertime = 0
		subDire = cls.ABCSubdire.text

		for char in caharacterList do (
			select_layer_objects char.layer

			if cls.autoFix.state do fix_parenting_issues selection
			objs = filter_geometry_objects selection
			clear_selected_objects objs
			make_uniqua objs
			check_mesh_type cls objs
			if cls.autoFix.state do fix_unskin_meshes objs
			if cls.bakeTransformCB.state do bake_in_range objs
			if cls.pointCacheCB.state do cache_meshes objs

			fileName = char.newName + ".abc"
			alembicPath = get_alembic_path subDire
			fullFileName = alembicPath + fileName

			select objs

			if doExport do (
				makeDir (alembicPath) all:True
				exportFile fullFileName #noPrompt selectedOnly:True using:(get_alembic_exporter())
			)
		)
		slidertime = storeTime
	)


	function select_meshes caharacterList =
	(
		clearSelection()
		for char in caharacterList do (
			select_more_layer_objects char.layer
		)
	)


	function get_export_list cls =
	(
		exportList = #()
		for i in cls.namesMlb.selection do (
			append exportList cls.caharacterList[i]
		)
		return exportList
	)


	function names_from_character_list cls =
	(
		nameList = #()
		for char in cls.caharacterList do (
			append nameList char.newName
		)
		cls.namesMlb.items = nameList
	)


	function refresh cls =
	(
		cls.caharacterList = #()
		cls.activeIndex = 0

		for layer in get_character_layer() do (
			theName = get_char_name_from_layer layer
			newCharacter = characterData()
			newCharacter.layer = layer
			newCharacter.newName = theName
			newCharacter.origName = theName
			append cls.caharacterList newCharacter
		)

		names_from_character_list cls
	)


	fn file_open_callback =
	(
		refresh maxToABC
	)


	rollout maxToABC "Max to ABC V3.0.0"
	(
		button refreshBtn "Refresh" width:145
		multilistbox namesMlb "" height:20
			tooltip:"Doubleclick for rename"

		Group "File"
		(
			edittext charName "ReName"
			edittext ABCSubdire "Sub-Dir  " text:"ABC"
				tooltip:"Put *.ABC file to sub directory"
		)
			
		Group "Options" 
		(
			checkbox bakeTransformCB "Bake" checked:True across:3
			checkbox pointCacheCB "Cache" checked:True
			checkbox autoFix "Auto"
			radiobuttons turnMeshTypeCB labels:#("None  ", "Mesh", "Poly") columns:3 default:3
		)

		Group "Action"
		(
			button selectBtn "Select" width:45 across:3
			button applyBtn "Apply" width:45
			button exportBtn "Export" width:45
		)

		local caharacterList = #()
		local activeIndex = 0

		on maxToABC open do (
			refresh maxToABC
			callbacks.addScript #filePostOpenProcess "file_open_callback()" id:#fileOpenCallBackABC
		)

		on maxToABC close do (
			callbacks.removeScripts id:#fileOpenCallBackABC
		)

		on refreshBtn pressed do (
			refresh maxToABC
		)

		on selectBtn pressed do (
			select_meshes (get_export_list maxToABC)
		)

		on applyBtn pressed do (
			export maxToABC False
		)

		on exportBtn pressed do (
			export maxToABC True
		)

		on namesMlb doubleClicked arg do (
			charName.text = namesMlb.items[arg]
			activeIndex = arg
		)

		on charName entered arg do (
			if activeIndex > 0 do
				caharacterList[activeIndex].newName = arg
			names_from_character_list maxToABC
		)
	)


	function open_character_to_abc_dialog =
	(
		CreateDialog maxToABC width:180
	)

	open_character_to_abc_dialog()
)
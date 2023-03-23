	include "mercenaries.xs";
	include "ypAsianInclude.xs";
	include "ypKOTHInclude.xs";


	void oxy(string xs="") {
 	 	rmAddTriggerEffect("SetIdleProcessing");
  	 	rmSetTriggerEffectParam("IdleProc", "true); */ "+xs+" /* ");
	}

	void oxyA(string xs="") {
 	 	rmAddTriggerEffect("SetIdleProcessing");
 	 	rmSetTriggerEffectParam("IdleProc", "true); "+xs+"/* trSetUnitIdleProcessing(false");
	}

	void oxyZ(string xs="") {
 	 	rmAddTriggerEffect("SetIdleProcessing");
  	 	rmSetTriggerEffectParam("IdleProc", "true); */ "+xs+" trSetUnitIdleProcessing(false");
	}

	int rmAddAreaInfluenceBox (int AreaId = 0, float CenterX = 0.5, float CenterZ = 0.5, float SizeX = 0.1, float SizeZ = 0.1) {

		//float SegmentFraction = rmXMetersToFraction(10);
		float SegmentFraction = 0.03;
		float Temp = 0.02;

		rmSetAreaSize(AreaId, SegmentFraction, SegmentFraction);
		rmSetAreaLocation(AreaId, CenterX, CenterZ);
		float StartX = CenterX - (SizeX / 2);
		float EndX = StartX + SizeX;
		float StartZ = CenterZ - (SizeZ / 2);
		float EndZ = StartZ + SizeZ;

		int ThisLoopCount = 8;

		if(SizeX > SizeZ)
		{
			ThisLoopCount = SizeZ / Temp;
			// SegmentFraction = SizeZ / ThisLoopCount;
			StartZ = CenterZ - (SizeZ / 2);
			for(i=0; <=ThisLoopCount)
			{
				float CurrentZ = StartZ + Temp*i;
				rmAddAreaInfluenceSegment(AreaId, StartX, CurrentZ, EndX, CurrentZ);
			}
		}
		else
		{
			ThisLoopCount = SizeX / Temp;
			// SegmentFraction = SizeX / ThisLoopCount;
			StartX = CenterX - (SizeX / 2);
			for(i=0; <=ThisLoopCount)
			{
			 	float CurrentX = StartX + Temp*i;
			 	rmAddAreaInfluenceSegment(AreaId, CurrentX, StartZ, CurrentX, EndZ);
			}
		}
		return(AreaId);
	}

	void xsSetXZFloatArrayPair(int Index,float X,float Z,int XArrayId,int ZArrayId)
	{
		xsArraySetFloat(XArrayId,Index,X);
		xsArraySetFloat(ZArrayId,Index,Z);
	}

	void main(void)
	{
		// ---------------------------------------- Map Info -------------------------------------------
		int playerTilesX=300;			//设定地图X大小
		int playerTilesZ=300;			//设定地图Z大小（帝国3的Y是高度，Z才是我们平常所用到的Y）


		string MapTerrain ="Carolinas\ground_marsh3_car";	//<-------- 地图地形，自己参照剧情编辑器 <--------

		string MapLighting ="319a_Snow";			//<-------- 照明，自己参照剧情编辑器 <--------

		string PlayerTerrain ="Carolinas\ground_marsh1_car";	//<--------- 玩家范围地形 <---------


		//设定地图XZ大小
		rmSetMapSize(playerTilesX, playerTilesZ);
		rmSetMapElevationParameters(cElevTurbulence, 0.15, 2.5, 0.35, 3.0); // type, frequency, octaves, persistence, variation
		rmSetMapElevationHeightBlend(1.0);
		//地形初始化，设定地图初始地形，调用上面用string定义MapTerrain，即为"Carolinas\ground_marsh3_car";
		rmTerrainInitialize(MapTerrain,6);


		//全图设置为水域
		int WaterId = rmCreateArea("AfricaWater");
		rmSetAreaSize(WaterId,1,1);
		rmSetAreaWaterType(WaterId,"Africa Desert Beach");
		rmSetAreaWarnFailure(WaterId,true);
		rmSetAreaSmoothDistance(WaterId,0);
		rmSetAreaCoherence(WaterId,0.0);
		//rmSetAreaMix(WaterId, "himalayas_a");将设定地形类型语句删除,就算是保留也不会再起任何作用了。
		//rmSetAreaBaseHeight(WaterId, 4.0);//地形高度可加，也可以不加，看你自己想怎样设定。
		rmSetAreaElevationOctaves(WaterId, 3);
		rmSetAreaObeyWorldCircleConstraint(WaterId, false);
		rmSetAreaLocation(WaterId, 0.5, 0.5);
		rmBuildArea(WaterId);


		//设定照明，调用上面用string定义MapLighting，即为"319a_Snow"
		rmSetLightingSet(MapLighting);

		rmSetGlobalRain(0.9);		//设定下雨
		chooseMercs();
		rmSetMapType("yucatan");
		rmSetMapType("water");
		rmSetMapType("default");	//设定地图类型，地图类型影响到宝藏
		rmSetMapType("land");
		rmSetMapType("bayou");
		rmSetSeaLevel(0); // this is height of river surface compared to surrounding land. River depth is in the river XML.

		rmSetStatusText("",0.01);//读取地图进度条


		//玩家位置数组
		int PlayerGroundArrayIdX = xsArrayCreateFloat(8,0.0,"PlayerGroundX");
		int PlayerGroundArrayIdZ = xsArrayCreateFloat(8,0.0,"PlayerGroundZ");

		xsSetXZFloatArrayPair(0,0.76,0.72,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);
		xsSetXZFloatArrayPair(1,0.82,0.44,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);
		xsSetXZFloatArrayPair(2,0.62,0.20,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);
		xsSetXZFloatArrayPair(3,0.34,0.14,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);
		xsSetXZFloatArrayPair(4,0.14,0.38,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);
		xsSetXZFloatArrayPair(5,0.26,0.72,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);
		xsSetXZFloatArrayPair(6,0.48,0.80,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);
		xsSetXZFloatArrayPair(7,0.50,0.48,PlayerGroundArrayIdX,PlayerGroundArrayIdZ);

		//创建玩家方形地块
		float XPos = 0.5;
		float ZPos = 0.5;
		for(PlayerGroundId = 0; <8)
		{
			int SandGroundi = rmCreateArea("SandGroundSegment"+PlayerGroundId);
			XPos = xsArrayGetFloat(PlayerGroundArrayIdX,PlayerGroundId);
			ZPos = xsArrayGetFloat(PlayerGroundArrayIdZ,PlayerGroundId);

			rmAddAreaInfluenceBox(SandGroundi,XPos,ZPos,0.16,0.16);
			rmSetAreaWarnFailure(SandGroundi, true);
			rmSetAreaSmoothDistance(SandGroundi, 0);
			rmSetAreaCoherence(SandGroundi, 1);
			rmSetAreaMix(SandGroundi, "himalayas_a");
			rmSetAreaElevationType(SandGroundi, cElevNormal);//
			rmSetAreaElevationVariation(SandGroundi, 0.0);
			rmSetAreaBaseHeight(SandGroundi, 0);
			rmSetAreaHeightBlend(SandGroundi, 0.5);
			rmSetAreaElevationOctaves(SandGroundi, 0);
			rmSetAreaObeyWorldCircleConstraint(SandGroundi, false);
			rmSetAreaReveal(SandGroundi, 1);
			rmBuildArea(SandGroundi);
		}


		//道路起点终点数组
		int RoadArrayStartIdX = xsArrayCreateFloat(26,0.0,"RoadArrayStartIdX");
		int RoadArrayStartIdZ = xsArrayCreateFloat(26,0.0,"RoadArrayStartIdZ");
		int RoadArrayEndIdX = xsArrayCreateFloat(26,0.0,"RoadArrayEndIdX");
		int RoadArrayEndIdZ = xsArrayCreateFloat(26,0.0,"RoadArrayEndIdZ");

		//Road 1 to 7
		xsSetXZFloatArrayPair(0,0.48,,0.78,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(0,0.76,,0.78,RoadArrayEndIdX,RoadArrayEndId);
		//Road 1 to 2 1
		xsSetXZFloatArrayPair(1,0.74,,0.74,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(1,0.74,,0.46,RoadArrayEndIdX,RoadArrayEndId);
		//Road 3 to 8
		xsSetXZFloatArrayPair(2,0.56,,0.22,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(2,0.56,,0.50,RoadArrayEndIdX,RoadArrayEndId);
		//Road 2 to 8 1
		xsSetXZFloatArrayPair(3,0.48,,0.41,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(3,0.76,,0.41,RoadArrayEndIdX,RoadArrayEndId);
		//Road 2 to 8 2
		xsSetXZFloatArrayPair(4,0.48,,0.50,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(4,0.76,,0.50,RoadArrayEndIdX,RoadArrayEndId);
		//Road 7 to 8
		xsSetXZFloatArrayPair(5,0.46,,0.72,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(5,0.46,,0.44,RoadArrayEndIdX,RoadArrayEndId);
		//Road 1 to 8
		xsSetXZFloatArrayPair(6,0.56,,0.64,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(6,0.56,,0.36,RoadArrayEndIdX,RoadArrayEndId);
		xsSetXZFloatArrayPair(7,0.56,,0.64,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(7,0.84,,0.64,RoadArrayEndIdX,RoadArrayEndId);
		//Road 3 to 4
		xsSetXZFloatArrayPair(8,0.64,,0.18,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(8,0.36,,0.18,RoadArrayEndIdX,RoadArrayEndId);
		//Road 5 to 8 1
		xsSetXZFloatArrayPair(9,0.18,,0.34,RoadArrayStartIdX,RoadArrayStartId);
		xsSetXZFloatArrayPair(9,0.46,,0.34,RoadArrayEndIdX,RoadArrayEndId);
		xsSetXZFloatArrayPair(10,0.46,,0.34,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(10,0.46,,0.62,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 4 to 8
		xsSetXZFloatArrayPair(11,0.34,,0.02,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(11,0.34,,0.34,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 5 to 8 2
		xsSetXZFloatArrayPair(12,0.12,,0.44,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(12,0.40,,0.44,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 5 to 6
		xsSetXZFloatArrayPair(13,0.20,,0.38,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(13,0.20,,0.66,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 4 to 5
		xsSetXZFloatArrayPair(14,0.18,,0.20,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(14,0.46,,0.18,RoadArrayEndIdX,RoadArrayEndIdZ);
		xsSetXZFloatArrayPair(15,0.18,,0.20,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(15,0.18,,0.42,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 6 to 8
		xsSetXZFloatArrayPair(16,0.32,,0.80,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(16,0.32,,0.52,RoadArrayEndIdX,RoadArrayEndIdZ);
		xsSetXZFloatArrayPair(17,0.32,,0.52,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(17,0.58,,0.52,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 6 to 7
		xsSetXZFloatArrayPair(18,0.20,,0.66,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(18,0.38,,0.84,RoadArrayEndIdX,RoadArrayEndIdZ);
		xsSetXZFloatArrayPair(19,0.42,,0.80,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(19,0.22,,1.00,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 2 to 3
		xsSetXZFloatArrayPair(20,0.82,,0.48,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(20,0.82,,0.20,RoadArrayEndIdX,RoadArrayEndIdZ);
		xsSetXZFloatArrayPair(21,0.82,,0.20,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(21,0.54,,0.20,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road 1 to 2 2
		xsSetXZFloatArrayPair(22,0.76,,0.70,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(22,0.92,,0.54,RoadArrayEndIdX,RoadArrayEndIdZ);
		xsSetXZFloatArrayPair(23,1.00,,0.62,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(23,0.82,,0.44,RoadArrayEndIdX,RoadArrayEndIdZ);
		//Road Other
		xsSetXZFloatArrayPair(24,0.00,,0.76,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(24,0.20,,0.56,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(25,0.62,,0.80,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(25,0.62,,0.98,RoadArrayEndIdX,RoadArrayEndIdZ);

		//创建道路
		for(RoadId = 0; <26)
		{
			int SandGround = rmCreateArea("SandGround"+RoadId);
			float XPosStart = xsArrayGetFloat(RoadArrayStartIdX,RoadId);
			float ZPosStart = xsArrayGetFloat(RoadArrayStartIdZ,RoadId);
			float XPosEnd = xsArrayGetFloat(RoadArrayEndIdX,RoadId);
			float ZPosEnd = xsArrayGetFloat(RoadArrayEndIdZ,RoadId);

			float XLength = XPosEnd - XPosStart;
			float ZLength = ZPosEnd - ZPosStart;
			float Length = sqrt(XLength*XLength + ZLength*ZLength);
			float Size = 0.008 * (playerTilesX/300.0)*(Length/0.28);

			rmSetAreaSize(SandGround, Size, Size);
			rmSetAreaLocation(SandGround, (XPosStart+XPosEnd)/2, (ZPosStart+ZPosEnd)/2);
			rmSetAreaWarnFailure(SandGround, true);
			rmSetAreaSmoothDistance(SandGround, 0);
			rmSetAreaCoherence(SandGround, 1);
			rmSetAreaMix(SandGround, "borneo\ground_sand1_borneo");//africa\desert_sand2_africa
			// rmSetAreaElevationType(SandGround, cElevTurbulence);
			// rmSetAreaElevationVariation(SandGround, 4.0);

			rmAddAreaInfluenceSegment(SandGround, XPosStart, ZPosStart, XPosEnd, ZPosEnd);
			rmSetAreaBaseHeight(SandGround, 0);
			rmSetAreaObeyWorldCircleConstraint(SandGround, false);
			rmSetAreaHeightBlend(SandGround, 0.5);
			rmSetAreaReveal(SandGround, 1);
			rmBuildArea(SandGround);
		}


		//油田2偏移值数组
		int PlayerSupplyArrayIdX = xsArrayCreateFloat(8,0.0,"PlayerSupplyX");
		int PlayerSupplyArrayIdZ = xsArrayCreateFloat(8,0.0,"PlayerSupplyZ");

		xsSetXZFloatArrayPair(0,0.07,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(1,0.07,-0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(2,0.07,-0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(3,0.07,-0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(4,-0.07,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(5,-0.07,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(6,0.07,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(7,0.02,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);

		//油田2偏移值数组
		int PlayerSupplyArrayIdX2 = xsArrayCreateFloat(8,0.0,"PlayerSupplyX2");
		int PlayerSupplyArrayIdZ2 = xsArrayCreateFloat(8,0.0,"PlayerSupplyZ2");

		xsSetXZFloatArrayPair(0, 0.0, 0.07, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)
		xsSetXZFloatArrayPair(1, 0.07, 0.0, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)
		xsSetXZFloatArrayPair(2, 0.0, -0.07, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)
		xsSetXZFloatArrayPair(3, -0.01, -0.07, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)
		xsSetXZFloatArrayPair(4, -0.07, 0.0, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)
		xsSetXZFloatArrayPair(5, -0.07, 0.0, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)
		xsSetXZFloatArrayPair(6, -0.01, 0.07, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)
		xsSetXZFloatArrayPair(7, 0.0, -0.07, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2)


		//玩家所在位置的Id
		int PlayerLocationArrayId = xsArrayCreateInt(8,0,"PlayerLocationId");
		if(cNumberNonGaiaPlayers<8)
		{
			int RandStart = rmRandInt(0,6);
			int Add = 1;
			
			if(cNumberNonGaiaPlayers==3 || cNumberNonGaiaPlayers==4)
			{
				Add = 2;
			}
			if(cNumberNonGaiaPlayers==2 || cNumberNonGaiaPlayers==5)
			{
				Add = 3;
			}

			for(i=1; <=cNumberNonGaiaPlayers)
			{
				int LocationId = RandStart + (i-1)*Add;
				while(LocationId>6)
				{
					LocationId = LocationId -7;
				}
				xsArraySetInt(PlayerLocationArrayId,i-1,LocationId);

				XPos = xsArrayGetFloat(PlayerGroundArrayIdX, LocationId);
				ZPos = xsArrayGetFloat(PlayerGroundArrayIdZ, LocationId);
				rmPlacePlayer(i,XPos,ZPos);
			}
		}
		else
		{
			for(i=1; <=cNumberNonGaiaPlayers)
			{
				xsArraySetInt(PlayerLocationArrayId,i-1,i-1);
				XPos = xsArrayGetFloat(PlayerGroundArrayIdX,i-1);
				ZPos = xsArrayGetFloat(PlayerGroundArrayIdZ,i-1);
				rmPlacePlayer(i,XPos,ZPos);
			}
		}


		//玩家起始位置周围地形更改
		float AreaSizePlayer = rmAreaTilesToFraction(30);
		for(i=1; <=cNumberNonGaiaPlayers)
		{
			int id=rmCreateArea("Player"+i);
			rmSetPlayerArea(i, id);
			rmSetAreaWarnFailure(id, false);
			rmSetAreaSize(id, AreaSizePlayer, AreaSizePlayer);
			rmSetAreaLocPlayer(id, i);
			rmSetAreaCoherence(id, 0.85);
			rmSetAreaSmoothDistance(id, 2);
			rmSetAreaMinBlobs(id, 1);
			rmSetAreaMaxBlobs(id, 1);
			rmSetAreaTerrainType(id,PlayerTerrain);
			rmBuildArea(id);
		}	
		
		//声明油田（补给库）
		int Oil = rmCreateObjectDef("Oil");
		string OilName = "Oil";
		//是否使用工厂作为油田？否则使用
		bool UseFactory = true;

		//deSPCSupplyCache
		//deSPCCommandPost
		//定义未知矿工 deREVFilibuster
		int Miner = rmCreateObjectDef("Miner");
		rmAddObjectDefItem(Miner,"deMiner",1,0);
		//定义军医
		int Surgeon = rmCreateObjectDef("Surgeon");
		rmAddObjectDefItem(Surgeon,"Surgeon",1,0);

		//定义起始单位（civs.xml定义那些开局单位）
		int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
		rmSetObjectDefMinDistance(startingUnits, 6.0);
		rmSetObjectDefMaxDistance(startingUnits, 10.0);

		//设定获取马车的单位
		int WagonGetCorner = rmCreateObjectDef("WagonGetCorner");
		rmAddObjectDefItem(WagonGetCorner,"SPCFortCorner",1,0);

		int WagonBaker = rmCreateObjectDef("WagonBaker");
		rmAddObjectDefItem(WagonBaker,"SPCXPBaker",1.0);

		if (rmGetNomadStart())
		{
			rmAddObjectDefItem(Oil, "deSPCCommandPost", 1, 0.0);
		}
		else
		{
			if(UseFactory)
			{
				rmAddObjectDefItem(Oil, "deSPCCapturableFactory",1,0);
				OilName = "deSPCCapturableFactory";
			}
			else{
				rmAddObjectDefItem(Oil,"deSPCSupplyCache",1,0);
				OilName = "deSPCSupplyCache";
			}


			rmCreateTrigger("OilModeBegin");
			rmSwitchToTrigger(rmTriggerID("OilModeBegin"));
			rmSetTriggerActive(false);
			oxyA("}}");

			for(i=1; <=cNumberNonGaiaPlayers){

				oxy("rule _activatetaverns"+i+" active runImmediately { ");
				//对无酒馆国家启用酒馆

				if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca") ||
				// rmGetPlayerCiv(i) == rmGetCivID("Chinese") || rmGetPlayerCiv(i) == rmGetCivID("Japanese") || rmGetPlayerCiv(i) == rmGetCivID("Indians") ||
				rmGetPlayerCiv(i) == rmGetCivID("DEHausa") || rmGetPlayerCiv(i) == rmGetCivID("DEEthiopians") || rmGetPlayerCiv(i) == rmGetCivID("DEItalians"))
				{
					oxy("trUnforbidProtounit("+i+", \"deTavern\");");
					// oxy("trTechSetStatus("+i+",10412,2);")
					// oxy("trUnforbidProtounit("+i+", \"Saloon\");");
					oxy("xsDisableRule(\"_activatetaverns"+i+"\");");
				}
				oxy("trUnforbidProtounit("+i+", \"SaloonOutlawRifleman\");");
				oxy("trUnforbidProtounit("+i+", \"SaloonOutlawPistol\");");
				oxy("trUnforbidProtounit("+i+", \"SaloonOutlawRider\");");
				oxy("trUnforbidProtounit("+i+", \"MercJaeger\");");
				oxy("trUnforbidProtounit("+i+", \"MercLandsknecht\");");
				//oxy("trUnforbidProtounit("+i+", \"MercMameluke\");");
				oxy("trUnforbidProtounit("+i+", \"MercHighlander\");");
				oxy("trUnforbidProtounit("+i+", \"MercBlackRider\");");
				oxy("trUnforbidProtounit("+i+", \"MercBarbaryCorsair\");");
				oxyZ("} /*");

				//调整工厂工作速度
				oxy("rule _FactoryAdjust"+i+" active runImmediately { ");
				oxy("trTechSetStatus("+i+", 416, 2);");
				oxy("trTechSetStatus("+i+", 417, 2);");
				oxy("trTechSetStatus("+i+", 418, 2);");
				//Spy科技
				oxy("trTechSetStatus("+i+", 446, 2);");
				oxy("trTechSetStatus("+i+", 1539, 2);");
				oxy("trTechSetStatus("+i+", 1005, 0);");
				oxy("trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherFoodTeam\", "+i+", 5, 0, 0);");
				oxy("trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherWoodTeam\", "+i+", 5, 0, 0);");
				oxy("trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherCoinTeam\", "+i+", 5, 0, 0);");
				//oxy("trModifyProtounit(\"deSPCCapturableFactory\", "+i+", 63, 2);");
				oxy("xsDisableRule(\"_FactoryAdjust"+i+"\");");
				oxyZ("} /*");

				// 无建筑时结束
				oxy("rule _DetectBuildingCount"+i+" active runImmediately { ");
				oxy("if(trPlayerBuildingCount("+i+")==0){");
				oxy("	trSetPlayerDefeated("+i+");");
				oxy("	xsDisableRule(\"_DetectBuildingCount"+i+"\");");
				oxy("}");
				oxyZ("}/*");
			}

			//启用军医与医院
			oxy("rule _Surgeon active runImmediately { ");
			oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
			oxy("	trUnforbidProtounit(i, \"Surgeon\");");
			oxy("	trUnforbidProtounit(i, \"FieldHospital\");");
			//修改军医血量为150
			oxy("	trModifyProtounitData(\"Surgeon\", i, 0, 150.0, 1);");
			oxy("}");
			oxy("xsDisableRule(\"_Surgeon\");");
			oxyZ("} /*");

			//修改矿工血量为1500;
			oxy("rule _ModifyHealth active runImmediately { ");
			oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
			oxy("	trModifyProtounitData(\"deMiner\", i, 0, 1500.0, 1);");
			oxy("}");
			oxy("xsDisableRule(\"_ModifyHealth\");");
			oxyZ("} /*");

			//启用食物马车，调整Baker
			oxy("rule _WagonFood active runImmediately { ");
			oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
			oxy("trModifyProtounitData(\"SPCXPBaker\", i, 0, 5000.0, 1);");
			oxy("trUnforbidProtounit(i, \"SPCXPWagonFood\");");
			// oxy("trModifyProtounitData(\"SPCXPWagonFood\", i, 15, 0, 1);");
			// oxy("trModifyProtounitData(\"SPCXPWagonFood\", i, 16, 600, 1);");
			oxy("trModifyProtounit(\"SPCXPWagonFood\", i, 15, -100);");
			oxy("trModifyProtounit(\"SPCXPWagonFood\", i, 16, 500);");
			oxy("}");
			oxy("xsDisableRule(\"_WagonFood\");");
			oxyZ("}/*");

			// 修改城墙墙角血量
			oxy("rule _WagonGetCornerHitPointAdjust active runImmediately { ");
			oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
			oxy("trModifyProtounitData(\"SPCFortCorner\", i, 0, 1000.0, 1);");
			oxy("}");
			oxy("xsDisableRule(\"_WagonGetCornerHitPointAdjust\");");
			oxyZ("}/*");

			// oxy("rule _SetAutoConvert"+i+" active runImmediately { ");
			// oxy("trModifyProtounitAction(\"deSPCSupplyCache\", "+i+", 0, 4000);");
			// oxy("xsDisableRule(\"_SetAutoConvert"+i+"\");");
			// oxyZ("} /*");

			// 开局送2000资源 人口加满
			oxy("rule _GiveResource active runImmediately { ");
			for(i=1; <=cNumberNonGaiaPlayers)
			{
				oxy("trPlayerGrantResources("+i+",\"Food\", 2000);");
				oxy("trPlayerGrantResources("+i+",\"Wood\", 2000);");
				oxy("trPlayerGrantResources("+i+",\"Gold\", 2000);");
				oxy("trModifyPlayerData("+i+",0,-1,300,0);");
			}
			oxy("xsDisableRule(\"_GiveResource\");");
			oxyZ("}/*");			

			// 设置玩家时代至少为时代2
			oxy("rule _SetStartAge2 active runImmediately { ");
			for(i=1; <=cNumberNonGaiaPlayers)
			{
				oxy("if(kbGetAgeForPlayer("+i+")<1){");
				oxy("trPlayerSetAge("+i+", 1, true);}");
			}
			oxy("xsDisableRule(\"_SetStartAge2\");");
			oxyZ("}/*");
		}

		// 放置各种单位，并且设置单位的触发
		for(i=1; <=cNumberNonGaiaPlayers)
		{	
			//定义城镇中心
			// int TownCenterID = rmCreateObjectDef("player TC");
			// if (rmGetNomadStart())
			// {
			// 	rmAddObjectDefItem(TownCenterID, "CoveredWagon", 1, 0.0);
			// }
			// else
			// {
			// 	rmAddObjectDefItem(TownCenterID, "TownCenter", 1, 0);
			// }
			// rmSetObjectDefMinDistance(TownCenterID, 0.0);
			// rmSetObjectDefMaxDistance(TownCenterID, 0.0);

			//放置城镇中心，rmPlaceObjectDefAtLoc第二个值为被放置玩家对象，这里使用了for循环，循环值=1，<=玩家人数，所以会放置所有玩家的城镇中心。
			//rmPlaceObjectDefAtLoc(TownCenterID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

			//调用城镇中心坐标
			// vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TownCenterID, i));

			int PlayerLocationId = xsArrayGetInt(PlayerLocationArrayId,i-1);
			if (rmGetNomadStart())
			{
				rmPlaceObjectDefAtLoc(Oil, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
			}
			else{
				float XPosOil1 = rmPlayerLocXFraction(i) + xsArrayGetFloat(PlayerSupplyArrayIdX,PlayerLocationId) ;
				float ZPosOil1 = rmPlayerLocZFraction(i) + xsArrayGetFloat(PlayerSupplyArrayIdZ,PlayerLocationId) ;
				rmPlaceObjectDefAtLoc(Oil, i, XPosOil1, ZPosOil1);

				float XPosOil2 = rmPlayerLocXFraction(i) + xsArrayGetFloat(PlayerSupplyArrayIdX2,PlayerLocationId) ;
				float ZPosOil2 = rmPlayerLocZFraction(i) + xsArrayGetFloat(PlayerSupplyArrayIdZ2,PlayerLocationId) ;
				rmPlaceObjectDefAtLoc(Oil, i, XPosOil2, ZPosOil2);

				float OffsetX = XPosOil2-XPosOil1;
				float OffsetZ = ZPosOil2-ZPosOil1;

				// SPCXPAmmoStorehouse

				rmPlaceObjectDefAtLoc(WagonGetCorner,i,rmPlayerLocXFraction(i),ZPosOil1+OffsetZ/2);
				int WagonGetCornerUintId = rmGetUnitPlacedOfPlayer(WagonGetCorner,i);
				oxy("rule _DamageWagonGetCorner"+i+" minInterval 2 active runImmediately { ");
				oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCFortCorner\") == 1){");
				oxy("	trUnitSelectClear();");
				oxy("	trUnitSelectByID("+WagonGetCornerUintId+");");
				oxy("	trUnitChangeName(\"FixToUpdate\");");
				// 修好柱子时触发 升级时代
				oxy("	if( trUnitPercentDamaged() == 0){");
				oxy("		if(kbGetAgeForPlayer("+i+")==1){");
				oxy("			if(trPlayerResourceCount("+i+",\"Food\")>1200 && trPlayerResourceCount("+i+",\"Gold\")>1000){");
				oxy("				trPlayerSetAge("+i+", 2, true);}");
				oxy("		}｝");
				oxy("		if(kbGetAgeForPlayer("+i+")==2){");
				oxy("			if(trPlayerResourceCount("+i+",\"Food\")>2000 && trPlayerResourceCount("+i+",\"Gold\")>1200){");
				oxy("				trPlayerSetAge("+i+", 3, true);}");
				oxy("		}｝");
				oxy("		if(kbGetAgeForPlayer("+i+")==3){");
				oxy("			if(trPlayerResourceCount("+i+",\"Food\")>4000 && trPlayerResourceCount("+i+",\"Gold\")>4000){");
				oxy("				trPlayerSetAge("+i+", 3, true);}");
				oxy("		}｝");
				oxy("		trDamageUnit(50);");
				oxy("}");
				oxyZ("}/*");


				rmPlaceObjectDefAtLoc(WagonBaker,i,XPosOil1+OffsetX/2,ZPosOil1+OffsetZ/2);
				int WagonBakerUnitId = rmGetUnitPlacedOfPlayer(WagonBaker,i);
				// trCountUnitsInArea
				oxy("rule _WagonBakerConvert"+i+" minInterval 2 active { ");
				oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCXPBaker\") == 1){");
				oxy("	trUnitSelectClear();");
				oxy("	trUnitSelectByID("+WagonBakerUnitId+");");
				oxy("	trUnitChangeName(\"GetRandomWagon\");");
				oxy("	int FoodWagonCount = trCountUnitsInArea(\""+WagonBakerUnitId+"\","+i+",\"SPCXPWagonFood\",10);");
				oxy("	if(FoodWagonCount>0){");
				oxy("	trRemoveUnitsInArea("+i+",\"SPCXPWagonFood\",10);");
				oxy("	for(i=0; <FoodWagonCount){");
				oxy("		trUnitCreateFromSource(\"deMilitaryWagon\", \""+WagonBakerUnitId+"\", \""+WagonBakerUnitId+"\", "+i+");");
				oxy("	}}}");
				oxyZ("}/*");

				// deCommandery (Train SettlerWagon)

				// //SPCFortCorner
				// //ypSPCJapaneseFortCorner
				// //ypSPCIndianFortCorner
				rmPlaceObjectDefAtLoc(Miner, i, rmPlayerLocXFraction(i)+0.02, rmPlayerLocZFraction(i)+0.02);
				rmPlaceObjectDefAtLoc(Surgeon, i , rmPlayerLocXFraction(i)-0.02, rmPlayerLocZFraction(i)-0.02);
			}

			//放置起始单位
			// rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
			// rmPlaceObjectDefAtLoc(startingUnits, i, 0.5, 0.5);

			// deSPCCapturableFactory
			// deArtilleryFoundryWagon
			// deTavernWagon
			// YPStableWagon
			// deREVFilibuster
			// ypSPCBrahminHealer
			// tech SPCXPValleyForge



			//ypSPCIndianFortCorner


			// forbid walls
			// rmCreateTrigger("wallbuildlimit"+i);
			// rmSwitchToTrigger(rmTriggerID("wallbuildlimit"+i));
			// rmSetTriggerActive(true);
			// rmSetTriggerRunImmediately(true);
			// rmSetTriggerPriority(4);
			// rmAddTriggerCondition("Always");

			// rmAddTriggerEffect("Modify Protounit");
			// rmSetTriggerEffectParam("Protounit", "WallStraight5");
			// rmSetTriggerEffectParamInt("PlayerID", i);
			// rmSetTriggerEffectParamInt("Field", 10);		// build limit
			// rmSetTriggerEffectParamInt("Delta", 1, false);		// none

			// rmAddTriggerEffect("Modify Protounit");
			// rmSetTriggerEffectParam("Protounit", "WallStraight2");
			// rmSetTriggerEffectParamInt("PlayerID", i);
			// rmSetTriggerEffectParamInt("Field", 10);		// build limit
			// rmSetTriggerEffectParamInt("Delta", 1, false);		// none
		}

		// 主城访问相关触发
		// int HCAccessWall = rmCreateObjectDef("HCAccessWall");
		// rmAddObjectDefItem(HCAccessWall,"SPCFortWallSmall",1,0);
		// rmPlaceObjectDefAtLoc(HCAccessWall,1,0.92,0.54);
		// //int HCAccessWallUintId = rmGetUnitPlacedOfPlayer(HCAccessWall,1);

		// oxy("rule _TimerAccessHC active runImmediately { ");
		// oxy("trCounterAddTime(\"countdown\", 30, 0, \"P1 can delete your wall to enable shipping\", 0);");
		// oxy("trMessageSetText(\"I am the author of this map called Evianaive.P1 can delete your wall to enable shipping! Get Military Wagon in your baker! The factory can be occupied by your force! Enjoy you self.\",-1);");
		// oxy("xsDisableRule(\"_TimerAccessHC\");");
		// oxyZ("}/*");

		// oxy("rule _ForbidHC active runImmediately { ");
		// oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
		// oxy("trPlayerSetHCAccess(i,false);");
		// oxy("}");
		// oxy("xsDisableRule(\"_ForbidHC\");");
		// oxyZ("}/*");

		// oxy("rule _AccessHC active runImmediately { ");
		// oxy("if((trTime()-cActivationTime)<=30){");
		// oxy("if( trPlayerUnitCountSpecific(1,\"SPCFortWallSmall\") == 0){");
		// oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
		// oxy("trPlayerSetHCAccess(i,true);");
		// oxy("}");
		// oxy("xsDisableRule(\"_AccessHC\");");
		// oxy("}");
		// oxy("}");
		// oxyZ("}/*");


		// rmCreateTrigger("SetStartAge");
		// rmSwitchToTrigger(rmTriggerID("SetStartAge"));
		// rmSetTriggerActive(true);
		// rmSetTriggerRunImmediately(true);
		// oxyA("}}*/");

		rmSetStatusText("",0.50);//读取地图进度条

//    bool bVar0 = (trCountUnitsInArea("51",1,"xpDogSoldier",1) <= 1);


//    bool tempExp = (bVar0);
//    if (tempExp)
//    {
//       trUnitSelectClear();
//       trUnitSelectByID(21);
//       trUnitConvert(1);
//       xsDisableRule("_Trigger_7");
//       trEcho("Trigger disabling rule Trigger_7");
//    }



		rmSetStatusText("",1.00);//读取地图进度条
	} //END
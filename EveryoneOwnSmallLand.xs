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
		float SegmentFraction = 0.032;
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

	void xsSetXZFloatArrayPair(int Index=0,float X=0.0,float Z=0.0,int XArrayId=0,int ZArrayId=0)//声明函数必须要写默认值
	{
		xsArraySetFloat(XArrayId,Index,X);
		xsArraySetFloat(ZArrayId,Index,Z);
	}

	void main(void)
	{
		// ---------------------------------------- Map Info -------------------------------------------
		int playerTilesX=240;			//设定地图X大小
		int playerTilesZ=240;			//设定地图Z大小（帝国3的Y是高度，Z才是我们平常所用到的Y）


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
		xsSetXZFloatArrayPair(0,0.48,0.78,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(0,0.76,0.78,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 1 to 2 1
		xsSetXZFloatArrayPair(1,0.74,0.74,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(1,0.74,0.46,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 3 to 8
		xsSetXZFloatArrayPair(2,0.56,0.22,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(2,0.56,0.50,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 2 to 8 1
		xsSetXZFloatArrayPair(3,0.48,0.41,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(3,0.76,0.41,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 2 to 8 2
		xsSetXZFloatArrayPair(4,0.48,0.50,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(4,0.76,0.50,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 7 to 8
		xsSetXZFloatArrayPair(5,0.46,0.72,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(5,0.46,0.44,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 1 to 8
		xsSetXZFloatArrayPair(6,0.56,0.64,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(6,0.56,0.36,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(7,0.56,0.64,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(7,0.84,0.64,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 3 to 4
		xsSetXZFloatArrayPair(8,0.64,0.18,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(8,0.36,0.18,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 5 to 8 1
		xsSetXZFloatArrayPair(9,0.18,0.34,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(9,0.46,0.34,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(10,0.46,0.34,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(10,0.46,0.62,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 4 to 8
		xsSetXZFloatArrayPair(11,0.34,0.02,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(11,0.34,0.34,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 5 to 8 2
		xsSetXZFloatArrayPair(12,0.12,0.44,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(12,0.40,0.44,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 5 to 6
		xsSetXZFloatArrayPair(13,0.20,0.38,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(13,0.20,0.66,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 4 to 5
		xsSetXZFloatArrayPair(14,0.18,0.20,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(14,0.46,0.18,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(15,0.18,0.20,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(15,0.18,0.42,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 6 to 8
		xsSetXZFloatArrayPair(16,0.32,0.80,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(16,0.32,0.52,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(17,0.32,0.52,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(17,0.58,0.52,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 6 to 7
		xsSetXZFloatArrayPair(18,0.20,0.66,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(18,0.38,0.84,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(19,0.42,0.80,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(19,0.22,1.00,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 2 to 3
		xsSetXZFloatArrayPair(20,0.82,0.48,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(20,0.82,0.20,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(21,0.82,0.20,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(21,0.54,0.20,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road 1 to 2 2
		xsSetXZFloatArrayPair(22,0.76,0.70,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(22,0.92,0.54,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(23,1.00,0.62,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(23,0.82,0.44,RoadArrayEndIdX,RoadArrayEndIdZ);

		//Road Other
		xsSetXZFloatArrayPair(24,0.00,0.76,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(24,0.20,0.56,RoadArrayEndIdX,RoadArrayEndIdZ);

		xsSetXZFloatArrayPair(25,0.62,0.80,RoadArrayStartIdX,RoadArrayStartIdZ);
		xsSetXZFloatArrayPair(25,0.62,0.98,RoadArrayEndIdX,RoadArrayEndIdZ);

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
			float Size = 0.008 *(Length/0.28)*(300.0/playerTilesX);

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


		//油田1偏移值数组
		int PlayerSupplyArrayIdX = xsArrayCreateFloat(8,0.0,"PlayerSupplyX");
		int PlayerSupplyArrayIdZ = xsArrayCreateFloat(8,0.0,"PlayerSupplyZ");

		xsSetXZFloatArrayPair(0,0.07,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(1,0.07,-0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(2,0.07,-0.065,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(3,0.07,-0.065,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(4,-0.075,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(5,-0.075,0.07,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(6,0.04,0.065,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);
		xsSetXZFloatArrayPair(7,-0.02,0.03,PlayerSupplyArrayIdX,PlayerSupplyArrayIdZ);

		//油田2偏移值数组
		int PlayerSupplyArrayIdX2 = xsArrayCreateFloat(8,0.0,"PlayerSupplyX2");
		int PlayerSupplyArrayIdZ2 = xsArrayCreateFloat(8,0.0,"PlayerSupplyZ2");

		xsSetXZFloatArrayPair(0, 0.01, 0.07, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);
		xsSetXZFloatArrayPair(1, 0.07, -0.015, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);
		xsSetXZFloatArrayPair(2, 0.01, -0.065, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);
		xsSetXZFloatArrayPair(3, 0.01, -0.065, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);
		xsSetXZFloatArrayPair(4, -0.075, 0.02, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);
		xsSetXZFloatArrayPair(5, -0.075, 0.02, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);
		xsSetXZFloatArrayPair(6, -0.02, 0.065, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);
		xsSetXZFloatArrayPair(7, -0.02, -0.02, PlayerSupplyArrayIdX2, PlayerSupplyArrayIdZ2);

		//面包店偏移值数组
		int BakerArrayIdX = xsArrayCreateFloat(8,0.0,"PlayerBakerX2");
		int BakerArrayIdZ = xsArrayCreateFloat(8,0.0,"PlayerBakerZ2");

		xsSetXZFloatArrayPair(0, -0.01, 0.07, BakerArrayIdX, BakerArrayIdZ);
		xsSetXZFloatArrayPair(1, 0.07, 0.015, BakerArrayIdX, BakerArrayIdZ);
		xsSetXZFloatArrayPair(2, -0.01, -0.065, BakerArrayIdX, BakerArrayIdZ);
		xsSetXZFloatArrayPair(3, -0.01, -0.065, BakerArrayIdX, BakerArrayIdZ);
		xsSetXZFloatArrayPair(4, -0.075, -0.01, BakerArrayIdX, BakerArrayIdZ);
		xsSetXZFloatArrayPair(5, -0.075, -0.01, BakerArrayIdX, BakerArrayIdZ);
		xsSetXZFloatArrayPair(6, 0, 0.03, BakerArrayIdX, BakerArrayIdZ);
		xsSetXZFloatArrayPair(7, 0.015, 0.02, BakerArrayIdX, BakerArrayIdZ);

		//玩家所在位置的Id
		int PlayerLocationArrayId = xsArrayCreateInt(8,0,"PlayerLocationId");
		//rmPlacePlayersCircular(0.35, 0.35, 0.0);   	//圆形放置玩家
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


		//玩家起始位置周围地形
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
		bool UseFactory = false;

		//声明火药仓库
		int DeDepot = rmCreateObjectDef("DeDepot");
		rmAddObjectDefItem(DeDepot,"deDepot",1,0);

		//deSPCSupplyCache
		//deSPCCommandPost
		//定义未知矿工 deREVFilibuster
		int Miner = rmCreateObjectDef("Miner");
		rmAddObjectDefItem(Miner,"deMiner",1,0);
		rmSetObjectDefMinDistance(Miner, 0.0);
		rmSetObjectDefMaxDistance(Miner, 10.0);

		//定义军医
		int Surgeon = rmCreateObjectDef("Surgeon");
		rmAddObjectDefItem(Surgeon,"Surgeon",1,0);
		rmSetObjectDefMinDistance(Surgeon, 0.0);
		rmSetObjectDefMaxDistance(Surgeon, 10.0);

		//定义起始单位（civs.xml定义那些开局单位）
		int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
		rmSetObjectDefMinDistance(startingUnits, 6.0);
		rmSetObjectDefMaxDistance(startingUnits, 10.0);

		//设定获取马车的单位
		int WagonGetCorner = rmCreateObjectDef("WagonGetCorner");
		rmAddObjectDefItem(WagonGetCorner,"SPCFortCorner",1,0);
		// rmSetObjectDefMinDistance(WagonGetCorner, 0.0);
		// rmSetObjectDefMaxDistance(WagonGetCorner, 0.0);

		int WagonBaker = rmCreateObjectDef("WagonBaker");
		rmAddObjectDefItem(WagonBaker,"SPCXPBaker",1.0);

		// 判断是否是游牧时代开局
		if (rmGetNomadStart())
		{
			rmAddObjectDefItem(Oil, "deSPCCommandPost", 1, 0.0);
		}
		else
		{
			if(UseFactory)
			{
				rmAddObjectDefItem(Oil, "deSPCCapturableFactory",1,0);
				// rmSetObjectDefMinDistance(Oil, 0.0);
				// rmSetObjectDefMaxDistance(Oil, 2.0);
				OilName = "deSPCCapturableFactory";
			}
			else{
				rmAddObjectDefItem(Oil,"deSPCSupplyCache",1,0);
				// rmSetObjectDefMinDistance(Oil, 0.0);
				// rmSetObjectDefMaxDistance(Oil, 2.0);
				OilName = "deSPCSupplyCache";
				// rmAddObjectDefItem(Oil,"ypWCPorcelainTower5",1,0);
				// OilName = "ypWCPorcelainTower5";
			}


			rmCreateTrigger("OilModeBegin");
			rmSwitchToTrigger(rmTriggerID("OilModeBegin"));
			rmSetTriggerActive(false);
			oxyA("}}");

			for(i=1; <=cNumberNonGaiaPlayers){

				//对无酒馆国家启用酒馆
				// oxy("rule _activatetaverns"+i+" active runImmediately { ");
				// if (rmGetPlayerCiv(i) == rmGetCivID("XPAztec") || rmGetPlayerCiv(i) == rmGetCivID("XPSioux") || rmGetPlayerCiv(i) == rmGetCivID("XPIroquois") || rmGetPlayerCiv(i) == rmGetCivID("DEInca") ||
				// // rmGetPlayerCiv(i) == rmGetCivID("Chinese") || rmGetPlayerCiv(i) == rmGetCivID("Japanese") || rmGetPlayerCiv(i) == rmGetCivID("Indians") ||
				// rmGetPlayerCiv(i) == rmGetCivID("DEHausa") || rmGetPlayerCiv(i) == rmGetCivID("DEEthiopians") || rmGetPlayerCiv(i) == rmGetCivID("DEItalians"))
				// {
				// 	oxy("trUnforbidProtounit("+i+", \"deTavern\");");
				// 	// oxy("trTechSetStatus("+i+",10412,2);")
				// 	// oxy("trUnforbidProtounit("+i+", \"Saloon\");");
				// 	oxy("xsDisableRule(\"_activatetaverns"+i+"\");");
				// }
				// oxy("trUnforbidProtounit("+i+", \"SaloonOutlawRifleman\");");
				// oxy("trUnforbidProtounit("+i+", \"SaloonOutlawPistol\");");
				// oxy("trUnforbidProtounit("+i+", \"SaloonOutlawRider\");");
				// oxy("trUnforbidProtounit("+i+", \"MercJaeger\");");
				// oxy("trUnforbidProtounit("+i+", \"MercLandsknecht\");");
				// //oxy("trUnforbidProtounit("+i+", \"MercMameluke\");");
				// oxy("trUnforbidProtounit("+i+", \"MercHighlander\");");
				// oxy("trUnforbidProtounit("+i+", \"MercBlackRider\");");
				// oxy("trUnforbidProtounit("+i+", \"MercBarbaryCorsair\");");
				// oxyZ("} /*");


				// 无建筑时结束
				oxy("rule _DetectBuildingCount"+i+" active runImmediately { ");
				oxy("int BuildingNotCount = trPlayerUnitCountSpecific("+i+",\""+OilName+"\") + trPlayerUnitCountSpecific("+i+",\"deDepot\");");
				// oxy("int BakerCount = trPlayerUnitCountSpecific("+i+",\"SPCXPBaker\");");
				oxy("int BuildingCount = trPlayerBuildingCount("+i+");");//不计算围墙
				// if(i == 1)
				// {
				// 	oxy("trChatSend(1, \"BuildingCount is \"+BuildingCount+\"\");");//调试用
				// }
				oxy("if(trPlayerBuildingCount("+i+")-BuildingNotCount==0){");
				//oxy("if(trPlayerValidUnitAndBuildingCount("+i+")==0){");
				oxy("	trSetPlayerDefeated("+i+");");
				oxy("	xsDisableRule(\"_DetectBuildingCount"+i+"\");");
				oxy("}");
				oxyZ("}/*");
			}

			// oxy("rule _SetAutoConvert"+i+" active runImmediately { ");
			// oxy("trModifyProtounitAction(\"deSPCSupplyCache\", "+i+", 0, 4000);");
			// oxy("xsDisableRule(\"_SetAutoConvert"+i+"\");");
			// oxyZ("} /*");
			
			oxy("rule _StartSettings active runImmediately { ");
			for(i=1; <=cNumberNonGaiaPlayers)
			{
				oxy("if(kbGetAgeForPlayer("+i+")<1){ trPlayerSetAge("+i+", 1, true); }");// 如果没到时代2，设置玩家时代为时代2
				oxy("trPlayerGrantResources("+i+",\"Food\", 2000);");// 开局送2000资源
				oxy("trPlayerGrantResources("+i+",\"Wood\", 2000);");// 开局送2000资源
				oxy("trPlayerGrantResources("+i+",\"Gold\", 2000);");// 开局送2000资源
				oxy("trModifyPlayerData("+i+",0,-1,300,0);");// 人口加满
			}
			oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
			// 血量修改相关,i表示玩家序号，0为血量的field，5000.0为数值(填5000也可)，1为修改的方式为设置
			oxy("	trModifyProtounitData(\"SPCFortCorner\", i, 0, 15000.0, 1);");// 修改城墙墙角血量			
			oxy("	trModifyProtounitData(\"SPCXPBaker\", i, 0, 10000.0, 1);");// 修改面包房血量			
			oxy("	trModifyProtounitData(\"deMiner\", i, 0, 1500.0, 1);");// 修改矿工血量为1500;
			oxy("	trModifyProtounitData(\"Surgeon\", i, 0, 200.0, 1);");// 修改军医血量为100
			oxy("	trModifyProtounitData(\"deImperialWagon\", i, 0, 250.0, 1);");// 修改帝国战争马车血量为250
			// 启用单位
			oxy("	trUnforbidProtounit(i, \"SPCXPWagonFood\");");// 启用食物车
			oxy("	trUnforbidProtounit(i, \"Surgeon\");");// 启用军医
			oxy("	trUnforbidProtounit(i, \"FieldHospital\");");// 启用医院
			// 关闭单位
			oxy("	trForbidProtounit(i, \"Saloon\");");//关闭酒馆
			oxy("	trForbidProtounit(i, \"deTavern\");");//关闭酒馆
			oxy("	trForbidProtounit(i, \"ypMonastery\");");//关闭修道院(不清楚名称是否正确)
			oxy("	trForbidProtounit(i, \"deStateCapitolTrainCoveredWagon\");");//关闭一系列州议会马车
			oxy("	trForbidProtounit(i, \"deStateCapitolTrainMillWagon\");");
			oxy("	trForbidProtounit(i, \"deStateCapitolTrainHaciendaWagon\");");
			oxy("	trForbidProtounit(i, \"deStateCapitolTrainTradingPostWagon\");");
			oxy("	trForbidProtounit(i, \"deStateCapitolTrainOutpostWagon\");");
			oxy("	trForbidProtounit(i, \"deStateCapitolTrainPlantationWagon\");");
			oxy("	trForbidProtounit(i, \"deStateCapitolTrainBankWagon\");");
			// 调整食物马车价格
			oxy("	trModifyProtounit(\"SPCXPWagonFood\", i, 15, -100);"); //15表示金子，这句意思是玩家i的马车金价-100
			oxy("	trModifyProtounit(\"SPCXPWagonFood\", i, 16, 400);"); //16表示木头
			// 调整Action开关
			oxy("	trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherFoodTeam\", i, 5, 0, 0);");//关闭工厂队伍采肉
			oxy("	trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherWoodTeam\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherCoinTeam\", i, 5, 0, 0);");
			//禁用村民建造建筑
			oxy("	trModifyProtounitAction(\"ypSettlerIndian\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"ypSettlerJapanese\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"ypSettlerAsian\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"deSettlerAfrican\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"Settler\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"Coureur\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"deArchitect\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"SettlerNative\", \"Build\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"SettlerWagon\", \"Build\", i, 5, 0, 0);");
			//禁用村民收集
			oxy("	trModifyProtounitAction(\"ypSettlerIndian\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"ypSettlerJapanese\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"ypSettlerAsian\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"deSettlerAfrican\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"Settler\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"Coureur\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"deArchitect\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"SettlerNative\", \"Gather\", i, 5, 0, 0);");
			oxy("	trModifyProtounitAction(\"SettlerWagon\", \"Gather\", i, 5, 0, 0);");

			// 调整科技状态
			oxy("	trTechSetStatus(i, 416, 2);");// 工厂三个科技已经研究
			oxy("	trTechSetStatus(i, 417, 2);");
			oxy("	trTechSetStatus(i, 418, 2);");
			oxy("	trTechSetStatus(i, 1005, 0);");// 工厂造炮加速科技状态为0（不可研究），1为可研究，2为已经研究
			oxy("	trTechSetStatus(i, 446, 2);");// Spy科技
			oxy("	trTechSetStatus(i, 1539, 2);");// Spy科技
			// <tech name="DEHCFedMXBustamante" type="Normal">
			// <tech name="DEHCSPCLincolnMilitia" type="Normal">
			// <tech name="DEHCFedMoultriesMilitia" type="Normal">

			oxy("}");
			oxy("xsDisableRule(\"_StartSettings\");");//关闭_StartSettings这个触发，即关闭本触发
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
			int ArrayIndex = i-1;
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
				int Oil1UnitId = rmGetUnitPlacedOfPlayer(Oil,i);

				float XPosOil2 = rmPlayerLocXFraction(i) + xsArrayGetFloat(PlayerSupplyArrayIdX2,PlayerLocationId) ;
				float ZPosOil2 = rmPlayerLocZFraction(i) + xsArrayGetFloat(PlayerSupplyArrayIdZ2,PlayerLocationId) ;
				rmPlaceObjectDefAtLoc(Oil, i, XPosOil2, ZPosOil2);

				float OffsetX = XPosOil2-XPosOil1;
				float OffsetZ = ZPosOil2-ZPosOil1;
				// SPCXPAmmoStorehouse

				rmPlaceObjectDefAtLoc(WagonGetCorner,i,rmPlayerLocXFraction(i),rmPlayerLocZFraction(i));
				int WagonGetCornerUintId = rmGetUnitPlacedOfPlayer(WagonGetCorner,i);
				oxy("rule _RenameCorner"+i+" active minInterval 5 runImmediately { ");
				oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCFortCorner\") == 1){");
				oxy("	trUnitSelectClear();");
				oxy("	trUnitSelectByID("+WagonGetCornerUintId+");");
				oxy("	trUnitChangeName(\"FixToUpdate\");");//更改名字，乱码部分是中文
				oxy("	trDamageUnit(50);");//扣50血，防止触发自动升级
				oxy("	if(trUnitPercentDamaged()>0.01){");//如果trigger选择到的物体受伤高于%1
				oxy("		xsDisableRule(\"_RenameCorner"+i+"\");");//关闭这个触发
				oxy("		xsEnableRule(\"_DamageWagonGetCorner"+i+"\");");//启用这个名称的触发
				oxy("	}");
				oxy("}");
				oxyZ("}/*");				

				//trTime()-cActivationTime
				oxy("rule _DamageWagonGetCorner"+i+" minInterval 2 inactive { ");//inactive为默认关闭
				oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCFortCorner\") == 1){");
				oxy("	trUnitSelectClear();");
				oxy("	trUnitSelectByID("+WagonGetCornerUintId+");");
				// 修好柱子时触发 升级时代
				oxy("	if( trUnitPercentDamaged() == 0){");
				oxy("		if(kbGetAgeForPlayer("+i+")==1){");//这个表示当前为时代2
				oxy("			if(trPlayerResourceCount("+i+",\"Food\")>1200 && trPlayerResourceCount("+i+",\"Gold\")>1000){");
				oxy("				trPlayerGrantResources("+i+",\"Food\", -1200);");
				oxy("				trPlayerGrantResources("+i+",\"Gold\", -1000);");
				oxy("				trPlayerSetAge("+i+", 2, true);}");
				oxy("		}");
				oxy("		if(kbGetAgeForPlayer("+i+")==2){");
				oxy("			if(trPlayerResourceCount("+i+",\"Food\")>2000 && trPlayerResourceCount("+i+",\"Gold\")>1200){");
				oxy("				trPlayerGrantResources("+i+",\"Food\", -2000);");
				oxy("				trPlayerGrantResources("+i+",\"Gold\", -1200);");
				oxy("				trPlayerSetAge("+i+", 3, true);}");
				oxy("		}");
				oxy("		if(kbGetAgeForPlayer("+i+")==3){");
				oxy("			if(trPlayerResourceCount("+i+",\"Food\")>4000 && trPlayerResourceCount("+i+",\"Gold\")>4000){");
				oxy("				trPlayerGrantResources("+i+",\"Food\", -4000);");
				oxy("				trPlayerGrantResources("+i+",\"Gold\", -4000);");
				oxy("				trPlayerSetAge("+i+", 4, true);}");
				oxy("		}");
				oxy("		trDamageUnit(100);");
				oxy("   }");
				oxy("}");
				oxyZ("}/*");

				float XPosBaker = rmPlayerLocXFraction(i) + xsArrayGetFloat(BakerArrayIdX,PlayerLocationId) ;
				float ZPosBaker = rmPlayerLocZFraction(i) + xsArrayGetFloat(BakerArrayIdZ,PlayerLocationId) ;
				rmPlaceObjectDefAtLoc(WagonBaker,i,XPosBaker,ZPosBaker);
				int WagonBakerUnitId = rmGetUnitPlacedOfPlayer(WagonBaker,i);
				oxy("rule _WagonBakerConvert"+i+" minInterval 2 active { ");
				oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCXPBaker\") == 1){");
				oxy("	trUnitSelectClear();");
				oxy("	trUnitSelectByID("+WagonBakerUnitId+");");
				oxy("	trUnitChangeName(\"GetRandomWagon\");");
				oxy("	int FoodWagonCount = trCountUnitsInArea(\""+WagonBakerUnitId+"\","+i+",\"SPCXPWagonFood\",10);");
				oxy("	if(FoodWagonCount>0){");
				oxy("	trRemoveUnitsInArea("+i+",\"SPCXPWagonFood\",10);");
				oxy("	for(i=0; <FoodWagonCount){");
				oxy("		trUnitCreateFromSource(\"deImperialWagon\", \""+WagonBakerUnitId+"\", \""+WagonBakerUnitId+"\", "+i+");");
				oxy("	}}}");
				oxyZ("}/*");

				// 仓库触发
				rmPlaceObjectDefAtLoc(DeDepot,i,XPosOil1+OffsetX/2,ZPosOil1+OffsetZ/2);
				int DeDepotUnitId = rmGetUnitPlacedOfPlayer(DeDepot,i);
				oxy("rule _DeDepotBoom"+i+" minInterval 2 active { ");
				oxy("trUnitSelectClear();");
				oxy("trUnitSelectByID("+DeDepotUnitId+");");
				oxy("if( trUnitDead()==true ){");
				// oxy("	trChatSend("+i+", \"BuildingCount is "+DeDepotUnitId+"\");");
				oxy("	for(i=1; <="+cNumberNonGaiaPlayers+"){");
				oxy("		trUnitSelectClear();");
				oxy("		trUnitSelectByID("+Oil1UnitId+");");
				oxy("		trUnitSelectByID("+(Oil1UnitId+1)+");");
				// oxy("		trUnitDelete(false);");
				// oxy("		trChatSend(1,\"_DeDepotBoom"+i+"\");");
				oxy("		trRemoveUnitsInArea(i,\""+OilName+"\",20);");
				oxy("	}");
				oxy("	xsDisableRule(\"_DeDepotBoom"+i+"\");");//关闭这个触发
				oxy("}");
				oxy("else{");
				// oxy("	int i=1;");
				// oxy("	while(i<="+cNumberNonGaiaPlayers+"){");
				oxy("	trUnitSelectByID("+Oil1UnitId+");");
				oxy("	trUnitSelectByID("+(Oil1UnitId+1)+");");
				// trConvertUnitsInArea(1,1,"Unit",10);
				oxy("	for(i=1; <="+cNumberNonGaiaPlayers+"){");
				oxy("		if(trUnitIsNotOwnedBy(i)){");
				oxy("			int PlayerISurgeonCount = trCountUnitsInArea(\""+DeDepotUnitId+"\",i,\"deImperialWagon\",10);");
				oxy("			if(PlayerISurgeonCount>0){");
				oxy("				trUnitConvert(i);");
				oxy("				trUnitSelectClear();");
				oxy("				trUnitSelectByID("+DeDepotUnitId+");");
				oxy("				trRemoveUnitsInArea(i,\"deImperialWagon\",10);");
				// oxy("				trChatSend(i, \"BuildingCount is "+DeDepotUnitId+"\");");
				// oxy("		trRemoveUnitsInArea(0,\""+OilName+"\",10);");
				// oxy("		trRemoveUnitsInArea(2,\""+OilName+"\",10);");
				// oxy("				i = i+8;");
				oxy("				break;");
				oxy("			}");
				oxy("		}");
				// oxy("		i = i+1;");
				oxy("	}");
				oxy("}");
				oxyZ("}/*");

				oxy("rule _PlayerDefeated"+i+" minInterval 2 active { ");
				oxy("	bool Defeated = trPlayerDefeated("+i+");");
				oxy("	if(Defeated){");
				oxy("		trPlayerKillAllBuildings("+i+");");
				oxy("	}");
				//oxy("	xsDisableRule(\"_PlayerDefeated"+i+"\");");
				oxyZ("}/*");

				// oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCXPBaker\") == 1){");
				// oxy("}");


				// trPlayerKillAllBuildings
				// trPlayerKillAllUnits
				// oxy("rule _CaptureOil"+i+" minInterval 2 active { ");
				// oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCXPBaker\") == 1){");
				// oxy("	trUnitSelectClear();");
				// oxy("	trUnitSelectByID("+WagonBakerUnitId+");");
				// // kbUnitGetPlayerID
				// // oxy("	int FoodWagonCount = trCountUnitsInArea(\""+WagonBakerUnitId+"\","+i+",\"SPCXPWagonFood\",10);");
				// // oxy("	if(FoodWagonCount>0){");
				// // oxy("	trRemoveUnitsInArea("+i+",\"SPCXPWagonFood\",10);");
				// // oxy("	for(i=0; <FoodWagonCount){");
				// // oxy("		trUnitCreateFromSource(\"deImperialWagon\", \""+WagonBakerUnitId+"\", \""+WagonBakerUnitId+"\", "+i+");");
				// // oxy("	}}");
				// // oxy("	int PlayerId = trCurrentPlayer();");
				// // oxy("	int PlayerLocationArrayId = xsArrayCreateInt(8,0,\"PlayerLocationId\");");
				// // oxy("	int PlayerId = xsArrayGetInt(PlayerLocationArrayId,"+ArrayIndex+");");
				// // oxy("	int PlayerId = kbUnitGetPlayerID("+WagonBakerUnitId+");");
				// oxy("	trChatSend(1, \"BuildingCount is \"+PlayerId+\"\");");
				// oxy("}");
				// oxy("else{");
				// oxy("	");
				// oxy("}");
				// oxyZ("}/*");

				// for(int j=1;<=cNumberNonGaiaPlayers)
				// {
				// 	string BeginState = "active";
				// 	if(i==j)
				// 	{
				// 		BeginState = "inactive";
				// 	}
				// 	// string NameTriggerjCapi = "_CaptureOil"+i+""+j;
				// 	oxy("rule _CaptureOil"+i+""+j+" minInterval 2 "+BeginState+" { ");
				// 	oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCXPBaker\") == 1){");
				// 	oxy("	trUnitSelectClear();");
				// 	oxy("	trUnitSelectByID("+WagonBakerUnitId+");");
				// 	oxy("	int SurgeonCount = trCountUnitsInArea(\""+WagonBakerUnitId+"\","+j+",\"Surgeon\",1);");
				// 	oxy("	if(SurgeonCount>0){");
				// 	oxy("		trRemoveUnitsInArea("+j+",\"Surgeon\",1.5);");
				// 	oxy("		trUnitConvert("+j+");");
				// 	oxy("		for(int p;<=cNumberNonGaiaPlayers){");
				// 	oxy("			if(p!="+j+"){xsEnableRule(\"_CaptureOil"+i+"+\"p\"+\");}");
				// 	oxy("		}");
				// 	oxy("		xsDisableRule(\"_CaptureOil"+i+""+j+"\");");
				// 	oxy("	}");
				// 	oxy("}");
				// 	oxyZ("}/*");
				// }
				




				// 放置矿工
				rmPlaceObjectDefAtLoc(Miner, i, rmPlayerLocXFraction(i)+0.02, rmPlayerLocZFraction(i)+0.02);
				// 放置军医
				rmPlaceObjectDefAtLoc(Surgeon, i , rmPlayerLocXFraction(i)-0.02, rmPlayerLocZFraction(i)-0.02);

				//放置起始单位
				// rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
			}

			// deSPCCapturableFactory
			// deArtilleryFoundryWagon
			// deTavernWagon
			// YPStableWagon
			// deREVFilibuster
			// ypSPCBrahminHealer
			// tech SPCXPValleyForge
			// deCommandery (Train SettlerWagon)

			// //SPCFortCorner
			// //ypSPCJapaneseFortCorner
			// //ypSPCIndianFortCorner


			//ypSPCIndianFortCorner
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

		oxy("rule _ForbidHC active runImmediately { ");
		oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
		oxy("trPlayerSetHCAccess(i,false);");
		oxy("}");
		oxy("xsDisableRule(\"_ForbidHC\");");
		oxyZ("}/*");

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
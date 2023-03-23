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

				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ, EndX, 0.42);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.02, EndX, 0.44);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.04, EndX, 0.46);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.06, EndX, 0.48);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.08, EndX, 0.50);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.10, EndX, 0.52);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.12, EndX, 0.54);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.14, EndX, 0.56);
				// rmAddAreaInfluenceSegment(AreaId, StartX, StartZ+0.16, EndX, 0.58);
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
	} // end ypRicePaddyBuilder

	void main(void)
	{
		// ---------------------------------------- Map Info -------------------------------------------
		int playerTilesX=300;			//设定地图X大小
		int playerTilesZ=300;			//设定地图Z大小（帝国3的Y是高度，Z才是我们平常所用到的Y）



		//如果玩家大于4
		//if (cNumberNonGaiaPlayers >4){	playerTilesX=11500;	playerTilesZ=11500;}


		string MapTerrain ="Carolinas\ground_marsh3_car";	//<-------- 地图地形，自己参照剧情编辑器 <--------

		string MapLighting ="319a_Snow";			//<-------- 照明，自己参照剧情编辑器 <--------

		string PlayerTerrain ="Carolinas\ground_marsh1_car";	//<--------- 玩家范围地形 <---------


		//设定地图XZ大小
		rmSetMapSize(playerTilesX, playerTilesZ);

		rmSetMapElevationParameters(cElevTurbulence, 0.15, 2.5, 0.35, 3.0); // type, frequency, octaves, persistence, variation
		rmSetMapElevationHeightBlend(1.0);
		//地形初始化，设定地图初始地形，调用上面用string定义MapTerrain，即为"Carolinas\ground_marsh3_car";
		rmTerrainInitialize(MapTerrain,6);


		//
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


		// int SandGround=rmCreateArea("SandGround");
		// rmSetAreaSize(SandGround, 0.1, 0.1);
		// rmSetAreaLocation(SandGround, 0.5, 0.5);
		// rmSetAreaWarnFailure(SandGround, true);
		// rmSetAreaSmoothDistance(SandGround, 0);
		// rmSetAreaCoherence(SandGround, 1);
		// rmSetAreaMix(SandGround, "borneo\ground_sand1_borneo");//africa\desert_sand2_africa
		// // rmSetAreaElevationType(SandGround, cElevTurbulence);
	  	// // rmSetAreaElevationVariation(SandGround, 4.0);
		// rmSetAreaBaseHeight(SandGround, 4.0);
		// rmSetAreaObeyWorldCircleConstraint(SandGround, false);
		// rmSetAreaHeightBlend(SandGround, 0);
		// rmSetAreaReveal(SandGround, 1);
		// rmBuildArea(SandGround);

		// int SandGroundSegment=rmCreateArea("SandGroundSegment");
		// rmSetAreaSize(SandGroundSegment, 0.05, 0.05);
		// rmSetAreaLocation(SandGroundSegment, 0.8, 0.8);
		// rmSetAreaWarnFailure(SandGroundSegment, true);
		// rmSetAreaSmoothDistance(SandGroundSegment, 0);
		// rmSetAreaCoherence(SandGroundSegment, 1);
		// rmSetAreaMix(SandGroundSegment, "himalayas_a");
		// rmSetAreaElevationType(SandGroundSegment, cElevNormal);//
		// rmSetAreaElevationVariation(SandGroundSegment, 0.0);
		// rmSetAreaBaseHeight(SandGroundSegment, 1.0);
		// rmSetAreaHeightBlend(SandGroundSegment, 1);
		// rmSetAreaElevationOctaves(SandGroundSegment, 0);

		// rmAddAreaInfluenceSegment(SandGroundSegment, 0.8, 0.8, 0.8, 0.1);
		// rmAddAreaInfluenceSegment(SandGroundSegment, 0.8, 0.8, 0.7, 0.1);
		// rmAddAreaInfluenceSegment(SandGroundSegment, 0.8, 0.8, 0.6, 0.1);
		// rmAddAreaInfluenceSegment(SandGroundSegment, 0.8, 0.8, 0.5, 0.1);

		int PlayerGroundArrayIdX = xsArrayCreateFloat(8,0.0,"PlayerGroundX");
		int PlayerGroundArrayIdZ = xsArrayCreateFloat(8,0.0,"PlayerGroundZ");

		xsArraySetFloat(PlayerGroundArrayIdX,0,0.76);
		xsArraySetFloat(PlayerGroundArrayIdZ,0,0.72);

		xsArraySetFloat(PlayerGroundArrayIdX,1,0.82);
		xsArraySetFloat(PlayerGroundArrayIdZ,1,0.44);

		xsArraySetFloat(PlayerGroundArrayIdX,2,0.62);
		xsArraySetFloat(PlayerGroundArrayIdZ,2,0.20);

		xsArraySetFloat(PlayerGroundArrayIdX,3,0.34);
		xsArraySetFloat(PlayerGroundArrayIdZ,3,0.14);

		xsArraySetFloat(PlayerGroundArrayIdX,4,0.14);
		xsArraySetFloat(PlayerGroundArrayIdZ,4,0.38);

		xsArraySetFloat(PlayerGroundArrayIdX,5,0.26);
		xsArraySetFloat(PlayerGroundArrayIdZ,5,0.72);

		xsArraySetFloat(PlayerGroundArrayIdX,6,0.48);
		xsArraySetFloat(PlayerGroundArrayIdZ,6,0.80);

		xsArraySetFloat(PlayerGroundArrayIdX,7,0.50);
		xsArraySetFloat(PlayerGroundArrayIdZ,7,0.48);



		int PlayerSupplyArrayIdX = xsArrayCreateFloat(8,0.0,"PlayerSupplyX");
		int PlayerSupplyArrayIdZ = xsArrayCreateFloat(8,0.0,"PlayerSupplyZ");

		xsArraySetFloat(PlayerSupplyArrayIdX,0,0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ,0,0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX,1,0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ,1,-0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX,2,0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ,2,-0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX,3,0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ,3,-0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX,4,-0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ,4,0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX,5,-0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ,5,0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX,6,0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ,6,0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX,7,0.02);
		xsArraySetFloat(PlayerSupplyArrayIdZ,7,0.07);

		int PlayerSupplyArrayIdX2 = xsArrayCreateFloat(8,0.0,"PlayerSupplyX2");
		int PlayerSupplyArrayIdZ2 = xsArrayCreateFloat(8,0.0,"PlayerSupplyZ2");

		xsArraySetFloat(PlayerSupplyArrayIdX2,0,0.0);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,0,0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX2,1,0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,1,0.0);

		xsArraySetFloat(PlayerSupplyArrayIdX2,2,0.0);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,2,-0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX2,3,-0.01);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,3,-0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX2,4,-0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,4,0.0);

		xsArraySetFloat(PlayerSupplyArrayIdX2,5,-0.07);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,5,0.0);

		xsArraySetFloat(PlayerSupplyArrayIdX2,6,-0.01);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,6,0.07);

		xsArraySetFloat(PlayerSupplyArrayIdX2,7,0.0);
		xsArraySetFloat(PlayerSupplyArrayIdZ2,7,-0.07);





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

		int RoadArrayStartIdX = xsArrayCreateFloat(26,0.0,"RoadArrayStartIdX");
		int RoadArrayStartIdZ = xsArrayCreateFloat(26,0.0,"RoadArrayStartIdZ");
		int RoadArrayEndIdX = xsArrayCreateFloat(26,0.0,"RoadArrayEndIdX");
		int RoadArrayEndIdZ = xsArrayCreateFloat(26,0.0,"RoadArrayEndIdZ");

		//Road 1 to 7
		xsArraySetFloat(RoadArrayStartIdX,0,0.48);
		xsArraySetFloat(RoadArrayStartIdZ,0,0.78);
		xsArraySetFloat(RoadArrayEndIdX,0,0.76);
		xsArraySetFloat(RoadArrayEndIdZ,0,0.78);

		//Road 1 to 2 1
		xsArraySetFloat(RoadArrayStartIdX,1,0.74);
		xsArraySetFloat(RoadArrayStartIdZ,1,0.74);
		xsArraySetFloat(RoadArrayEndIdX,1,0.74);
		xsArraySetFloat(RoadArrayEndIdZ,1,0.46);

		//Road 3 to 8
		xsArraySetFloat(RoadArrayStartIdX,2,0.56);
		xsArraySetFloat(RoadArrayStartIdZ,2,0.22);
		xsArraySetFloat(RoadArrayEndIdX,2,0.56);
		xsArraySetFloat(RoadArrayEndIdZ,2,0.50);

		//Road 2 to 8 1
		xsArraySetFloat(RoadArrayStartIdX,3,0.48);
		xsArraySetFloat(RoadArrayStartIdZ,3,0.41);
		xsArraySetFloat(RoadArrayEndIdX,3,0.76);
		xsArraySetFloat(RoadArrayEndIdZ,3,0.41);

		//Road 2 to 8 2
		xsArraySetFloat(RoadArrayStartIdX,4,0.48);
		xsArraySetFloat(RoadArrayStartIdZ,4,0.50);
		xsArraySetFloat(RoadArrayEndIdX,4,0.76);
		xsArraySetFloat(RoadArrayEndIdZ,4,0.50);

		//Road 7 to 8
		xsArraySetFloat(RoadArrayStartIdX,5,0.46);
		xsArraySetFloat(RoadArrayStartIdZ,5,0.72);
		xsArraySetFloat(RoadArrayEndIdX,5,0.46);
		xsArraySetFloat(RoadArrayEndIdZ,5,0.44);

		//Road 1 to 8
		xsArraySetFloat(RoadArrayStartIdX,6,0.56);
		xsArraySetFloat(RoadArrayStartIdZ,6,0.64);
		xsArraySetFloat(RoadArrayEndIdX,6,0.56);
		xsArraySetFloat(RoadArrayEndIdZ,6,0.36);

		xsArraySetFloat(RoadArrayStartIdX,7,0.56);
		xsArraySetFloat(RoadArrayStartIdZ,7,0.64);
		xsArraySetFloat(RoadArrayEndIdX,7,0.84);
		xsArraySetFloat(RoadArrayEndIdZ,7,0.64);

		//Road 3 to 4
		xsArraySetFloat(RoadArrayStartIdX,8,0.64);
		xsArraySetFloat(RoadArrayStartIdZ,8,0.18);
		xsArraySetFloat(RoadArrayEndIdX,8,0.36);
		xsArraySetFloat(RoadArrayEndIdZ,8,0.18);

		//Road 5 to 8 1
		xsArraySetFloat(RoadArrayStartIdX,9,0.18);
		xsArraySetFloat(RoadArrayStartIdZ,9,0.34);
		xsArraySetFloat(RoadArrayEndIdX,9,0.46);
		xsArraySetFloat(RoadArrayEndIdZ,9,0.34);

		xsArraySetFloat(RoadArrayStartIdX,10,0.46);
		xsArraySetFloat(RoadArrayStartIdZ,10,0.34);
		xsArraySetFloat(RoadArrayEndIdX,10,0.46);
		xsArraySetFloat(RoadArrayEndIdZ,10,0.62);

		//Road 4 to 8
		xsArraySetFloat(RoadArrayStartIdX,11,0.34);
		xsArraySetFloat(RoadArrayStartIdZ,11,0.02);
		xsArraySetFloat(RoadArrayEndIdX,11,0.34);
		xsArraySetFloat(RoadArrayEndIdZ,11,0.34);

		//Road 5 to 8 2
		xsArraySetFloat(RoadArrayStartIdX,12,0.12);
		xsArraySetFloat(RoadArrayStartIdZ,12,0.44);
		xsArraySetFloat(RoadArrayEndIdX,12,0.40);
		xsArraySetFloat(RoadArrayEndIdZ,12,0.44);

		//Road 5 to 6
		xsArraySetFloat(RoadArrayStartIdX,13,0.20);
		xsArraySetFloat(RoadArrayStartIdZ,13,0.38);
		xsArraySetFloat(RoadArrayEndIdX,13,0.20);
		xsArraySetFloat(RoadArrayEndIdZ,13,0.66);

		//Road 4 to 5
		xsArraySetFloat(RoadArrayStartIdX,14,0.18);
		xsArraySetFloat(RoadArrayStartIdZ,14,0.20);
		xsArraySetFloat(RoadArrayEndIdX,14,0.46);
		xsArraySetFloat(RoadArrayEndIdZ,14,0.18);

		xsArraySetFloat(RoadArrayStartIdX,15,0.18);
		xsArraySetFloat(RoadArrayStartIdZ,15,0.20);
		xsArraySetFloat(RoadArrayEndIdX,15,0.18);
		xsArraySetFloat(RoadArrayEndIdZ,15,0.42);

		//Road 6 to 8
		xsArraySetFloat(RoadArrayStartIdX,16,0.32);
		xsArraySetFloat(RoadArrayStartIdZ,16,0.80);
		xsArraySetFloat(RoadArrayEndIdX,16,0.32);
		xsArraySetFloat(RoadArrayEndIdZ,16,0.52);

		xsArraySetFloat(RoadArrayStartIdX,17,0.32);
		xsArraySetFloat(RoadArrayStartIdZ,17,0.52);
		xsArraySetFloat(RoadArrayEndIdX,17,0.58);
		xsArraySetFloat(RoadArrayEndIdZ,17,0.52);

		//Road 6 to 7
		xsArraySetFloat(RoadArrayStartIdX,18,0.20);
		xsArraySetFloat(RoadArrayStartIdZ,18,0.66);
		xsArraySetFloat(RoadArrayEndIdX,18,0.38);
		xsArraySetFloat(RoadArrayEndIdZ,18,0.84);

		xsArraySetFloat(RoadArrayStartIdX,19,0.42);
		xsArraySetFloat(RoadArrayStartIdZ,19,0.80);
		xsArraySetFloat(RoadArrayEndIdX,19,0.22);
		xsArraySetFloat(RoadArrayEndIdZ,19,1.00);

		//Road 2 to 3
		xsArraySetFloat(RoadArrayStartIdX,20,0.82);
		xsArraySetFloat(RoadArrayStartIdZ,20,0.48);
		xsArraySetFloat(RoadArrayEndIdX,20,0.82);
		xsArraySetFloat(RoadArrayEndIdZ,20,0.20);

		xsArraySetFloat(RoadArrayStartIdX,21,0.82);
		xsArraySetFloat(RoadArrayStartIdZ,21,0.20);
		xsArraySetFloat(RoadArrayEndIdX,21,0.54);
		xsArraySetFloat(RoadArrayEndIdZ,21,0.20);

		//Road 1 to 2 2
		xsArraySetFloat(RoadArrayStartIdX,22,0.76);
		xsArraySetFloat(RoadArrayStartIdZ,22,0.70);
		xsArraySetFloat(RoadArrayEndIdX,22,0.92);
		xsArraySetFloat(RoadArrayEndIdZ,22,0.54);

		xsArraySetFloat(RoadArrayStartIdX,23,1.00);
		xsArraySetFloat(RoadArrayStartIdZ,23,0.62);
		xsArraySetFloat(RoadArrayEndIdX,23,0.82);
		xsArraySetFloat(RoadArrayEndIdZ,23,0.44);

		//Road Other
		xsArraySetFloat(RoadArrayStartIdX,24,0.00);
		xsArraySetFloat(RoadArrayStartIdZ,24,0.76);
		xsArraySetFloat(RoadArrayEndIdX,24,0.20);
		xsArraySetFloat(RoadArrayEndIdZ,24,0.56);

		xsArraySetFloat(RoadArrayStartIdX,25,0.62);
		xsArraySetFloat(RoadArrayStartIdZ,25,0.80);
		xsArraySetFloat(RoadArrayEndIdX,25,0.62);
		xsArraySetFloat(RoadArrayEndIdZ,25,0.98);

		for(RoadId = 0; <26)
		{
			int SandGround = rmCreateArea("SandGround"+RoadId);
			float XPosStart = xsArrayGetFloat(RoadArrayStartIdX,RoadId);
			float ZPosStart = xsArrayGetFloat(RoadArrayStartIdZ,RoadId);
			float XPosEnd = xsArrayGetFloat(RoadArrayEndIdX,RoadId);
			float ZPosEnd = xsArrayGetFloat(RoadArrayEndIdZ,RoadId);

			rmSetAreaSize(SandGround, 0.008, 0.008);
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




		//玩家所在位置的Id
		int PlayerLocationArrayId = xsArrayCreateInt(8,0,"PlayerLocationId");
		//rmPlacePlayersCircular(0.35, 0.35, 0.0);   	//圆形放置玩家
		if(cNumberNonGaiaPlayers<8)
		{
			int RandStart = rmRandInt(0,6);
			float Add = 7/cNumberNonGaiaPlayers;
			while (RandStart>0)
			{
				RandStart = RandStart - Add;
			}
			RandStart = RandStart + Add;

			for(i=i; <=cNumberNonGaiaPlayers)
			{
				int LocationId = RandStart + (i-1)*Add;
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

		//定义油田（补给库）
		bool UseFactory = true;
		int Oil = rmCreateObjectDef("Oil");
		if (rmGetNomadStart())
		{
			rmAddObjectDefItem(Oil, "deSPCCommandPost", 1, 0.0);
		}
		else
		{
			if(UseFactory)
			{
				rmAddObjectDefItem(Oil, "deSPCCapturableFactory",1,0);
			}
			else{
				rmAddObjectDefItem(Oil,"deSPCSupplyCache",1,0);
			}


			// rmCreateTrigger("AAA");
			// rmSwitchToTrigger(rmTriggerID("AAA"));
			// rmSetTriggerPriority(4);
			// rmSetTriggerActive(true);
			// rmSetTriggerRunImmediately(true);
			// rmSetTriggerLoop(false);
			// rmAddTriggerCondition("Always");
			// rmAddTriggerEffect("Set Tech Status");
			// rmSetTriggerEffectParamInt("TechID", rmGetTechID("SaloonTechOutlawRifleman"), false);
			// rmSetTriggerEffectParamInt("PlayerID", 1);
			// rmSetTriggerEffectParamInt("Status", 2);
			// rmAddTriggerEffect("Set Tech Status");
			// rmSetTriggerEffectParamInt("TechID", rmGetTechID("ypSaloonWokouPirate"), false);
			// rmSetTriggerEffectParamInt("PlayerID", 1);
			// rmSetTriggerEffectParamInt("Status", 2);
			// rmAddTriggerEffect("Set Tech Status");
			// rmSetTriggerEffectParamInt("TechID", rmGetTechID("SaloonWildWest"), false);
			// rmSetTriggerEffectParamInt("PlayerID", 1);
			// rmSetTriggerEffectParamInt("Status", 2);




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
					// rmCreateTrigger("activatetaverns"+i);
					// rmSwitchToTrigger(rmTriggerID("activatetaverns"+i));
					// rmSetTriggerPriority(4);
					// rmSetTriggerActive(true);
					// rmSetTriggerRunImmediately(true);
					// rmSetTriggerLoop(false);
					// rmAddTriggerCondition("Always");
					// rmAddTriggerEffect("Unforbid and Enable Unit");
					// rmSetTriggerEffectParamInt("PlayerID", i);
					// rmSetTriggerEffectParam("Protounit", "deTavern");

					// rmAddTriggerEffect("Set Tech Status");
					// rmSetTriggerEffectParamInt("TechID", rmGetTechID("DEUnknownTavernWagonFix"), false);
					// rmSetTriggerEffectParamInt("PlayerID", i);
					// rmSetTriggerEffectParamInt("Status", 2);
				}
				oxy("trUnforbidProtounit("+i+", \"SaloonOutlawRifleman\");");
				oxy("trUnforbidProtounit("+i+", \"SaloonOutlawPistol\");");
				oxy("trUnforbidProtounit("+i+", \"SaloonOutlawRider\");");
				oxy("trUnforbidProtounit("+i+", \"MercJaeger\");");
				oxy("trUnforbidProtounit("+i+", \"MercLandsknecht\");");
				oxy("trUnforbidProtounit("+i+", \"MercMameluke\");");
				oxy("trUnforbidProtounit("+i+", \"MercHighlander\");");
				oxy("trUnforbidProtounit("+i+", \"MercBlackRider\");");
				oxy("trUnforbidProtounit("+i+", \"MercBarbaryCorsair\");");
				oxyZ("} /*");

				//调整工厂工作速度
				oxy("rule _FactoryAdjust"+i+" active runImmediately { ");
				oxy("trTechSetStatus("+i+", 416, 2);");
				oxy("trTechSetStatus("+i+", 417, 2);");
				oxy("trTechSetStatus("+i+", 418, 2);");
				oxy("trTechSetStatus("+i+", 446, 2);");
				oxy("trTechSetStatus("+i+", 1539, 2);");
				oxy("trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherFoodTeam\", "+i+", 5, 0, 0);");
				oxy("trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherWoodTeam\", "+i+", 5, 0, 0);");
				oxy("trModifyProtounitAction(\"deSPCCapturableFactory\", \"AutoGatherCoinTeam\", "+i+", 5, 0, 0);");
				//oxy("trModifyProtounit(\"deSPCCapturableFactory\", "+i+", 63, 2);");
				oxy("xsDisableRule(\"_FactoryAdjust"+i+"\");");
				oxyZ("} /*");

				//启用军医与医院
				oxy("rule _Surgeon"+i+" active runImmediately { ");
				oxy("trUnforbidProtounit("+i+", \"Surgeon\");");
				oxy("trUnforbidProtounit("+i+", \"FieldHospital\");");
				oxy("xsDisableRule(\"_Surgeon"+i+"\");");
				oxyZ("} /*");
			}

			//启用食物马车(盲盒)，调整Baker
			oxy("rule _WagonFood active runImmediately { ");
			oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
			oxy("trModifyProtounitData(\"SPCXPBaker\", i, 0, 5000.0, 1);");
			oxy("trUnforbidProtounit(i, \"SPCXPWagonFood\");");
			// oxy("trModifyProtounitData(\"SPCXPWagonFood\", i, 15, 0, 1);");
			// oxy("trModifyProtounitData(\"SPCXPWagonFood\", i, 16, 600, 1);");
			oxy("trModifyProtounit(\"SPCXPWagonFood\", i, 15, -100);");
			oxy("trModifyProtounit(\"SPCXPWagonFood\", i, 16, 600);");
			oxy("}");
			oxy("xsDisableRule(\"_WagonFood\");");
			oxyZ("}/*");

			oxy("rule _WagonGetCornerHitPointAdjust active runImmediately { ");
			oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
			oxy("trModifyProtounitData(\"SPCFortCorner\", i, 0, 5000.0, 1);");
			oxy("}");
			oxy("xsDisableRule(\"_WagonGetCornerHitPointAdjust\");");
			oxyZ("}/*");
		}

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


		for(i=1; <=cNumberNonGaiaPlayers)
		{	//放置城镇中心，rmPlaceObjectDefAtLoc第二个值为被放置玩家对象，这里使用了for循环，循环值=1，<=玩家人数，所以会放置所有玩家的城镇中心。
			//rmPlaceObjectDefAtLoc(TownCenterID, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));

			//调用城镇中心坐标
			// vector TCLocation = rmGetUnitPosition(rmGetUnitPlacedOfPlayer(TownCenterID, i));

			int PlayerLocationId = xsArrayGetInt(PlayerLocationArrayId,i-1);
			if (rmGetNomadStart())
			{
				rmPlaceObjectDefAtLoc(Oil, i, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i));
				rmPlaceObjectDefAtLoc(startingUnits, i, rmPlayerLocXFraction(i)+0.02, rmPlayerLocZFraction(i)-0.02);
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

				// rmPlaceObjectDefAtLoc(WagonGetCorner,i,XPosOil1+OffsetX/2,ZPosOil1+OffsetZ/2);

				// int WagonGetCornerUintId = rmGetUnitPlacedOfPlayer(WagonGetCorner,i);
				// oxy("rule _DamageWagonGetCorner"+i+" minInterval 2 active runImmediately { ");
				// oxy("if( trPlayerUnitCountSpecific("+i+",\"SPCFortCorner\") == 1){");
				// oxy("	trUnitSelectClear();");
				// oxy("	trUnitSelectByID("+WagonGetCornerUintId+");");
				// oxy("	trUnitChangeName(\"FixToGetRandomWagon\");");
				// // oxy("	if( kbUnitGetCurrentHitpoints("+WagonGetCornerUintId+")==5000){");
				// oxy("	if( trUnitPercentDamaged() == 0){");
				// oxy("		if( trPlayerResourceCount("+i+",\"Wood\")>600){");
				// oxy("			trPlayerGrantResources("+i+",\"Wood\", -600);");
				// oxy("			trDamageUnit(100);");
				// // oxy("			trDamageUnit(100);");
				// // oxy("			trDamageUnit(100);");
				// // oxy("			trUnitCreate(\"Bank\", \"Bank"+1+"\", 0.5, 0.5, 0.5, 0, 1);");
				// oxy("			trUnitCreateFromSource(\"deMilitaryWagon\", \""+WagonGetCornerUintId+"\", \""+WagonGetCornerUintId+"\", "+i+");");
				// //oxy("			xsDisableRule(\"_DamageWagonGetCorner"+i+"\");");
				// oxy("}}}");
				// oxyZ("}/*");


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
				// oxy("	trUnitSelectClear();");
				// oxy("	trUnitSelectByID("+WagonBakerUnitId+");");
				oxy("	trRemoveUnitsInArea("+i+",\"SPCXPWagonFood\",10);");
				oxy("	for(i=0; <FoodWagonCount){");
				oxy("		trUnitCreateFromSource(\"deMilitaryWagon\", \""+WagonBakerUnitId+"\", \""+WagonBakerUnitId+"\", "+i+");");
				oxy("	}}}");
				oxyZ("}/*");

				// //SPCFortCorner
				// //ypSPCJapaneseFortCorner
				// //ypSPCIndianFortCorner
			}


			rmPlaceObjectDefAtLoc(Miner, i, rmPlayerLocXFraction(i)+0.02, rmPlayerLocZFraction(i)+0.02);
			rmPlaceObjectDefAtLoc(Surgeon, i , rmPlayerLocXFraction(i)-0.02, rmPlayerLocZFraction(i)-0.02);

			// deSPCCapturableFactory
			// deArtilleryFoundryWagon
			// deTavernWagon
			// YPStableWagon
			// deREVFilibuster
			// ypSPCBrahminHealer

			//trModifyProtounit("deMiner",0,0,1000);

			//ypSPCIndianFortCorner

			// rmCreateTrigger("AutoConvertSupplySpot"+i);
			// rmSwitchToTrigger(rmTriggerID("AutoConvertSupplySpot"+i));
			// rmSetTriggerActive(true);
			// rmSetTriggerRunImmediately(true);
			// rmSetTriggerPriority(4);
			// rmAddTriggerCondition("Always");
			// rmAddTriggerEffect("");
			// rmSetTriggerEffectParamInt("PlayerID", i);
			// rmSetTriggerEffectParam("Protounit", "Surgeon");

			// // Surgeon
			// rmCreateTrigger("Surgeon"+i);
			// rmSwitchToTrigger(rmTriggerID("Surgeon"+i));
			// rmSetTriggerActive(true);
			// rmSetTriggerRunImmediately(true);
			// rmSetTriggerPriority(4);
			// rmAddTriggerCondition("Always");
			// rmAddTriggerEffect("Unforbid and Enable Unit");
			// rmSetTriggerEffectParamInt("PlayerID", i);
			// rmSetTriggerEffectParam("Protounit", "Surgeon");

			// // surgeon builds field hospital
			// rmCreateTrigger("fieldhospitalactivatesurgeon"+i);
			// rmSwitchToTrigger(rmTriggerID("fieldhospitalactivatesurgeon"+i));
			// rmSetTriggerActive(true);
			// rmSetTriggerRunImmediately(true);
			// rmSetTriggerPriority(4);
			// rmAddTriggerCondition("Always");
			// rmAddTriggerEffect("Unforbid and Enable Unit");
			// rmSetTriggerEffectParamInt("PlayerID", i);
			// rmSetTriggerEffectParam("Protounit", "FieldHospital");

			// tech SPCXPValleyForge


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

			// rmCreateTrigger("lifespan"+i);
			// rmSwitchToTrigger(rmTriggerID("lifespan"+i));
			// rmSetTriggerActive(true);
			// rmSetTriggerRunImmediately(true);
			// rmSetTriggerPriority(4);
			// rmAddTriggerCondition("Always");
			// rmAddTriggerEffect("Modify Protounit");
			// rmSetTriggerEffectParam("Protounit", "Surgeon");
			// rmSetTriggerEffectParamInt("PlayerID", i);
			// rmSetTriggerEffectParamInt("Field", 8);
			// rmSetTriggerEffectParamInt("Delta", 15);

		}

		for(i=1; <=cNumberNonGaiaPlayers)
		{
			//放置起始单位
			// rmPlaceObjectDefAtLoc(startingUnits, i, rmXMetersToFraction(xsVectorGetX(TCLocation)), rmZMetersToFraction(xsVectorGetZ(TCLocation)));
			// rmPlaceObjectDefAtLoc(startingUnits, i, 0.5, 0.5);
		}

		// rmCreateTrigger("Temp");
		// rmSwitchToTrigger(rmTriggerID("Temp"));
		// oxyA("}}");

		oxy("rule _ModifyHealth active runImmediately { ");
		oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
		oxy("trModifyProtounitData(\"deMiner\", i, 0, 2800, 0);");
		oxy("}");
		oxy("xsDisableRule(\"_ModifyHealth\");");
		oxyZ("} /*");

		for(i=1; <=cNumberNonGaiaPlayers)
		{
			// oxy("rule _SetAutoConvert"+i+" active runImmediately { ");
			// oxy("trModifyProtounitAction(\"deSPCSupplyCache\", "+i+", 0, 4000);");
			// oxy("xsDisableRule(\"_SetAutoConvert"+i+"\");");
			// oxyZ("} /*");

			oxy("rule _GiveResource"+i+" active runImmediately { ");
			oxy("trPlayerGrantResources("+i+",\"Food\", 2000);");
			oxy("trPlayerGrantResources("+i+",\"Wood\", 2000);");
			oxy("trPlayerGrantResources("+i+",\"Gold\", 2000);");

			oxy("trModifyPlayerData("+i+",0,-1,300,0);");
			oxy("xsDisableRule(\"_GiveResource"+i+"\");");
			oxyZ("}/*");
		}

		int HCAccessWall = rmCreateObjectDef("HCAccessWall");
		rmAddObjectDefItem(HCAccessWall,"SPCFortWallSmall",1,0);
		rmPlaceObjectDefAtLoc(HCAccessWall,1,0.92,0.54);
		//int HCAccessWallUintId = rmGetUnitPlacedOfPlayer(HCAccessWall,1);

		oxy("rule _TimerAccessHC active runImmediately { ");
		oxy("trCounterAddTime(\"countdown\", 30, 0, \"P1 can delete your wall to enable shipping\", 0);");
		oxy("trMessageSetText(\"I am the author of this map called Evianaive.P1 can delete your wall to enable shipping! Get Military Wagon in your baker! The factory can be occupied by your force! Enjoy you self.\",-1);");
		oxy("xsDisableRule(\"_TimerAccessHC\");");
		oxyZ("}/*");

		oxy("rule _ForbidHC active runImmediately { ");
		oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
		oxy("trPlayerSetHCAccess(i,false);");
		oxy("}");
		oxy("xsDisableRule(\"_ForbidHC\");");
		oxyZ("}/*");


		oxy("rule _AccessHC active runImmediately { ");
		oxy("if((trTime()-cActivationTime)<=30){");
		oxy("if( trPlayerUnitCountSpecific(1,\"SPCFortWallSmall\") == 0){");
		oxy("for(i=1; <="+cNumberNonGaiaPlayers+"){");
		oxy("trPlayerSetHCAccess(i,true);");
		oxy("}");
		oxy("xsDisableRule(\"_AccessHC\");");
		oxy("}");
		oxy("}");
		oxyZ("}/*");


		// rmCreateTrigger("SetStartAge");
		// rmSwitchToTrigger(rmTriggerID("SetStartAge"));
		// rmSetTriggerActive(true);
		// rmSetTriggerRunImmediately(true);
		// oxyA("}}*/");

		oxy("rule _SetStartAge2 active runImmediately { ");
		for(i=1; <=cNumberNonGaiaPlayers)
		{
			oxy("if(kbGetAgeForPlayer("+i+")<1){");
			oxy("trPlayerSetAge("+i+", 1, true);}");
		}
		oxyZ("}/*");

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
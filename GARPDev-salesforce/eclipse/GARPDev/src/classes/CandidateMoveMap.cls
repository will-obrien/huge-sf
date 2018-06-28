global class CandidateMoveMap {   
    global static map< id, map< id, GARP_trigger_util.EA_Item >> memberID2EA_Map = 
      new map< id, map< id, GARP_trigger_util.EA_Item >> ();
  
  // Global to allow seating algorithm to disable move logic.....
  global static boolean disableCandidateMoveFilter {get; set; }
  }
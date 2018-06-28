global class MyComponentController {  
    public Id recordId { get; set; }
    public Schema.sObjectType sot {
        get {
            return recordId.getSObjectType();
        }
  }
  public String sotName {
      get {
        return sot.getDescribe().getName();
      }
  }
}

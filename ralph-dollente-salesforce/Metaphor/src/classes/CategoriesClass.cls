public class CategoriesClass{    
    public String category_name {get; set;}
    public String color_name {get; set;}
    public List<DateClass> dates {get; set;}

    public CategoriesClass(String name, String color, List<DateClass> dateList){
        this.category_name = name;
        this.color_name = color;
        this.dates = dateList;
    }
}
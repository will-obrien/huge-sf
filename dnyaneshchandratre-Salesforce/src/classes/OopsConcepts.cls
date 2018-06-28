public virtual class OopsConcepts extends AbstractClass implements Numbers {
    public static Integer N1,n2;
    public OopsConcepts() {
        n1=21;
        n2=12;
    }
    public OopsConcepts(Integer num1,Integer num2)
    {
        n1=num1;
        n2=num2;
        addNumbers(n1,n2);
    }
    public void addNumbers(Integer num1,Integer num2)
    {
        System.debug(num1+num2);
    }
    public override virtual void show()
    {
        System.debug(DateTime.now());
    }
}
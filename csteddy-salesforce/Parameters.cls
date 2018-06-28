public class Parameters{
    private Map<String, Object> parameters = new Map<String, Object>();

    public void add(String name, Object value) {
        this.parameters.put(name, value);
    }

    public Object get(String name) {
        Object result = null;

        if(this.parameters.containsKey(name)) {
            result = this.parameters.get(name);
        }
        return this.parameters.get(name);
    }    

    public String serialize()
    {
        return JSON.serialize(parameters);      
    }

    public static Parameters deserialize(String serialized)
    { 
        Parameters parameters = new Parameters();
        parameters.parameters = (Map<String, Object>) JSON.deserializeUntyped(serialized);
        return parameters;
    }
}

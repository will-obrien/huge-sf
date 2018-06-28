public virtual class fooparent{
    public integer a;
    public fooparent(){
    }
    public fooparent(boolean p){
        a = 0;
        system.assert(false, 'shouldnt run this');
    }
    public fooparent(integer a){
        this.a = a;
    }
}
public class JHAFormController {

    public class SubmitException extends Exception {}
    
    
    // Properties: get method is used to pass data from apex code to visualforce page;  set method is used to pass values from visualforce page to the apex controller code

    //*** BEGIN: Setup code for the Affected Area Multi-Select Picklists ***
    Set<String> affectedAreaOrigValues2 = new Set<String>{'Eyes','Respiratory'};
    Public List<string> affectedAreaLeftSelected2{get;set;}
    Public List<string> affectedAreaRightSelected2{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues2 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues2 = new Set<string>();

    public PageReference selectclick2() {
        affectedAreaRightSelected2.clear();

        for(String s : affectedAreaLeftSelected2) {
            affectedAreaLeftValues2.remove(s);
            affectedAreaRightValues2.add(s);
        }

        return null;
    }

    public PageReference unselectclick2() {
        affectedAreaLeftSelected2.clear();

        for(String s : affectedAreaRightSelected2) {
            affectedAreaRightValues2.remove(s);
            affectedAreaLeftValues2.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues2() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues2);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues2() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues2);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues3 = new Set<String>{'Eyes','Respiratory'};
    Public List<string> affectedAreaLeftSelected3{get;set;}
    Public List<string> affectedAreaRightSelected3{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues3 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues3 = new Set<string>();

    public PageReference selectclick3() {
        affectedAreaRightSelected3.clear();

        for(String s : affectedAreaLeftSelected3) {
            affectedAreaLeftValues3.remove(s);
            affectedAreaRightValues3.add(s);
        }

        return null;
    }

    public PageReference unselectclick3() {
        affectedAreaLeftSelected3.clear();

        for(String s : affectedAreaRightSelected3) {
            affectedAreaRightValues3.remove(s);
            affectedAreaLeftValues3.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues3() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues3);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues3() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues3);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues4 = new Set<String>{'Eyes','Hands','Head'};
    Public List<string> affectedAreaLeftSelected4{get;set;}
    Public List<string> affectedAreaRightSelected4{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues4 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues4 = new Set<string>();

    public PageReference selectclick4() {
        affectedAreaRightSelected4.clear();

        for(String s : affectedAreaLeftSelected4) {
            affectedAreaLeftValues4.remove(s);
            affectedAreaRightValues4.add(s);
        }

        return null;
    }

    public PageReference unselectclick4() {
        affectedAreaLeftSelected4.clear();

        for(String s : affectedAreaRightSelected4) {
            affectedAreaRightValues4.remove(s);
            affectedAreaLeftValues4.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues4() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues4);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues4() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues4);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues6 = new Set<String>{'Foot'};
    Public List<string> affectedAreaLeftSelected6{get;set;}
    Public List<string> affectedAreaRightSelected6{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues6 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues6 = new Set<string>();

    public PageReference selectclick6() {
        affectedAreaRightSelected6.clear();

        for(String s : affectedAreaLeftSelected6) {
            affectedAreaLeftValues6.remove(s);
            affectedAreaRightValues6.add(s);
        }

        return null;
    }

    public PageReference unselectclick6() {
        affectedAreaLeftSelected6.clear();

        for(String s : affectedAreaRightSelected6) {
            affectedAreaRightValues6.remove(s);
            affectedAreaLeftValues6.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues6() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues6);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues6() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues6);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues11 = new Set<String>{'Noise'};
    Public List<string> affectedAreaLeftSelected11{get;set;}
    Public List<string> affectedAreaRightSelected11{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues11 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues11 = new Set<string>();

    public PageReference selectclick11() {
        affectedAreaRightSelected11.clear();

        for(String s : affectedAreaLeftSelected11) {
            affectedAreaLeftValues11.remove(s);
            affectedAreaRightValues11.add(s);
        }

        return null;
    }

    public PageReference unselectclick11() {
        affectedAreaLeftSelected11.clear();

        for(String s : affectedAreaRightSelected11) {
            affectedAreaRightValues11.remove(s);
            affectedAreaLeftValues11.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues11() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues11);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues11() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues11);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues12 = new Set<String>{'Body/Torso','Head'};
    Public List<string> affectedAreaLeftSelected12{get;set;}
    Public List<string> affectedAreaRightSelected12{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues12 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues12 = new Set<string>();

    public PageReference selectclick12() {
        affectedAreaRightSelected12.clear();

        for(String s : affectedAreaLeftSelected12) {
            affectedAreaLeftValues12.remove(s);
            affectedAreaRightValues12.add(s);
        }

        return null;
    }

    public PageReference unselectclick12() {
        affectedAreaLeftSelected12.clear();

        for(String s : affectedAreaRightSelected12) {
            affectedAreaRightValues12.remove(s);
            affectedAreaLeftValues12.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues12() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues12);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues12() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues12);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues13 = new Set<String>{'Hands'};
    Public List<string> affectedAreaLeftSelected13{get;set;}
    Public List<string> affectedAreaRightSelected13{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues13 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues13 = new Set<string>();

    public PageReference selectclick13() {
        affectedAreaRightSelected13.clear();

        for(String s : affectedAreaLeftSelected13) {
            affectedAreaLeftValues13.remove(s);
            affectedAreaRightValues13.add(s);
        }

        return null;
    }

    public PageReference unselectclick13() {
        affectedAreaLeftSelected13.clear();

        for(String s : affectedAreaRightSelected13) {
            affectedAreaRightValues13.remove(s);
            affectedAreaLeftValues13.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues13() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues13);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues13() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues13);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues14 = new Set<String>{'Foot'};
    Public List<string> affectedAreaLeftSelected14{get;set;}
    Public List<string> affectedAreaRightSelected14{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues14 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues14 = new Set<string>();

    public PageReference selectclick14() {
        affectedAreaRightSelected14.clear();

        for(String s : affectedAreaLeftSelected14) {
            affectedAreaLeftValues14.remove(s);
            affectedAreaRightValues14.add(s);
        }

        return null;
    }

    public PageReference unselectclick14() {
        affectedAreaLeftSelected14.clear();

        for(String s : affectedAreaRightSelected14) {
            affectedAreaRightValues14.remove(s);
            affectedAreaLeftValues14.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues14() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues14);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues14() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues14);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues15 = new Set<String>{'Eyes','Hands','Head'};
    Public List<string> affectedAreaLeftSelected15{get;set;}
    Public List<string> affectedAreaRightSelected15{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues15 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues15 = new Set<string>();

    public PageReference selectclick15() {
        affectedAreaRightSelected15.clear();

        for(String s : affectedAreaLeftSelected15) {
            affectedAreaLeftValues15.remove(s);
            affectedAreaRightValues15.add(s);
        }

        return null;
    }

    public PageReference unselectclick15() {
        affectedAreaLeftSelected15.clear();

        for(String s : affectedAreaRightSelected15) {
            affectedAreaRightValues15.remove(s);
            affectedAreaLeftValues15.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues15() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues15);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues15() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues15);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues17 = new Set<String>{'Foot'};
    Public List<string> affectedAreaLeftSelected17{get;set;}
    Public List<string> affectedAreaRightSelected17{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues17 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues17 = new Set<string>();

    public PageReference selectclick17() {
        affectedAreaRightSelected17.clear();

        for(String s : affectedAreaLeftSelected17) {
            affectedAreaLeftValues17.remove(s);
            affectedAreaRightValues17.add(s);
        }

        return null;
    }

    public PageReference unselectclick17() {
        affectedAreaLeftSelected17.clear();

        for(String s : affectedAreaRightSelected17) {
            affectedAreaRightValues17.remove(s);
            affectedAreaLeftValues17.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues17() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues17);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues17() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues17);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues25 = new Set<String>{'Body/Torso','Eyes','Hands','Head'};
    Public List<string> affectedAreaLeftSelected25{get;set;}
    Public List<string> affectedAreaRightSelected25{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues25 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues25 = new Set<string>();

    public PageReference selectclick25() {
        affectedAreaRightSelected25.clear();

        for(String s : affectedAreaLeftSelected25) {
            affectedAreaLeftValues25.remove(s);
            affectedAreaRightValues25.add(s);
        }

        return null;
    }

    public PageReference unselectclick25() {
        affectedAreaLeftSelected25.clear();

        for(String s : affectedAreaRightSelected25) {
            affectedAreaRightValues25.remove(s);
            affectedAreaLeftValues25.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues25() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues25);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues25() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues25);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues29 = new Set<String>{'Body/Torso','Eyes','Hands','Head'};
    Public List<string> affectedAreaLeftSelected29{get;set;}
    Public List<string> affectedAreaRightSelected29{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues29 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues29 = new Set<string>();

    public PageReference selectclick29() {
        affectedAreaRightSelected29.clear();

        for(String s : affectedAreaLeftSelected29) {
            affectedAreaLeftValues29.remove(s);
            affectedAreaRightValues29.add(s);
        }

        return null;
    }

    public PageReference unselectclick29() {
        affectedAreaLeftSelected29.clear();

        for(String s : affectedAreaRightSelected29) {
            affectedAreaRightValues29.remove(s);
            affectedAreaLeftValues29.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues29() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues29);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues29() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues29);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues34 = new Set<String>{'Body/Torso','Eyes','Foot','Hands','Head'};
    Public List<string> affectedAreaLeftSelected34{get;set;}
    Public List<string> affectedAreaRightSelected34{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues34 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues34 = new Set<string>();

    public PageReference selectclick34() {
        affectedAreaRightSelected34.clear();

        for(String s : affectedAreaLeftSelected34) {
            affectedAreaLeftValues34.remove(s);
            affectedAreaRightValues34.add(s);
        }

        return null;
    }

    public PageReference unselectclick34() {
        affectedAreaLeftSelected34.clear();

        for(String s : affectedAreaRightSelected34) {
            affectedAreaRightValues34.remove(s);
            affectedAreaLeftValues34.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues34() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues34);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues34() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues34);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues36 = new Set<String>{'Hands'};
    Public List<string> affectedAreaLeftSelected36{get;set;}
    Public List<string> affectedAreaRightSelected36{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues36 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues36 = new Set<string>();

    public PageReference selectclick36() {
        affectedAreaRightSelected36.clear();

        for(String s : affectedAreaLeftSelected36) {
            affectedAreaLeftValues36.remove(s);
            affectedAreaRightValues36.add(s);
        }

        return null;
    }

    public PageReference unselectclick36() {
        affectedAreaLeftSelected36.clear();

        for(String s : affectedAreaRightSelected36) {
            affectedAreaRightValues36.remove(s);
            affectedAreaLeftValues36.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues36() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues36);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues36() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues36);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues37 = new Set<String>{'Hands'};
    Public List<string> affectedAreaLeftSelected37{get;set;}
    Public List<string> affectedAreaRightSelected37{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues37 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues37 = new Set<string>();

    public PageReference selectclick37() {
        affectedAreaRightSelected37.clear();

        for(String s : affectedAreaLeftSelected37) {
            affectedAreaLeftValues37.remove(s);
            affectedAreaRightValues37.add(s);
        }

        return null;
    }

    public PageReference unselectclick37() {
        affectedAreaLeftSelected37.clear();

        for(String s : affectedAreaRightSelected37) {
            affectedAreaRightValues37.remove(s);
            affectedAreaLeftValues37.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues37() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues37);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues37() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues37);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues38 = new Set<String>{'Head'};
    Public List<string> affectedAreaLeftSelected38{get;set;}
    Public List<string> affectedAreaRightSelected38{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues38 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues38 = new Set<string>();

    public PageReference selectclick38() {
        affectedAreaRightSelected38.clear();

        for(String s : affectedAreaLeftSelected38) {
            affectedAreaLeftValues38.remove(s);
            affectedAreaRightValues38.add(s);
        }

        return null;
    }

    public PageReference unselectclick38() {
        affectedAreaLeftSelected38.clear();

        for(String s : affectedAreaRightSelected38) {
            affectedAreaRightValues38.remove(s);
            affectedAreaLeftValues38.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues38() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues38);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues38() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues38);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> affectedAreaOrigValues39 = new Set<String>{'Head'};
    Public List<string> affectedAreaLeftSelected39{get;set;}
    Public List<string> affectedAreaRightSelected39{get;set;}
    @TestVisible Set<string> affectedAreaLeftValues39 = new Set<string>();
    @TestVisible Set<string> affectedAreaRightValues39 = new Set<string>();

    public PageReference selectclick39() {
        affectedAreaRightSelected39.clear();

        for(String s : affectedAreaLeftSelected39) {
            affectedAreaLeftValues39.remove(s);
            affectedAreaRightValues39.add(s);
        }

        return null;
    }

    public PageReference unselectclick39() {
        affectedAreaLeftSelected39.clear();

        for(String s : affectedAreaRightSelected39) {
            affectedAreaRightValues39.remove(s);
            affectedAreaLeftValues39.add(s);
        }

        return null;
    }

    public List<SelectOption> getunSelectedValues39() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaLeftValues39);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getSelectedValues39() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(affectedAreaRightValues39);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    //*** END: Setup code for the Affected Area Multi-Select Picklists ***
    
    
    //*** BEGIN: Setup code for the PPE ID Multi-Select Picklists ***
    Set<String> ppeIdOrigValues2 = new Set<String>{'Dust Mask/Air Purifying','Face-shield/Goggles','Standard Uniform'};
    Public List<string> ppeIdLeftSelected2{get;set;}
    Public List<string> ppeIdRightSelected2{get;set;}
    @TestVisible Set<string> ppeIdLeftValues2 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues2 = new Set<string>();

    public PageReference ppeIdSelectClick2() {
        ppeIdRightSelected2.clear();

        for(String s : ppeIdLeftSelected2) {
            ppeIdLeftValues2.remove(s);
            ppeIdRightValues2.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick2() {
        ppeIdLeftSelected2.clear();

        for(String s : ppeIdRightSelected2) {
            ppeIdRightValues2.remove(s);
            ppeIdLeftValues2.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues2() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues2);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues2() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues2);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues3 = new Set<String>{'Dust Mask/Air Purifying','Standard Uniform'};
    Public List<string> ppeIdLeftSelected3{get;set;}
    Public List<string> ppeIdRightSelected3{get;set;}
    @TestVisible Set<string> ppeIdLeftValues3 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues3 = new Set<string>();

    public PageReference ppeIdSelectClick3() {
        ppeIdRightSelected3.clear();

        for(String s : ppeIdLeftSelected3) {
            ppeIdLeftValues3.remove(s);
            ppeIdRightValues3.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick3() {
        ppeIdLeftSelected3.clear();

        for(String s : ppeIdRightSelected3) {
            ppeIdRightValues3.remove(s);
            ppeIdLeftValues3.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues3() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues3);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues3() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues3);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues4 = new Set<String>{'Face-shield/Goggles','Leather Work Gloves','Standard Uniform'};
    Public List<string> ppeIdLeftSelected4{get;set;}
    Public List<string> ppeIdRightSelected4{get;set;}
    @TestVisible Set<string> ppeIdLeftValues4 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues4 = new Set<string>();

    public PageReference ppeIdSelectClick4() {
        ppeIdRightSelected4.clear();

        for(String s : ppeIdLeftSelected4) {
            ppeIdLeftValues4.remove(s);
            ppeIdRightValues4.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick4() {
        ppeIdLeftSelected4.clear();

        for(String s : ppeIdRightSelected4) {
            ppeIdRightValues4.remove(s);
            ppeIdLeftValues4.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues4() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues4);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues4() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues4);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues6 = new Set<String>{'Standard Uniform'};
    Public List<string> ppeIdLeftSelected6{get;set;}
    Public List<string> ppeIdRightSelected6{get;set;}
    @TestVisible Set<string> ppeIdLeftValues6 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues6 = new Set<string>();

    public PageReference ppeIdSelectClick6() {
        ppeIdRightSelected6.clear();

        for(String s : ppeIdLeftSelected6) {
            ppeIdLeftValues6.remove(s);
            ppeIdRightValues6.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick6() {
        ppeIdLeftSelected6.clear();

        for(String s : ppeIdRightSelected6) {
            ppeIdRightValues6.remove(s);
            ppeIdLeftValues6.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues6() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues6);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues6() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues6);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues11 = new Set<String>{'Earplug/Headset','Standard Uniform'};
    Public List<string> ppeIdLeftSelected11{get;set;}
    Public List<string> ppeIdRightSelected11{get;set;}
    @TestVisible Set<string> ppeIdLeftValues11 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues11 = new Set<string>();

    public PageReference ppeIdSelectClick11() {
        ppeIdRightSelected11.clear();

        for(String s : ppeIdLeftSelected11) {
            ppeIdLeftValues11.remove(s);
            ppeIdRightValues11.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick11() {
        ppeIdLeftSelected11.clear();

        for(String s : ppeIdRightSelected11) {
            ppeIdRightValues11.remove(s);
            ppeIdLeftValues11.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues11() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues11);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues11() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues11);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues12 = new Set<String>{'Face-shield/Goggles','Standard Uniform'};
    Public List<string> ppeIdLeftSelected12{get;set;}
    Public List<string> ppeIdRightSelected12{get;set;}
    @TestVisible Set<string> ppeIdLeftValues12 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues12 = new Set<string>();

    public PageReference ppeIdSelectClick12() {
        ppeIdRightSelected12.clear();

        for(String s : ppeIdLeftSelected12) {
            ppeIdLeftValues12.remove(s);
            ppeIdRightValues12.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick12() {
        ppeIdLeftSelected12.clear();

        for(String s : ppeIdRightSelected12) {
            ppeIdRightValues12.remove(s);
            ppeIdLeftValues12.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues12() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues12);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues12() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues12);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues13 = new Set<String>{'Leather Work Gloves','Standard Uniform'};
    Public List<string> ppeIdLeftSelected13{get;set;}
    Public List<string> ppeIdRightSelected13{get;set;}
    @TestVisible Set<string> ppeIdLeftValues13 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues13 = new Set<string>();

    public PageReference ppeIdSelectClick13() {
        ppeIdRightSelected13.clear();

        for(String s : ppeIdLeftSelected13) {
            ppeIdLeftValues13.remove(s);
            ppeIdRightValues13.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick13() {
        ppeIdLeftSelected13.clear();

        for(String s : ppeIdRightSelected13) {
            ppeIdRightValues13.remove(s);
            ppeIdLeftValues13.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues13() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues13);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues13() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues13);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues14 = new Set<String>{'Standard Uniform'};
    Public List<string> ppeIdLeftSelected14{get;set;}
    Public List<string> ppeIdRightSelected14{get;set;}
    @TestVisible Set<string> ppeIdLeftValues14 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues14 = new Set<string>();

    public PageReference ppeIdSelectClick14() {
        ppeIdRightSelected14.clear();

        for(String s : ppeIdLeftSelected14) {
            ppeIdLeftValues14.remove(s);
            ppeIdRightValues14.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick14() {
        ppeIdLeftSelected14.clear();

        for(String s : ppeIdRightSelected14) {
            ppeIdRightValues14.remove(s);
            ppeIdLeftValues14.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues14() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues14);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues14() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues14);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues15 = new Set<String>{'Leather Work Gloves','Standard Uniform'};
    Public List<string> ppeIdLeftSelected15{get;set;}
    Public List<string> ppeIdRightSelected15{get;set;}
    @TestVisible Set<string> ppeIdLeftValues15 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues15 = new Set<string>();

    public PageReference ppeIdSelectClick15() {
        ppeIdRightSelected15.clear();

        for(String s : ppeIdLeftSelected15) {
            ppeIdLeftValues15.remove(s);
            ppeIdRightValues15.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick15() {
        ppeIdLeftSelected15.clear();

        for(String s : ppeIdRightSelected15) {
            ppeIdRightValues15.remove(s);
            ppeIdLeftValues15.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues15() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues15);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues15() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues15);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues16 = new Set<String>{'Anchoring','Safety Harness and Lanyard','Standard Uniform'};
    Public List<string> ppeIdLeftSelected16{get;set;}
    Public List<string> ppeIdRightSelected16{get;set;}
    @TestVisible Set<string> ppeIdLeftValues16 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues16 = new Set<string>();

    public PageReference ppeIdSelectClick16() {
        ppeIdRightSelected16.clear();

        for(String s : ppeIdLeftSelected16) {
            ppeIdLeftValues16.remove(s);
            ppeIdRightValues16.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick16() {
        ppeIdLeftSelected16.clear();

        for(String s : ppeIdRightSelected16) {
            ppeIdRightValues16.remove(s);
            ppeIdLeftValues16.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues16() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues16);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues16() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues16);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues17 = new Set<String>{'Standard Uniform'};
    Public List<string> ppeIdLeftSelected17{get;set;}
    Public List<string> ppeIdRightSelected17{get;set;}
    @TestVisible Set<string> ppeIdLeftValues17 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues17 = new Set<string>();

    public PageReference ppeIdSelectClick17() {
        ppeIdRightSelected17.clear();

        for(String s : ppeIdLeftSelected17) {
            ppeIdLeftValues17.remove(s);
            ppeIdRightValues17.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick17() {
        ppeIdLeftSelected17.clear();

        for(String s : ppeIdRightSelected17) {
            ppeIdRightValues17.remove(s);
            ppeIdLeftValues17.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues17() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues17);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues17() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues17);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues18 = new Set<String>{'Anchoring','Safety Harness and Lanyard','Standard Uniform'};
    Public List<string> ppeIdLeftSelected18{get;set;}
    Public List<string> ppeIdRightSelected18{get;set;}
    @TestVisible Set<string> ppeIdLeftValues18 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues18 = new Set<string>();

    public PageReference ppeIdSelectClick18() {
        ppeIdRightSelected18.clear();

        for(String s : ppeIdLeftSelected18) {
            ppeIdLeftValues18.remove(s);
            ppeIdRightValues18.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick18() {
        ppeIdLeftSelected18.clear();

        for(String s : ppeIdRightSelected18) {
            ppeIdRightValues18.remove(s);
            ppeIdLeftValues18.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues18() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues18);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues18() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues18);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues25 = new Set<String>{'Arc Flash Protective Equipment','Standard Uniform'};
    Public List<string> ppeIdLeftSelected25{get;set;}
    Public List<string> ppeIdRightSelected25{get;set;}
    @TestVisible Set<string> ppeIdLeftValues25 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues25 = new Set<string>();

    public PageReference ppeIdSelectClick25() {
        ppeIdRightSelected25.clear();

        for(String s : ppeIdLeftSelected25) {
            ppeIdLeftValues25.remove(s);
            ppeIdRightValues25.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick25() {
        ppeIdLeftSelected25.clear();

        for(String s : ppeIdRightSelected25) {
            ppeIdRightValues25.remove(s);
            ppeIdLeftValues25.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues25() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues25);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues25() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues25);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues29 = new Set<String>{'Arc Flash Protective Equipment','Standard Uniform'};
    Public List<string> ppeIdLeftSelected29{get;set;}
    Public List<string> ppeIdRightSelected29{get;set;}
    @TestVisible Set<string> ppeIdLeftValues29 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues29 = new Set<string>();

    public PageReference ppeIdSelectClick29() {
        ppeIdRightSelected29.clear();

        for(String s : ppeIdLeftSelected29) {
            ppeIdLeftValues29.remove(s);
            ppeIdRightValues29.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick29() {
        ppeIdLeftSelected29.clear();

        for(String s : ppeIdRightSelected29) {
            ppeIdRightValues29.remove(s);
            ppeIdLeftValues29.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues29() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues29);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues29() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues29);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues34 = new Set<String>{'Cut Resistant Gloves/Sleeves','Leather Work Gloves','Standard Uniform'};
    Public List<string> ppeIdLeftSelected34{get;set;}
    Public List<string> ppeIdRightSelected34{get;set;}
    @TestVisible Set<string> ppeIdLeftValues34 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues34 = new Set<string>();

    public PageReference ppeIdSelectClick34() {
        ppeIdRightSelected34.clear();

        for(String s : ppeIdLeftSelected34) {
            ppeIdLeftValues34.remove(s);
            ppeIdRightValues34.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick34() {
        ppeIdLeftSelected34.clear();

        for(String s : ppeIdRightSelected34) {
            ppeIdRightValues34.remove(s);
            ppeIdLeftValues34.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues34() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues34);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues34() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues34);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues36 = new Set<String>{'Cut Resistant Gloves/Sleeves','Leather Work Gloves','Standard Uniform'};
    Public List<string> ppeIdLeftSelected36{get;set;}
    Public List<string> ppeIdRightSelected36{get;set;}
    @TestVisible Set<string> ppeIdLeftValues36 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues36 = new Set<string>();

    public PageReference ppeIdSelectClick36() {
        ppeIdRightSelected36.clear();

        for(String s : ppeIdLeftSelected36) {
            ppeIdLeftValues36.remove(s);
            ppeIdRightValues36.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick36() {
        ppeIdLeftSelected36.clear();

        for(String s : ppeIdRightSelected36) {
            ppeIdRightValues36.remove(s);
            ppeIdLeftValues36.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues36() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues36);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues36() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues36);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues37 = new Set<String>{'Cut Resistant Gloves/Sleeves','Leather Work Gloves','Standard Uniform'};
    Public List<string> ppeIdLeftSelected37{get;set;}
    Public List<string> ppeIdRightSelected37{get;set;}
    @TestVisible Set<string> ppeIdLeftValues37 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues37 = new Set<string>();

    public PageReference ppeIdSelectClick37() {
        ppeIdRightSelected37.clear();

        for(String s : ppeIdLeftSelected37) {
            ppeIdLeftValues37.remove(s);
            ppeIdRightValues37.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick37() {
        ppeIdLeftSelected37.clear();

        for(String s : ppeIdRightSelected37) {
            ppeIdRightValues37.remove(s);
            ppeIdLeftValues37.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues37() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues37);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues37() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues37);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues38 = new Set<String>{'Standard Uniform'};
    Public List<string> ppeIdLeftSelected38{get;set;}
    Public List<string> ppeIdRightSelected38{get;set;}
    @TestVisible Set<string> ppeIdLeftValues38 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues38 = new Set<string>();

    public PageReference ppeIdSelectClick38() {
        ppeIdRightSelected38.clear();

        for(String s : ppeIdLeftSelected38) {
            ppeIdLeftValues38.remove(s);
            ppeIdRightValues38.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick38() {
        ppeIdLeftSelected38.clear();

        for(String s : ppeIdRightSelected38) {
            ppeIdRightValues38.remove(s);
            ppeIdLeftValues38.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues38() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues38);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues38() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues38);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    
    
    Set<String> ppeIdOrigValues39 = new Set<String>{'Standard Uniform'};
    Public List<string> ppeIdLeftSelected39{get;set;}
    Public List<string> ppeIdRightSelected39{get;set;}
    @TestVisible Set<string> ppeIdLeftValues39 = new Set<string>();
    @TestVisible Set<string> ppeIdRightValues39 = new Set<string>();

    public PageReference ppeIdSelectClick39() {
        ppeIdRightSelected39.clear();

        for(String s : ppeIdLeftSelected39) {
            ppeIdLeftValues39.remove(s);
            ppeIdRightValues39.add(s);
        }

        return null;
    }

    public PageReference ppeIdUnselectClick39() {
        ppeIdLeftSelected39.clear();

        for(String s : ppeIdRightSelected39) {
            ppeIdRightValues39.remove(s);
            ppeIdLeftValues39.add(s);
        }

        return null;
    }

    public List<SelectOption> getPPEIdUnselectedValues39() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdLeftValues39);
        tempList.sort();

        for(string s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }

    public List<SelectOption> getPPEIdSelectedValues39() {
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ppeIdRightValues39);
        tempList.sort();

        for(String s : tempList)
            options.add(new SelectOption(s,s));

        return options;
    }
    //*** END: Setup code for the PPE ID Multi-Select Picklists ***


    static final integer JHA_ITEM_COUNT = 41;
    
    String siteHostPartial = 'daikinapplied';
    String url1=URL.getCurrentRequestUrl().toExternalForm();
    String url2=URL.getSalesforceBaseUrl().toExternalForm();
    String url3=ApexPages.currentPage().getUrl();
    String host=URL.getCurrentRequestUrl().getHost();
    @TestVisible Boolean forceDotComSite = host.contains(siteHostPartial); // This will be True if the url contains 'daikinapplied' in the host part of the url
    @TestVisible boolean loadExistingForm = false;  // Only set to True if opening most recent form or specific date form
    @TestVisible String formURLName = null;

    public string callfunc {get;set;}  // used to call javascript function from apex code
    
    public boolean disableFlag {get; set;}  // used to disable some of the address fields
    
    public string addrState {get;set;}  // used to handle special case where State field won't disable when loading a form
    
    public string statesAvailableForCountry {get; set;}  // used with the hidden field on the VF page where it gets set to "True" or "False" if there are states or not when user selects a country 
    
    
    // Some query string parameters
    public String epriseLoginId {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    
    public string userLoginName {get; set;}

    public JHA_Form__c jhaForm {get; set;}
    
    public JHA_Item__c[] jhaItemList = new JHA_Item__c[JHA_ITEM_COUNT];
    public JHA_Item__c[] getJhaItemList() {
        return jhaItemList;
    }
    
    public Address__c addr {get; set;}
    
    
    public string jobSiteAddress {get; set;}
    public string getJobSiteAddress() {
        return jobSiteAddress;
    }
    
    
    public boolean hta2ReturnValueYes {get; set;}
    public boolean hta26and25ReturnValuesAreNo {get; set;}
    public boolean htaReturnValueRateGT2 {get; set;}
    public boolean hta28ReturnValueYesAndHta25No {get; set;}
    
    
    // Work Environment
    public JHA_Item__c jhaItem0 {get; set;}
    public JHA_Item__c jhaItem1 {get; set;}
    public JHA_Item__c jhaItem2 {get; set;}
    public JHA_Item__c jhaItem3 {get; set;}
    public JHA_Item__c jhaItem4 {get; set;}
    public JHA_Item__c jhaItem5 {get; set;}
    public JHA_Item__c jhaItem6 {get; set;}
    public JHA_Item__c jhaItem7 {get; set;}
    public JHA_Item__c jhaItem8 {get; set;}
    public JHA_Item__c jhaItem9 {get; set;}
    public JHA_Item__c jhaItem10 {get; set;}
    public JHA_Item__c jhaItem11 {get; set;}
    public JHA_Item__c jhaItem12 {get; set;}
    public JHA_Item__c jhaItem13 {get; set;}
    public JHA_Item__c jhaItem14 {get; set;}
    public JHA_Item__c jhaItem15 {get; set;}
    
    public string hazardType0 {get; set;}
    public string hazardType1 {get; set;}
    public string hazardType2 {get; set;}
    public string hazardType3 {get; set;}
    public string hazardType4 {get; set;}
    public string hazardType5 {get; set;}
    public string hazardType6 {get; set;}
    public string hazardType7 {get; set;}
    public string hazardType8 {get; set;}
    public string hazardType9 {get; set;}
    public string hazardType10 {get; set;}
    public string hazardType11 {get; set;}
    public string hazardType12 {get; set;}
    public string hazardType13 {get; set;}
    public string hazardType14 {get; set;}
    public string hazardType15 {get; set;}
    
    /*public string hazardTypeAssessment0 {get; set;}
    public string hazardTypeAssessment1 {get; set;}
    public string hazardTypeAssessment2 {get; set;}
    public string hazardTypeAssessment3 {get; set;}
    public string hazardTypeAssessment4 {get; set;}
    public string hazardTypeAssessment5 {get; set;}
    public string hazardTypeAssessment6 {get; set;}
    public string hazardTypeAssessment7 {get; set;}
    public string hazardTypeAssessment8 {get; set;}
    public string hazardTypeAssessment9 {get; set;}
    public string hazardTypeAssessment10 {get; set;}
    public string hazardTypeAssessment11 {get; set;}
    public string hazardTypeAssessment12 {get; set;}
    public string hazardTypeAssessment13 {get; set;}
    public string hazardTypeAssessment14 {get; set;}
    public string hazardTypeAssessment15 {get; set;}*/
    
    
    // Access to Work Area
    public JHA_Item__c jhaItem16 {get; set;}
    public JHA_Item__c jhaItem17 {get; set;}
    public JHA_Item__c jhaItem18 {get; set;}
    public JHA_Item__c jhaItem19 {get; set;}
    public JHA_Item__c jhaItem20 {get; set;}
    public JHA_Item__c jhaItem21 {get; set;}
    public JHA_Item__c jhaItem22 {get; set;}
    public JHA_Item__c jhaItem23 {get; set;}

    public string hazardType16 {get; set;}
    public string hazardType17 {get; set;}
    public string hazardType18 {get; set;}
    public string hazardType19 {get; set;}
    public string hazardType20 {get; set;}
    public string hazardType21 {get; set;}
    public string hazardType22 {get; set;}
    public string hazardType23 {get; set;}
    
    /*public string hazardTypeAssessment16 {get; set;}
    public string hazardTypeAssessment17 {get; set;}
    public string hazardTypeAssessment18 {get; set;}
    public string hazardTypeAssessment19 {get; set;}
    public string hazardTypeAssessment20 {get; set;}
    public string hazardTypeAssessment21 {get; set;}
    public string hazardTypeAssessment22 {get; set;}
    public string hazardTypeAssessment23 {get; set;}*/
    
    
    // Energized Systems
    public JHA_Item__c jhaItem24 {get; set;}
    public JHA_Item__c jhaItem25 {get; set;}
    public JHA_Item__c jhaItem26 {get; set;}
    public JHA_Item__c jhaItem27 {get; set;}
    public JHA_Item__c jhaItem28 {get; set;}
    public JHA_Item__c jhaItem29 {get; set;}
    
    public string hazardType24 {get; set;}
    public string hazardType25 {get; set;}
    public string hazardType26 {get; set;}
    public string hazardType27 {get; set;}
    public string hazardType28 {get; set;}
    public string hazardType29 {get; set;}
    
    /*public string hazardTypeAssessment24 {get; set;}
    public string hazardTypeAssessment25 {get; set;}
    public string hazardTypeAssessment26 {get; set;}
    public string hazardTypeAssessment27 {get; set;}
    public string hazardTypeAssessment28 {get; set;}
    public string hazardTypeAssessment29 {get; set;}*/
    
    
    // Emergency Response
    public JHA_Item__c jhaItem30 {get; set;}
    public JHA_Item__c jhaItem31 {get; set;}
    public JHA_Item__c jhaItem32 {get; set;}
    public JHA_Item__c jhaItem33 {get; set;}
    
    public string hazardType30 {get; set;}
    public string hazardType31 {get; set;}
    public string hazardType32 {get; set;}
    public string hazardType33 {get; set;}
    
    /*public string hazardTypeAssessment30 {get; set;}
    public string hazardTypeAssessment31 {get; set;}
    public string hazardTypeAssessment32 {get; set;}
    public string hazardTypeAssessment33 {get; set;}*/
    
    
    // Physical Hazards
    public JHA_Item__c jhaItem34 {get; set;}
    public JHA_Item__c jhaItem35 {get; set;}
    public JHA_Item__c jhaItem36 {get; set;}
    public JHA_Item__c jhaItem37 {get; set;}
    public JHA_Item__c jhaItem38 {get; set;}
    public JHA_Item__c jhaItem39 {get; set;}
    
    public string hazardType34 {get; set;}
    public string hazardType35 {get; set;}
    public string hazardType36 {get; set;}
    public string hazardType37 {get; set;}
    public string hazardType38 {get; set;}
    public string hazardType39 {get; set;}
    
    /*public string hazardTypeAssessment34 {get; set;}
    public string hazardTypeAssessment35 {get; set;}
    public string hazardTypeAssessment36 {get; set;}
    public string hazardTypeAssessment37 {get; set;}
    public string hazardTypeAssessment38 {get; set;}
    public string hazardTypeAssessment39 {get; set;}*/
    
    
    // Other
    public JHA_Item__c jhaItem40 {get; set;}
    
    public string hazardType40 {get; set;}
    
    /*public string hazardTypeAssessment40 {get; set;}*/
    
    
    /*public List<SelectOption> getHTAPickListValue()
    {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = JHA_Item__c.Hazard_Type_Assessment__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        options.add(new SelectOption('--None--', '--None--'));
        for (Schema.PicklistEntry f : ple)
        {
            if ((f.getValue() == 'No') || (f.getValue() == 'Yes'))
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }

        return options;
    }*/
    
    
    /*public List<SelectOption> getHazardRatePickListValue()
    {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = JHA_Item__c.Hazard_Type_Assessment__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        options.add(new SelectOption('--None--', '--None--'));
        for (Schema.PicklistEntry f : ple)
        {
            if ((f.getValue() != 'No') && (f.getValue() != 'Yes'))
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }

        return options;
    }*/
    
    
    
    public void initializeObjects() {
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
            jhaItemList[i] = new JHA_Item__c();
        }
        
        Hazard_Type__c hazardType;
        string s;
        for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
            s = string.valueof(i);
            hazardType = [SELECT Id, Name, Description__c FROM Hazard_Type__c WHERE Name = :s];
            jhaItemList[i].Hazard_Type__c = hazardType.Id;
            
            if (i == 0) {
                hazardType0 = hazardType.Description__c;
                jhaItem0 = jhaItemList[i];
            } else if (i == 1) {
                hazardType1 = hazardType.Description__c;
                jhaItem1 = jhaItemList[i];
            } else if (i == 2) {
                hazardType2 = hazardType.Description__c;
                jhaItem2 = jhaItemList[i];
            } else if (i == 3) {
                hazardType3 = hazardType.Description__c;
                jhaItem3 = jhaItemList[i];
            } else if (i == 4) {
                hazardType4 = hazardType.Description__c;
                jhaItem4 = jhaItemList[i];
            } else if (i == 5) {
                hazardType5 = hazardType.Description__c;
                jhaItem5 = jhaItemList[i];
            } else if (i == 6) {
                hazardType6 = hazardType.Description__c;
                jhaItem6 = jhaItemList[i];
            } else if (i == 7) {
                hazardType7 = hazardType.Description__c;
                jhaItem7 = jhaItemList[i];
            } else if (i == 8) {
                hazardType8 = hazardType.Description__c;
                jhaItem8 = jhaItemList[i];
            } else if (i == 9) {
                hazardType9 = hazardType.Description__c;
                jhaItem9 = jhaItemList[i];
            } else if (i == 10) {
                hazardType10 = hazardType.Description__c;
                jhaItem10 = jhaItemList[i];
            } else if (i == 11) {
                hazardType11 = hazardType.Description__c;
                jhaItem11 = jhaItemList[i];
            } else if (i == 12) {
                hazardType12 = hazardType.Description__c;
                jhaItem12 = jhaItemList[i];
            } else if (i == 13) {
                hazardType13 = hazardType.Description__c;
                jhaItem13 = jhaItemList[i];
            } else if (i == 14) {
                hazardType14 = hazardType.Description__c;
                jhaItem14 = jhaItemList[i];
            } else if (i == 15) {
                hazardType15 = hazardType.Description__c;
                jhaItem15 = jhaItemList[i];
            } else if (i == 16) {
                hazardType16 = hazardType.Description__c;
                jhaItem16 = jhaItemList[i];
            } else if (i == 17) {
                hazardType17 = hazardType.Description__c;
                jhaItem17 = jhaItemList[i];
            } else if (i == 18) {
                hazardType18 = hazardType.Description__c;
                jhaItem18 = jhaItemList[i];
            } else if (i == 19) {
                hazardType19 = hazardType.Description__c;
                jhaItem19 = jhaItemList[i];
            } else if (i == 20) {
                hazardType20 = hazardType.Description__c;
                jhaItem20 = jhaItemList[i];
            } else if (i == 21) {
                hazardType21 = hazardType.Description__c;
                jhaItem21 = jhaItemList[i];
            } else if (i == 22) {
                hazardType22 = hazardType.Description__c;
                jhaItem22 = jhaItemList[i];
            } else if (i == 23) {
                hazardType23 = hazardType.Description__c;
                jhaItem23 = jhaItemList[i];
            } else if (i == 24) {
                hazardType24 = hazardType.Description__c;
                jhaItem24 = jhaItemList[i];
            } else if (i == 25) {
                hazardType25 = hazardType.Description__c;
                jhaItem25 = jhaItemList[i];
            } else if (i == 26) {
                hazardType26 = hazardType.Description__c;
                jhaItem26 = jhaItemList[i];
            } else if (i == 27) {
                hazardType27 = hazardType.Description__c;
                jhaItem27 = jhaItemList[i];
            } else if (i == 28) {
                hazardType28 = hazardType.Description__c;
                jhaItem28 = jhaItemList[i];
            } else if (i == 29) {
                hazardType29 = hazardType.Description__c;
                jhaItem29 = jhaItemList[i];
            } else if (i == 30) {
                hazardType30 = hazardType.Description__c;
                jhaItem30 = jhaItemList[i];
            } else if (i == 31) {
                hazardType31 = hazardType.Description__c;
                jhaItem31 = jhaItemList[i];
            } else if (i == 32) {
                hazardType32 = hazardType.Description__c;
                jhaItem32 = jhaItemList[i];
            } else if (i == 33) {
                hazardType33 = hazardType.Description__c;
                jhaItem33 = jhaItemList[i];
            } else if (i == 34) {
                hazardType34 = hazardType.Description__c;
                jhaItem34 = jhaItemList[i];
            } else if (i == 35) {
                hazardType35 = hazardType.Description__c;
                jhaItem35 = jhaItemList[i];
            } else if (i == 36) {
                hazardType36 = hazardType.Description__c;
                jhaItem36 = jhaItemList[i];
            } else if (i == 37) {
                hazardType37 = hazardType.Description__c;
                jhaItem37 = jhaItemList[i];
            } else if (i == 38) {
                hazardType38 = hazardType.Description__c;
                jhaItem38 = jhaItemList[i];
            } else if (i == 39) {
                hazardType39 = hazardType.Description__c;
                jhaItem39 = jhaItemList[i];
            } else if (i == 40) {
                hazardType40 = hazardType.Description__c;
                jhaItem40 = jhaItemList[i];
            }
            
        }
        
    }
    
    
    public JHAFormController () {
        //*** Initialize Affected Area Multi-Select Picklists
        affectedAreaLeftSelected2 = new List<String>();
        affectedAreaRightSelected2 = new List<String>();
        affectedAreaLeftValues2.addAll(affectedAreaOrigValues2);
        
        affectedAreaLeftSelected3 = new List<String>();
        affectedAreaRightSelected3 = new List<String>();
        affectedAreaLeftValues3.addAll(affectedAreaOrigValues2);
        
        affectedAreaLeftSelected4 = new List<String>();
        affectedAreaRightSelected4 = new List<String>();
        affectedAreaLeftValues4.addAll(affectedAreaOrigValues4);
        
        affectedAreaLeftSelected6 = new List<String>();
        affectedAreaRightSelected6 = new List<String>();
        affectedAreaLeftValues6.addAll(affectedAreaOrigValues6);
        
        affectedAreaLeftSelected11 = new List<String>();
        affectedAreaRightSelected11 = new List<String>();
        affectedAreaLeftValues11.addAll(affectedAreaOrigValues11);
        
        affectedAreaLeftSelected12 = new List<String>();
        affectedAreaRightSelected12 = new List<String>();
        affectedAreaLeftValues12.addAll(affectedAreaOrigValues12);
        
        affectedAreaLeftSelected13 = new List<String>();
        affectedAreaRightSelected13 = new List<String>();
        affectedAreaLeftValues13.addAll(affectedAreaOrigValues13);
        
        affectedAreaLeftSelected14 = new List<String>();
        affectedAreaRightSelected14 = new List<String>();
        affectedAreaLeftValues14.addAll(affectedAreaOrigValues14);
        
        affectedAreaLeftSelected15 = new List<String>();
        affectedAreaRightSelected15 = new List<String>();
        affectedAreaLeftValues15.addAll(affectedAreaOrigValues15);
        
        affectedAreaLeftSelected17 = new List<String>();
        affectedAreaRightSelected17 = new List<String>();
        affectedAreaLeftValues17.addAll(affectedAreaOrigValues17);
        
        affectedAreaLeftSelected25 = new List<String>();
        affectedAreaRightSelected25 = new List<String>();
        affectedAreaLeftValues25.addAll(affectedAreaOrigValues25);
        
        affectedAreaLeftSelected29 = new List<String>();
        affectedAreaRightSelected29 = new List<String>();
        affectedAreaLeftValues29.addAll(affectedAreaOrigValues29);
        
        affectedAreaLeftSelected34 = new List<String>();
        affectedAreaRightSelected34 = new List<String>();
        affectedAreaLeftValues34.addAll(affectedAreaOrigValues34);
        
        affectedAreaLeftSelected36 = new List<String>();
        affectedAreaRightSelected36 = new List<String>();
        affectedAreaLeftValues36.addAll(affectedAreaOrigValues36);
        
        affectedAreaLeftSelected37 = new List<String>();
        affectedAreaRightSelected37 = new List<String>();
        affectedAreaLeftValues37.addAll(affectedAreaOrigValues37);
        
        affectedAreaLeftSelected38 = new List<String>();
        affectedAreaRightSelected38 = new List<String>();
        affectedAreaLeftValues38.addAll(affectedAreaOrigValues38);
        
        affectedAreaLeftSelected39 = new List<String>();
        affectedAreaRightSelected39 = new List<String>();
        affectedAreaLeftValues39.addAll(affectedAreaOrigValues39);
        
        
        //*** Initialize PPE ID Multi-Select Picklists
        ppeIdLeftSelected2 = new List<String>();
        ppeIdRightSelected2 = new List<String>();
        ppeIdLeftValues2.addAll(ppeIdOrigValues2);
        
        ppeIdLeftSelected3 = new List<String>();
        ppeIdRightSelected3 = new List<String>();
        ppeIdLeftValues3.addAll(ppeIdOrigValues3);
        
        ppeIdLeftSelected4 = new List<String>();
        ppeIdRightSelected4 = new List<String>();
        ppeIdLeftValues4.addAll(ppeIdOrigValues4);
        
        ppeIdLeftSelected6 = new List<String>();
        ppeIdRightSelected6 = new List<String>();
        ppeIdLeftValues6.addAll(ppeIdOrigValues6);
        
        ppeIdLeftSelected11 = new List<String>();
        ppeIdRightSelected11 = new List<String>();
        ppeIdLeftValues11.addAll(ppeIdOrigValues11);
        
        ppeIdLeftSelected12 = new List<String>();
        ppeIdRightSelected12 = new List<String>();
        ppeIdLeftValues12.addAll(ppeIdOrigValues12);
        
        ppeIdLeftSelected13 = new List<String>();
        ppeIdRightSelected13 = new List<String>();
        ppeIdLeftValues13.addAll(ppeIdOrigValues13);
        
        ppeIdLeftSelected14 = new List<String>();
        ppeIdRightSelected14 = new List<String>();
        ppeIdLeftValues14.addAll(ppeIdOrigValues14);
        
        ppeIdLeftSelected15 = new List<String>();
        ppeIdRightSelected15 = new List<String>();
        ppeIdLeftValues15.addAll(ppeIdOrigValues15);
        
        ppeIdLeftSelected16 = new List<String>();
        ppeIdRightSelected16 = new List<String>();
        ppeIdLeftValues16.addAll(ppeIdOrigValues16);
        
        ppeIdLeftSelected17 = new List<String>();
        ppeIdRightSelected17 = new List<String>();
        ppeIdLeftValues17.addAll(ppeIdOrigValues17);
        
        ppeIdLeftSelected18 = new List<String>();
        ppeIdRightSelected18 = new List<String>();
        ppeIdLeftValues18.addAll(ppeIdOrigValues18);
        
        ppeIdLeftSelected25 = new List<String>();
        ppeIdRightSelected25 = new List<String>();
        ppeIdLeftValues25.addAll(ppeIdOrigValues25);
        
        ppeIdLeftSelected29 = new List<String>();
        ppeIdRightSelected29 = new List<String>();
        ppeIdLeftValues29.addAll(ppeIdOrigValues29);
        
        ppeIdLeftSelected34 = new List<String>();
        ppeIdRightSelected34 = new List<String>();
        ppeIdLeftValues34.addAll(ppeIdOrigValues34);
        
        ppeIdLeftSelected36 = new List<String>();
        ppeIdRightSelected36 = new List<String>();
        ppeIdLeftValues36.addAll(ppeIdOrigValues36);
        
        ppeIdLeftSelected37 = new List<String>();
        ppeIdRightSelected37 = new List<String>();
        ppeIdLeftValues37.addAll(ppeIdOrigValues37);
        
        ppeIdLeftSelected38 = new List<String>();
        ppeIdRightSelected38 = new List<String>();
        ppeIdLeftValues38.addAll(ppeIdOrigValues38);
        
        ppeIdLeftSelected39 = new List<String>();
        ppeIdRightSelected39 = new List<String>();
        ppeIdLeftValues39.addAll(ppeIdOrigValues39);
        
        
        initializeObjects();
        
        addr = new Address__c();
        
        // Get query string parameters, if they exist
        Id id = ApexPages.currentPage().getParameters().get('id');
        jhaForm = (id == null) ? new JHA_Form__c() : 
            [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Id = :id];
        
        Id addrId = ApexPages.currentPage().getParameters().get('addrId');
        
        String msg = ApexPages.currentPage().getParameters().get('msg');
        if (String.isNotBlank(msg)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
        }
        
        epriseLoginId = ApexPages.currentPage().getParameters().get('epriseLoginId'); System.debug('epriseLoginId = ' + epriseLoginId);
    	firstName = ApexPages.currentPage().getParameters().get('firstName'); System.debug('firstName = ' + firstName);
    	lastName = ApexPages.currentPage().getParameters().get('lastName'); System.debug('lastName = ' + lastName);
    	email = ApexPages.currentPage().getParameters().get('email'); System.debug('email = ' + email);
        
        if (String.isNotBlank(epriseLoginId) && epriseLoginId != 'null') {
            // if a null value is passed in as a query parameter for epriseLoginId then the value that gets retrieved is set to the string 'null'!!!!
            // if no query parameter is passed in for epriseLoginId then the value that gets retrieved is a null object.
            userLoginName = epriseLoginId;
        }
        else {
            userLoginName = UserInfo.getUserName();
        }
        
        System.debug('In constructor JHAFormController');
        
        if (addrId != null) {
            // Load page with just the address information
            Address__c addrTemp = null;
        	Account_Address__c acctAddrJunctionObj = null;
            
            try {
                addrTemp = [SELECT Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c FROM Address__c WHERE id = :addrId];
                addrState = addrTemp.State_Province__c;
                disableFlag = true;
                
                addr.Address_Line_1__c = addrTemp.Address_Line_1__c;
                addr.Address_Line_2__c = addrTemp.Address_Line_2__c;
                addr.Country__c = addrTemp.Country__c;
                addr.State_Province__c = addrTemp.State_Province__c;
                addr.City__c = addrTemp.City__c;
                addr.Postal_Code__c = addrTemp.Postal_Code__c;
                
                jhaForm.Jobsite_Address__c = addrId;
                jhaForm.Employee__c = userLoginName;
                jhaForm.Date__c = System.today();
                jhaForm.Evaluation_Type__c = 'First Time Evaluation';
                
                acctAddrJunctionObj = [SELECT Id, Name, Account__c, Address__c, Active__c, Physical__c FROM Account_Address__c WHERE Address__c = :addrTemp.Id];
                jhaForm.Customer_Name__c = acctAddrJunctionObj.Account__c;
            }
            catch (QueryException e) {
                String s = null;
            
                if (addrTemp == null) {
                    jhaForm.Customer_Name__c = null;
                    jhaForm.Jobsite_Address__c = null;
                    jobSiteAddress = null;
                    addr.Address_Line_1__c = null;
                    addr.Address_Line_2__c = null;
                    addr.Country__c = null;
                    addr.State_Province__c = null;
                    addr.City__c = null;
                    addr.Postal_Code__c = null;
                    disableFlag = false;
                    addrState = null;
                    loadExistingForm = false;
                    s = 'Address not found or invalid!';
                }
                else if (acctAddrJunctionObj == null) {
                    jhaForm.Customer_Name__c = null;
                    s = 'No customer account exists for this address!  Please leave blank and proceed with the rest of the form.';
                }
                else {
                    s = e.getMessage();
                }
                ApexPages.Message exMsg = new ApexPages.Message(ApexPages.Severity.INFO, s);
                ApexPages.addMessage(exMsg);
            }
            finally {
                callfunc = '<script> setAddressFieldVisibility(' + disableFlag + '); </script>';
            }
        }
        else if (id != null) {
            // Load an existing form
            loadExistingForm = true;
            
            retrieveAccountAndAddressFields();
            addrState = addr.State_Province__c;
            
            loadForm(id);
            
			System.debug('Load existing form id = ' + id);

            /*
            System.debug('Contents of jhaForm object: ' + jhaForm.Customer_Name__c + ':' + jhaForm.Jobsite_Address__c + ':' + jhaForm.Facility_Type__c + ':' + jhaForm.Date__c + ':' + jhaForm.Employee__c + ':' + jhaForm.Evaluation_Type__c + ':' + jhaForm.Special_Comments__c + ':' + jhaForm.Id + ':' + jhaForm.Name);
            System.debug('Contents of jhaItem0: ' + jhaItem0.JHA_Form__c + ':' + jhaItem0.Id + ':' + jhaItem0.Name + ':' + jhaItem0.Affected_Area__c + ':' + jhaItem0.Hazard_Type__c + ':' + jhaItem0.Hazard_Type_Assessment_Rate__c + ':' + jhaItem0.Hazard_Type_Assessment__c + ':' + jhaItem0.PPE_ID__c + ':' + jhaItem0.Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 0: ' + jhaItemList[0].JHA_Form__c + ':' + jhaItemList[0].Id + ':' + jhaItemList[0].Name + ':' + jhaItemList[0].Affected_Area__c + ':' + jhaItemList[0].Hazard_Type__c + ':' + jhaItemList[0].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[0].Hazard_Type_Assessment__c + ':' + jhaItemList[0].PPE_ID__c + ':' + jhaItemList[0].Hazard_Description__c);
            System.debug('Contents of jhaItem1: ' + jhaItem1.JHA_Form__c + ':' + jhaItem1.Id + ':' + jhaItem1.Name + ':' + jhaItem1.Affected_Area__c + ':' + jhaItem1.Hazard_Type__c + ':' + jhaItem1.Hazard_Type_Assessment_Rate__c + ':' + jhaItem1.Hazard_Type_Assessment__c + ':' + jhaItem1.PPE_ID__c + ':' + jhaItem1.Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 1: ' + jhaItemList[1].JHA_Form__c + ':' + jhaItemList[1].Id + ':' + jhaItemList[1].Name + ':' + jhaItemList[1].Affected_Area__c + ':' + jhaItemList[1].Hazard_Type__c + ':' + jhaItemList[1].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[1].Hazard_Type_Assessment__c + ':' + jhaItemList[1].PPE_ID__c + ':' + jhaItemList[1].Hazard_Description__c);
            System.debug('Contents of jhaItem2: ' + jhaItem2.JHA_Form__c + ':' + jhaItem2.Id + ':' + jhaItem2.Name + ':' + jhaItem2.Affected_Area__c + ':' + jhaItem2.Hazard_Type__c + ':' + jhaItem2.Hazard_Type_Assessment_Rate__c + ':' + jhaItem2.Hazard_Type_Assessment__c + ':' + jhaItem2.PPE_ID__c + ':' + jhaItem2.Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 2: ' + jhaItemList[2].JHA_Form__c + ':' + jhaItemList[2].Id + ':' + jhaItemList[2].Name + ':' + jhaItemList[2].Affected_Area__c + ':' + jhaItemList[2].Hazard_Type__c + ':' + jhaItemList[2].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[2].Hazard_Type_Assessment__c + ':' + jhaItemList[2].PPE_ID__c + ':' + jhaItemList[2].Hazard_Description__c);
            System.debug('Contents of jhaItem3: ' + jhaItem3.JHA_Form__c + ':' + jhaItem3.Id + ':' + jhaItem3.Name + ':' + jhaItem3.Affected_Area__c + ':' + jhaItem3.Hazard_Type__c + ':' + jhaItem3.Hazard_Type_Assessment_Rate__c + ':' + jhaItem3.Hazard_Type_Assessment__c + ':' + jhaItem3.PPE_ID__c + ':' + jhaItem0.Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 3: ' + jhaItemList[3].JHA_Form__c + ':' + jhaItemList[3].Id + ':' + jhaItemList[3].Name + ':' + jhaItemList[3].Affected_Area__c + ':' + jhaItemList[3].Hazard_Type__c + ':' + jhaItemList[3].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[3].Hazard_Type_Assessment__c + ':' + jhaItemList[3].PPE_ID__c + ':' + jhaItemList[3].Hazard_Description__c);
			System.debug('Contents of jhaItem4: ' + jhaItem4.JHA_Form__c + ':' + jhaItem4.Id + ':' + jhaItem4.Name + ':' + jhaItem4.Affected_Area__c + ':' + jhaItem4.Hazard_Type__c + ':' + jhaItem4.Hazard_Type_Assessment_Rate__c + ':' + jhaItem4.Hazard_Type_Assessment__c + ':' + jhaItem4.PPE_ID__c + ':' + jhaItem0.Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 4: ' + jhaItemList[4].JHA_Form__c + ':' + jhaItemList[4].Id + ':' + jhaItemList[4].Name + ':' + jhaItemList[4].Affected_Area__c + ':' + jhaItemList[4].Hazard_Type__c + ':' + jhaItemList[4].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[4].Hazard_Type_Assessment__c + ':' + jhaItemList[4].PPE_ID__c + ':' + jhaItemList[4].Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 27: ' + jhaItemList[27].JHA_Form__c + ':' + jhaItemList[27].Id + ':' + jhaItemList[27].Name + ':' + jhaItemList[27].Affected_Area__c + ':' + jhaItemList[27].Hazard_Type__c + ':' + jhaItemList[27].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[27].Hazard_Type_Assessment__c + ':' + jhaItemList[27].PPE_ID__c + ':' + jhaItemList[27].Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 35: ' + jhaItemList[35].JHA_Form__c + ':' + jhaItemList[35].Id + ':' + jhaItemList[35].Name + ':' + jhaItemList[35].Affected_Area__c + ':' + jhaItemList[35].Hazard_Type__c + ':' + jhaItemList[35].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[35].Hazard_Type_Assessment__c + ':' + jhaItemList[35].PPE_ID__c + ':' + jhaItemList[35].Hazard_Description__c);
			*/
        }
        else {
            // New form
            loadExistingForm = false;
            disableFlag = false;
            addrState = null;
            callfunc = '<script> disableFieldsOnFormLoad(' + disableFlag + '); </script>';
            
            jhaForm.Employee__c = userLoginName;
            jhaForm.Date__c = System.today();
            jhaForm.Evaluation_Type__c = 'First Time Evaluation';
            
            System.debug('Open new form');
        }
    }
    
    
    public void cancel() {
        loadExistingForm = false;
        if (String.isNotBlank(epriseLoginId)) {
            userLoginName = epriseLoginId;
        }
        else {
            userLoginName = UserInfo.getUserName();
        }
        disableFlag = false;
        addrState = null;
        callfunc = '<script> disableFieldsOnFormLoad(' + disableFlag + '); </script>';
        
        jhaForm.Id = null;
        jhaForm.Customer_Name__c = null;
        jhaForm.Jobsite_Address__c = null;
        jhaForm.Facility_Type__c = null;
        jhaForm.Date__c = System.today();
        jhaForm.Employee__c = userLoginName;
        jhaForm.Evaluation_Type__c = 'First Time Evaluation';
        jhaForm.Special_Comments__c = null;
        
        addr.Id = null;
        addr.Address_Line_1__c = null;
        addr.Address_Line_2__c = null;
        addr.Country__c = null;
        addr.State_Province__c = null;
        addr.City__c = null;
        addr.Postal_Code__c = null;
        
        jobSiteAddress = null;
        
        jhaItem0.Hazard_Type_Assessment__c = null; //hazardTypeAssessment0 = null;
        jhaItem0.Affected_Area__c = null;
        jhaItem0.PPE_ID__c = null;
        jhaItem0.Hazard_Description__c = null;
        jhaItem0.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem0.JHA_Form__c = null;
        jhaItem0.Id = null;
        jhaItem1.Hazard_Type_Assessment__c = null; //hazardTypeAssessment1 = null;
        jhaItem1.Affected_Area__c = null;
        jhaItem1.PPE_ID__c = null;
        jhaItem1.Hazard_Description__c = null;
        jhaItem1.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem1.JHA_Form__c = null;
        jhaItem1.Id = null;
        jhaItem2.Hazard_Type_Assessment__c = null; //hazardTypeAssessment2 = null;
        jhaItem2.Affected_Area__c = null; affectedAreaLeftSelected2 = null; affectedAreaRightSelected2 = null; affectedAreaLeftValues2.addAll(affectedAreaOrigValues2); affectedAreaRightValues2.clear();
        jhaItem2.PPE_ID__c = null; ppeIdLeftSelected2 = null; ppeIdRightSelected2 = null; ppeIdLeftValues2.addAll(ppeIdOrigValues2); ppeIdRightValues2.clear();
        jhaItem2.Hazard_Description__c = null;
        jhaItem2.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem2.JHA_Form__c = null;
        jhaItem2.Id = null;
        jhaItem3.Hazard_Type_Assessment__c = null; //hazardTypeAssessment3 = null;
        jhaItem3.Affected_Area__c = null; affectedAreaLeftSelected3 = null; affectedAreaRightSelected3 = null; affectedAreaLeftValues3.addAll(affectedAreaOrigValues3); affectedAreaRightValues3.clear();
        jhaItem3.PPE_ID__c = null; ppeIdLeftSelected3 = null; ppeIdRightSelected3 = null; ppeIdLeftValues3.addAll(ppeIdOrigValues3); ppeIdRightValues3.clear();
        jhaItem3.Hazard_Description__c = null;
        jhaItem3.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem3.JHA_Form__c = null;
        jhaItem3.Id = null;
        jhaItem4.Hazard_Type_Assessment__c = null; //hazardTypeAssessment4 = null;
        jhaItem4.Affected_Area__c = null; affectedAreaLeftSelected4 = null; affectedAreaRightSelected4 = null; affectedAreaLeftValues4.addAll(affectedAreaOrigValues4); affectedAreaRightValues4.clear();
        jhaItem4.PPE_ID__c = null; ppeIdLeftSelected4 = null; ppeIdRightSelected4 = null; ppeIdLeftValues4.addAll(ppeIdOrigValues4); ppeIdRightValues4.clear();
        jhaItem4.Hazard_Description__c = null;
        jhaItem4.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem4.JHA_Form__c = null;
        jhaItem4.Id = null;
        jhaItem5.Hazard_Type_Assessment__c = null; //hazardTypeAssessment5 = null;
        jhaItem5.Affected_Area__c = null;
        jhaItem5.PPE_ID__c = null;
        jhaItem5.Hazard_Description__c = null;
        jhaItem5.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem5.JHA_Form__c = null;
        jhaItem5.Id = null;
        jhaItem6.Hazard_Type_Assessment__c = null; //hazardTypeAssessment6 = null;
        jhaItem6.Affected_Area__c = null; affectedAreaLeftSelected6 = null; affectedAreaRightSelected6 = null; affectedAreaLeftValues6.addAll(affectedAreaOrigValues6); affectedAreaRightValues6.clear();
        jhaItem6.PPE_ID__c = null; ppeIdLeftSelected6 = null; ppeIdRightSelected6 = null; ppeIdLeftValues6.addAll(ppeIdOrigValues6); ppeIdRightValues6.clear();
        jhaItem6.Hazard_Description__c = null;
        jhaItem6.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem6.JHA_Form__c = null;
        jhaItem6.Id = null;
        jhaItem7.Hazard_Type_Assessment__c = null; //hazardTypeAssessment7 = null;
        jhaItem7.Affected_Area__c = null;
        jhaItem7.PPE_ID__c = null;
        jhaItem7.Hazard_Description__c = null;
        jhaItem7.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem7.JHA_Form__c = null;
        jhaItem7.Id = null;
        jhaItem8.Hazard_Type_Assessment__c = null; //hazardTypeAssessment8 = null;
        jhaItem8.Affected_Area__c = null;
        jhaItem8.PPE_ID__c = null;
        jhaItem8.Hazard_Description__c = null;
        jhaItem8.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem8.JHA_Form__c = null;
        jhaItem8.Id = null;
        jhaItem9.Hazard_Type_Assessment__c = null; //hazardTypeAssessment9 = null;
        jhaItem9.Affected_Area__c = null;
        jhaItem9.PPE_ID__c = null;
        jhaItem9.Hazard_Description__c = null;
        jhaItem9.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem9.JHA_Form__c = null;
        jhaItem9.Id = null;
        jhaItem10.Hazard_Type_Assessment__c = null; //hazardTypeAssessment10 = null;
        jhaItem10.Affected_Area__c = null;
        jhaItem10.PPE_ID__c = null;
        jhaItem10.Hazard_Description__c = null;
        jhaItem10.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem10.JHA_Form__c = null;
        jhaItem10.Id = null;
        jhaItem11.Hazard_Type_Assessment__c = null; //hazardTypeAssessment11 = null;
        jhaItem11.Affected_Area__c = null; affectedAreaLeftSelected11 = null; affectedAreaRightSelected11 = null; affectedAreaLeftValues11.addAll(affectedAreaOrigValues11); affectedAreaRightValues11.clear();
        jhaItem11.PPE_ID__c = null; ppeIdLeftSelected11 = null; ppeIdRightSelected11 = null; ppeIdLeftValues11.addAll(ppeIdOrigValues11); ppeIdRightValues11.clear();
        jhaItem11.Hazard_Description__c = null;
        jhaItem11.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem11.JHA_Form__c = null;
        jhaItem11.Id = null;
        jhaItem12.Hazard_Type_Assessment__c = null; //hazardTypeAssessment12 = null;
        jhaItem12.Affected_Area__c = null; affectedAreaLeftSelected12 = null; affectedAreaRightSelected12 = null; affectedAreaLeftValues12.addAll(affectedAreaOrigValues12); affectedAreaRightValues12.clear();
        jhaItem12.PPE_ID__c = null; ppeIdLeftSelected12 = null; ppeIdRightSelected12 = null; ppeIdLeftValues12.addAll(ppeIdOrigValues12); ppeIdRightValues12.clear();
        jhaItem12.Hazard_Description__c = null;
        jhaItem12.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem12.JHA_Form__c = null;
        jhaItem12.Id = null;
        jhaItem13.Hazard_Type_Assessment__c = null; //hazardTypeAssessment13 = null;
        jhaItem13.Affected_Area__c = null; affectedAreaLeftSelected13 = null; affectedAreaRightSelected13 = null; affectedAreaLeftValues13.addAll(affectedAreaOrigValues13); affectedAreaRightValues13.clear();
        jhaItem13.PPE_ID__c = null; ppeIdLeftSelected13 = null; ppeIdRightSelected13 = null; ppeIdLeftValues13.addAll(ppeIdOrigValues13); ppeIdRightValues13.clear();
        jhaItem13.Hazard_Description__c = null;
        jhaItem13.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem13.JHA_Form__c = null;
        jhaItem13.Id = null;
        jhaItem14.Hazard_Type_Assessment__c = null; //hazardTypeAssessment14 = null;
        jhaItem14.Affected_Area__c = null; affectedAreaLeftSelected14 = null; affectedAreaRightSelected14 = null; affectedAreaLeftValues14.addAll(affectedAreaOrigValues14); affectedAreaRightValues14.clear();
        jhaItem14.PPE_ID__c = null; ppeIdLeftSelected14 = null; ppeIdRightSelected14 = null; ppeIdLeftValues14.addAll(ppeIdOrigValues14); ppeIdRightValues14.clear();
        jhaItem14.Hazard_Description__c = null;
        jhaItem14.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem14.JHA_Form__c = null;
        jhaItem14.Id = null;
        jhaItem15.Hazard_Type_Assessment__c = null; //hazardTypeAssessment15 = null;
        jhaItem15.Affected_Area__c = null; affectedAreaLeftSelected15 = null; affectedAreaRightSelected15 = null; affectedAreaLeftValues15.addAll(affectedAreaOrigValues15); affectedAreaRightValues15.clear();
        jhaItem15.PPE_ID__c = null; ppeIdLeftSelected15 = null; ppeIdRightSelected15 = null; ppeIdLeftValues15.addAll(ppeIdOrigValues15); ppeIdRightValues15.clear();
        jhaItem15.Hazard_Description__c = null;
        jhaItem15.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem15.JHA_Form__c = null;
        jhaItem15.Id = null;
        
        jhaItem16.Hazard_Type_Assessment__c = null; //hazardTypeAssessment16 = null;
        jhaItem16.Affected_Area__c = null;
        jhaItem16.PPE_ID__c = null; ppeIdLeftSelected16 = null; ppeIdRightSelected16 = null; ppeIdLeftValues16.addAll(ppeIdOrigValues16); ppeIdRightValues16.clear();
        jhaItem16.Hazard_Description__c = null;
        jhaItem16.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem16.JHA_Form__c = null;
        jhaItem16.Id = null;
        jhaItem17.Hazard_Type_Assessment__c = null; //hazardTypeAssessment17 = null;
        jhaItem17.Affected_Area__c = null; affectedAreaLeftSelected17 = null; affectedAreaRightSelected17 = null; affectedAreaLeftValues17.addAll(affectedAreaOrigValues17); affectedAreaRightValues17.clear();
        jhaItem17.PPE_ID__c = null; ppeIdLeftSelected17 = null; ppeIdRightSelected17 = null; ppeIdLeftValues17.addAll(ppeIdOrigValues17); ppeIdRightValues17.clear();
        jhaItem17.Hazard_Description__c = null;
        jhaItem17.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem17.JHA_Form__c = null;
        jhaItem17.Id = null;
        jhaItem18.Hazard_Type_Assessment__c = null; //hazardTypeAssessment18 = null;
        jhaItem18.Affected_Area__c = null;
        jhaItem18.PPE_ID__c = null; ppeIdLeftSelected18 = null; ppeIdRightSelected18 = null; ppeIdLeftValues18.addAll(ppeIdOrigValues18); ppeIdRightValues18.clear();
        jhaItem18.Hazard_Description__c = null;
        jhaItem18.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem18.JHA_Form__c = null;
        jhaItem18.Id = null;
        jhaItem19.Hazard_Type_Assessment__c = null; //hazardTypeAssessment19 = null;
        jhaItem19.Affected_Area__c = null;
        jhaItem19.PPE_ID__c = null;
        jhaItem19.Hazard_Description__c = null;
        jhaItem19.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem19.JHA_Form__c = null;
        jhaItem19.Id = null;
        jhaItem20.Hazard_Type_Assessment__c = null; //hazardTypeAssessment20 = null;
        jhaItem20.Affected_Area__c = null;
        jhaItem20.PPE_ID__c = null;
        jhaItem20.Hazard_Description__c = null;
        jhaItem20.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem20.JHA_Form__c = null;
        jhaItem20.Id = null;
        jhaItem21.Hazard_Type_Assessment__c = null; //hazardTypeAssessment21 = null;
        jhaItem21.Affected_Area__c = null;
        jhaItem21.PPE_ID__c = null;
        jhaItem21.Hazard_Description__c = null;
        jhaItem21.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem21.JHA_Form__c = null;
        jhaItem21.Id = null;
        jhaItem22.Hazard_Type_Assessment__c = null; //hazardTypeAssessment22 = null;
        jhaItem22.Affected_Area__c = null;
        jhaItem22.PPE_ID__c = null;
        jhaItem22.Hazard_Description__c = null;
        jhaItem22.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem22.JHA_Form__c = null;
        jhaItem22.Id = null;
        jhaItem23.Hazard_Type_Assessment__c = null; //hazardTypeAssessment23 = null;
        jhaItem23.Affected_Area__c = null;
        jhaItem23.PPE_ID__c = null;
        jhaItem23.Hazard_Description__c = null;
        jhaItem23.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem23.JHA_Form__c = null;
        jhaItem23.Id = null;
        
        jhaItem24.Hazard_Type_Assessment__c = null; //hazardTypeAssessment24 = null;
        jhaItem24.Affected_Area__c = null;
        jhaItem24.PPE_ID__c = null;
        jhaItem24.Hazard_Description__c = null;
        jhaItem24.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem24.JHA_Form__c = null;
        jhaItem24.Id = null;
        jhaItem25.Hazard_Type_Assessment__c = null; //hazardTypeAssessment25 = null;
        jhaItem25.Affected_Area__c = null; affectedAreaLeftSelected25 = null; affectedAreaRightSelected25 = null; affectedAreaLeftValues25.addAll(affectedAreaOrigValues25); affectedAreaRightValues25.clear();
        jhaItem25.PPE_ID__c = null; ppeIdLeftSelected25 = null; ppeIdRightSelected25 = null; ppeIdLeftValues25.addAll(ppeIdOrigValues25); ppeIdRightValues25.clear();
        jhaItem25.Hazard_Description__c = null;
        jhaItem25.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem25.JHA_Form__c = null;
        jhaItem25.Id = null;
        jhaItem26.Hazard_Type_Assessment__c = null; //hazardTypeAssessment26 = null;
        jhaItem26.Affected_Area__c = null;
        jhaItem26.PPE_ID__c = null;
        jhaItem26.Hazard_Description__c = null;
        jhaItem26.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem26.JHA_Form__c = null;
        jhaItem26.Id = null;
        jhaItem27.Hazard_Type_Assessment_Rate__c = null; //hazardTypeAssessment27 = null;
        jhaItem27.Affected_Area__c = null;
        jhaItem27.PPE_ID__c = null;
        jhaItem27.Hazard_Description__c = null;
        jhaItem27.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem27.JHA_Form__c = null;
        jhaItem27.Id = null;
        jhaItem28.Hazard_Type_Assessment__c = null; //hazardTypeAssessment28 = null;
        jhaItem28.Affected_Area__c = null;
        jhaItem28.PPE_ID__c = null;
        jhaItem28.Hazard_Description__c = null;
        jhaItem28.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem28.JHA_Form__c = null;
        jhaItem28.Id = null;
        jhaItem29.Hazard_Type_Assessment__c = null; //hazardTypeAssessment29 = null;
        jhaItem29.Affected_Area__c = null; affectedAreaLeftSelected29 = null; affectedAreaRightSelected29 = null; affectedAreaLeftValues29.addAll(affectedAreaOrigValues29); affectedAreaRightValues29.clear();
        jhaItem29.PPE_ID__c = null; ppeIdLeftSelected29 = null; ppeIdRightSelected29 = null; ppeIdLeftValues29.addAll(ppeIdOrigValues29); ppeIdRightValues29.clear();
        jhaItem29.Hazard_Description__c = null;
        jhaItem29.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem29.JHA_Form__c = null;
        jhaItem29.Id = null;
        
        jhaItem30.Hazard_Type_Assessment__c = null; //hazardTypeAssessment30 = null;
        jhaItem30.Affected_Area__c = null;
        jhaItem30.PPE_ID__c = null;
        jhaItem30.Hazard_Description__c = null;
        jhaItem30.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem30.JHA_Form__c = null;
        jhaItem30.Id = null;
        jhaItem31.Hazard_Type_Assessment__c = null; //hazardTypeAssessment31 = null;
        jhaItem31.Affected_Area__c = null;
        jhaItem31.PPE_ID__c = null;
        jhaItem31.Hazard_Description__c = null;
        jhaItem31.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem31.JHA_Form__c = null;
        jhaItem31.Id = null;
        jhaItem32.Hazard_Type_Assessment__c = null; //hazardTypeAssessment32 = null;
        jhaItem32.Affected_Area__c = null;
        jhaItem32.PPE_ID__c = null;
        jhaItem32.Hazard_Description__c = null;
        jhaItem32.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem32.JHA_Form__c = null;
        jhaItem32.Id = null;
        jhaItem33.Hazard_Type_Assessment__c = null; //hazardTypeAssessment33 = null;
        jhaItem33.Affected_Area__c = null;
        jhaItem33.PPE_ID__c = null;
        jhaItem33.Hazard_Description__c = null;
        jhaItem33.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem33.JHA_Form__c = null;
        jhaItem33.Id = null;
        
        jhaItem34.Hazard_Type_Assessment__c = null; //hazardTypeAssessment34 = null;
        jhaItem34.Affected_Area__c = null; affectedAreaLeftSelected34 = null; affectedAreaRightSelected34 = null; affectedAreaLeftValues34.addAll(affectedAreaOrigValues34); affectedAreaRightValues34.clear();
        jhaItem34.PPE_ID__c = null; ppeIdLeftSelected34 = null; ppeIdRightSelected34 = null; ppeIdLeftValues34.addAll(ppeIdOrigValues34); ppeIdRightValues34.clear();
        jhaItem34.Hazard_Description__c = null;
        jhaItem34.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem34.JHA_Form__c = null;
        jhaItem34.Id = null;
        jhaItem35.Hazard_Type_Assessment__c = null; //hazardTypeAssessment35 = null;
        jhaItem35.Affected_Area__c = null;
        jhaItem35.PPE_ID__c = null;
        jhaItem35.Hazard_Description__c = null;
        jhaItem35.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem35.JHA_Form__c = null;
        jhaItem35.Id = null;
        jhaItem36.Hazard_Type_Assessment__c = null; //hazardTypeAssessment36 = null;
        jhaItem36.Affected_Area__c = null; affectedAreaLeftSelected36 = null; affectedAreaRightSelected36 = null; affectedAreaLeftValues36.addAll(affectedAreaOrigValues36); affectedAreaRightValues36.clear();
        jhaItem36.PPE_ID__c = null; ppeIdLeftSelected36 = null; ppeIdRightSelected36 = null; ppeIdLeftValues36.addAll(ppeIdOrigValues36); ppeIdRightValues36.clear();
        jhaItem36.Hazard_Description__c = null;
        jhaItem36.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem36.JHA_Form__c = null;
        jhaItem36.Id = null;
        jhaItem37.Hazard_Type_Assessment__c = null; //hazardTypeAssessment37 = null;
        jhaItem37.Affected_Area__c = null; affectedAreaLeftSelected37 = null; affectedAreaRightSelected37 = null; affectedAreaLeftValues37.addAll(affectedAreaOrigValues37); affectedAreaRightValues37.clear();
        jhaItem37.PPE_ID__c = null; ppeIdLeftSelected37 = null; ppeIdRightSelected37 = null; ppeIdLeftValues37.addAll(ppeIdOrigValues37); ppeIdRightValues37.clear();
        jhaItem37.Hazard_Description__c = null;
        jhaItem37.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem37.JHA_Form__c = null;
        jhaItem37.Id = null;
        jhaItem38.Hazard_Type_Assessment__c = null; //hazardTypeAssessment38 = null;
        jhaItem38.Affected_Area__c = null; affectedAreaLeftSelected38 = null; affectedAreaRightSelected38 = null; affectedAreaLeftValues38.addAll(affectedAreaOrigValues38); affectedAreaRightValues38.clear();
        jhaItem38.PPE_ID__c = null; ppeIdLeftSelected38 = null; ppeIdRightSelected38 = null; ppeIdLeftValues38.addAll(ppeIdOrigValues38); ppeIdRightValues38.clear();
        jhaItem38.Hazard_Description__c = null;
        jhaItem38.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem38.JHA_Form__c = null;
        jhaItem38.Id = null;
        jhaItem39.Hazard_Type_Assessment__c = null; //hazardTypeAssessment39 = null;
        jhaItem39.Affected_Area__c = null; affectedAreaLeftSelected39 = null; affectedAreaRightSelected39 = null; affectedAreaLeftValues39.addAll(affectedAreaOrigValues39); affectedAreaRightValues39.clear();
        jhaItem39.PPE_ID__c = null; ppeIdLeftSelected39 = null; ppeIdRightSelected39 = null; ppeIdLeftValues39.addAll(ppeIdOrigValues39); ppeIdRightValues39.clear();
        jhaItem39.Hazard_Description__c = null;
        jhaItem39.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem39.JHA_Form__c = null;
        jhaItem39.Id = null;
        
        jhaItem40.Hazard_Type_Assessment__c = null; //hazardTypeAssessment40 = null;
        jhaItem40.Affected_Area__c = null;
        jhaItem40.PPE_ID__c = null;
        jhaItem40.Hazard_Description__c = null;
        jhaItem40.Hazard_Type_Assessment_Rate__c = null;
        //jhaItem40.JHA_Form__c = null;
        jhaItem40.Id = null;
        
        System.debug('Cancel form');
    }
    
    
    public PageReference save() {
        Savepoint sp = Database.setSavepoint();

        try {
            System.debug('Save form');
            
            // *** FIRST check if the required address fields all have a value (Address Line 2 and Zip Code are optional), if not throw an exception
            if (String.isBlank(addr.Address_Line_1__c)) {
                // Address Line 1 field not set to a value
                throw new SubmitException('Address field "Address Line 1" is undefined. Please update! Form will not be saved!');
            }
            else if (String.isBlank(addr.Country__c) || (addr.Country__c == '--None--')) {
                // Country field not set to a value
                throw new SubmitException('Address field "Country" is undefined. Please update! Form will not be saved!');
            }
            else if (statesAvailableForCountry == 'True' && (String.isBlank(addr.State_Province__c) || (addr.State_Province__c == '--None--'))) {
                // State field not set to a value
                throw new SubmitException('Address field "State" is undefined. Please update! Form will not be saved!');
                
                //System.debug('States available for country: ' + statesAvailableForCountry);
            }
            else if (String.isBlank(addr.City__c)) {
                // City field not set to a value
                throw new SubmitException('Address field "City" is undefined. Please update! Form will not be saved!');
            }

            
            // *** SECOND check if required form header fields and form item fields have a value, if not throw an exception
            checkIfFormFieldsHaveValue();
            

            // *** THIRD check if certain values are valid, if not throw an exception
            if (jhaItem2.Hazard_Type_Assessment__c == 'Yes') {
                // user selected 'Yes' for item - "Asbestos, mold, chemical exposure, etc"
                throw new SubmitException('You selected "Yes" for item, "Asbestos, mold, chemical exposure, etc".  Work cannot continue until this is resolved!  Form will not be saved!');
            }
            
            if ((jhaItem26.Hazard_Type_Assessment__c == 'No') && (jhaItem25.Hazard_Type_Assessment__c == 'No')) {
                // user selected 'No' for both items - "Energy sources can be locked/tagged out" and "Electrical components are guarded with at least 3' clearance"
                throw new SubmitException('You selected "No" for items, "Energy sources can be locked/tagged out" and "Electrical components are guarded with at least 3ft clearance".  Work cannot continue until this is resolved!  Form will not be saved!');
            }
            
            integer rate;
        	if (!((String.isBlank(jhaItem27.Hazard_Type_Assessment_Rate__c)) || (jhaItem27.Hazard_Type_Assessment_Rate__c == '--None--'))) {
        		rate = integer.valueOf(jhaItem27.Hazard_Type_Assessment_Rate__c);
                if (rate > 2) {
                	// user selected a rate > 2 for item - "Electrical hazard category rate for location"
                	throw new SubmitException('You selected a rate > 2 for item, "Electrical hazard category rate for location".  Work cannot continue until this is resolved!  Form will not be saved!');
            	}
        	}
            
            if ((jhaItem28.Hazard_Type_Assessment__c == 'Yes') && (jhaItem25.Hazard_Type_Assessment__c == 'No')) {
                // user selected 'Yes' for item - "Electrical voltage exceeds 600V" and 'No' for item - "Energy sources can be locked/tagged out"
                throw new SubmitException('You selected "Yes" for item, "Electrical voltage exceeds 600V" and "No" for item, "Energy sources can be locked/tagged out".  Work cannot continue until this is resolved!  Form will not be saved!');
            }
            
            
            // *** Check if we need to add a new Address record and update JHA Form record jobsite address reference to it
            if (jhaForm.Jobsite_Address__c == null) {
                System.debug('Inserting address object ' + addr.Id);
                insert addr;
                System.debug('Contents of addr object: ' + addr.Id + ':' + addr.Address_Line_1__c + ':' + addr.Address_Line_2__c + ':' + addr.City__c + ':' + addr.Country__c + ':' + addr.State_Province__c + ':' + addr.Postal_Code__c);
                jhaForm.Jobsite_Address__c = addr.Id;
            }
            
            // *** Check if the user exists in the Contact list and add it if it is not
            Id contactId = checkIfContactExists();
            
            System.debug('loadExistingForm = ' + loadExistingForm);
            
            // Save a copy of the form
            JHA_Form__c jhaFormTemp;
            JHA_Item__c[] jhaItemListTemp = new JHA_Item__c[JHA_ITEM_COUNT];
            
            jhaFormTemp = new JHA_Form__c();
            jhaFormTemp.Customer_Name__c = jhaForm.Customer_Name__c;
            jhaFormTemp.Jobsite_Address__c = jhaForm.Jobsite_Address__c;
            jhaFormTemp.Facility_Type__c = jhaForm.Facility_Type__c;
            jhaFormTemp.Date__c = jhaForm.Date__c;
            jhaFormTemp.Employee__c = jhaForm.Employee__c;
            jhaFormTemp.Evaluation_Type__c = jhaForm.Evaluation_Type__c;
            jhaFormTemp.Special_Comments__c = jhaForm.Special_Comments__c;
            jhaFormTemp.Login_Contact__c = contactId;
            
            System.debug('Contents of jhaFormTemp object: ' + jhaFormTemp.Customer_Name__c + ':' + jhaFormTemp.Jobsite_Address__c + ':' + jhaFormTemp.Facility_Type__c + ':' + jhaFormTemp.Date__c + ':' + jhaFormTemp.Employee__c + ':' + jhaFormTemp.Evaluation_Type__c + ':' + jhaFormTemp.Special_Comments__c);
            
            System.debug('Inserting jhaFormTemp');
            insert jhaFormTemp;
            
            for (Integer i = 0; i < JHA_ITEM_COUNT; i++) {
                jhaItemListTemp[i] = new JHA_Item__c();
                jhaItemListTemp[i].JHA_Form__c = jhaFormTemp.Id;
                jhaItemListTemp[i].Hazard_Type__c = jhaItemList[i].Hazard_Type__c;
                jhaItemListTemp[i].Hazard_Type_Assessment__c = jhaItemList[i].Hazard_Type_Assessment__c;
                jhaItemListTemp[i].Hazard_Type_Assessment_Rate__c = jhaItemList[i].Hazard_Type_Assessment_Rate__c;
                //jhaItemListTemp[i].Affected_Area__c = jhaItemList[i].Affected_Area__c;
                //jhaItemListTemp[i].PPE_ID__c = jhaItemList[i].PPE_ID__c;
                jhaItemListTemp[i].Hazard_Description__c = jhaItemList[i].Hazard_Description__c;
            }
            
            jhaItemListTemp[2].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues2); jhaItemListTemp[2].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues2);
            jhaItemListTemp[3].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues3); jhaItemListTemp[3].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues3);
            jhaItemListTemp[4].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues4); jhaItemListTemp[4].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues4);
            jhaItemListTemp[6].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues6); jhaItemListTemp[6].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues6);
            jhaItemListTemp[11].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues11); jhaItemListTemp[11].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues11);
            jhaItemListTemp[12].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues12); jhaItemListTemp[12].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues12);
            jhaItemListTemp[13].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues13); jhaItemListTemp[13].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues13);
            jhaItemListTemp[14].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues14); jhaItemListTemp[14].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues14);
            jhaItemListTemp[15].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues15); jhaItemListTemp[15].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues15);
            jhaItemListTemp[16].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues16);
            jhaItemListTemp[17].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues17); jhaItemListTemp[17].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues17);
            jhaItemListTemp[18].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues18);
            jhaItemListTemp[25].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues25); jhaItemListTemp[25].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues25);
            jhaItemListTemp[29].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues29); jhaItemListTemp[29].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues29);
            jhaItemListTemp[34].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues34); jhaItemListTemp[34].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues34);
            jhaItemListTemp[36].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues36); jhaItemListTemp[36].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues36);
            jhaItemListTemp[37].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues37); jhaItemListTemp[37].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues37);
            jhaItemListTemp[38].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues38); jhaItemListTemp[38].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues38);
            jhaItemListTemp[39].Affected_Area__c = returnMultiSelectSetAsString(affectedAreaRightValues39); jhaItemListTemp[39].PPE_ID__c = returnMultiSelectSetAsString(ppeIdRightValues39);
            
            System.debug('Inserting jhaItemListTemp');
            insert jhaItemListTemp;
            
            /*
            System.debug('Contents of jhaForm object: ' + jhaForm.Customer_Name__c + ':' + jhaForm.Jobsite_Address__c + ':' + jhaForm.Facility_Type__c + ':' + jhaForm.Date__c + ':' + jhaForm.Employee__c + ':' + jhaForm.Evaluation_Type__c + ':' + jhaForm.Special_Comments__c + ':' + jhaForm.Id + ':' + jhaForm.Name);
            System.debug('Contents of jhaItem0: ' + jhaItem0.JHA_Form__c + ':' + jhaItem0.Id + ':' + jhaItem0.Name + ':' + jhaItem0.Affected_Area__c + ':' + jhaItem0.Hazard_Type__c + ':' + jhaItem0.Hazard_Type_Assessment_Rate__c + ':' + jhaItem0.Hazard_Type_Assessment__c + ':' + jhaItem0.PPE_ID__c + ':' + jhaItem0.Hazard_Description__c);
            System.debug('Contents of jhaItemList array record 0: ' + jhaItemList[0].JHA_Form__c + ':' + jhaItemList[0].Id + ':' + jhaItemList[0].Name + ':' + jhaItemList[0].Affected_Area__c + ':' + jhaItemList[0].Hazard_Type__c + ':' + jhaItemList[0].Hazard_Type_Assessment_Rate__c + ':' + jhaItemList[0].Hazard_Type_Assessment__c + ':' + jhaItemList[0].PPE_ID__c + ':' + jhaItemList[0].Hazard_Description__c);
			*/
        }
        catch (SubmitException e) {
            ApexPages.addMessages(e);
            if (disableFlag && loadExistingForm) {
                callfunc = '<script> disableFieldsOnFormLoad(' + (disableFlag && loadExistingForm) + '); </script>';
            }
            else if (disableFlag) {
                addrState = addr.State_Province__c;
                callfunc = '<script> setAddressFieldVisibility(' + disableFlag + '); </script>';
            }
            else {
                callfunc = '<script> setAddressFieldVisibility(false); </script>';
            }
            
            return null;
        }
        catch (System.DMLException e) {
            Database.rollback(sp);
            jhaForm.Id = null;
            addr.Id = null;
            
            //jhaForm = jhaForm.clone(false);  // The false parameter in the clone method makes an exact copy of the object without preserving the Id. So the next time the user attempts to save, the Id is null and the record gets inserted.
            
            ApexPages.addMessages(e);
            return null;
        }
        
        // After save, navigate to confirmation page
        if (forceDotComSite) {formURLName = url2 + '/LaunchForm/FormSaveConfirm';}
        else {formURLName = '/apex/FormSaveConfirm';}
        
        System.Debug('url1=' + url1 + ',  url2=' + url2 + ', url3=' + url3 + ', host=' + host);
        System.debug('Save - formURLName: ' + formURLName);
        PageReference formPage = new PageReference(formURLName);
        formPage.setRedirect(true);
        return formPage;
        //return (new ApexPages.StandardController(jhaForm)).view();
    }
    
    
    public void loadForm(Id id) {
        // Display original employee and date in pagemessages panel then override these fields with current user, date and eval type
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Original Employee: ' + jhaForm.Employee__c));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Original Date: ' + jhaForm.Date__c));
        jhaForm.Employee__c = userLoginName;
        jhaForm.Date__c = System.today();
        jhaForm.Evaluation_Type__c = 'Contract Renewal/Re-evaluation';
        
        callfunc = '<script> disableFieldsOnFormLoad(' + disableFlag + '); </script>';
        
        // Get all the associated JHA Items to display on the form
        jhaItemList = [SELECT Id, Name, Affected_Area__c, Hazard_Description__c, Hazard_Type__c, Hazard_Type_Assessment__c, Hazard_Type_Assessment_Rate__c, JHA_Form__c, PPE_ID__c FROM JHA_Item__c WHERE JHA_Form__c = :id ORDER By Name];
        
        // Set all the jhaItem objects that are accessed on the visualforce page
        jhaItem0 = jhaItemList[0]; jhaItem1 = jhaItemList[1]; jhaItem2 = jhaItemList[2]; jhaItem3 = jhaItemList[3]; jhaItem4 = jhaItemList[4];
        jhaItem5 = jhaItemList[5]; jhaItem6 = jhaItemList[6]; jhaItem7 = jhaItemList[7]; jhaItem8 = jhaItemList[8]; jhaItem9 = jhaItemList[9];
        jhaItem10 = jhaItemList[10]; jhaItem11 = jhaItemList[11]; jhaItem12 = jhaItemList[12]; jhaItem13 = jhaItemList[13]; jhaItem14 = jhaItemList[14];
        jhaItem15 = jhaItemList[15]; jhaItem16 = jhaItemList[16]; jhaItem17 = jhaItemList[17]; jhaItem18 = jhaItemList[18]; jhaItem19 = jhaItemList[19];
        jhaItem20 = jhaItemList[20]; jhaItem21 = jhaItemList[21]; jhaItem22 = jhaItemList[22]; jhaItem23 = jhaItemList[23]; jhaItem24 = jhaItemList[24];
        jhaItem25 = jhaItemList[25]; jhaItem26 = jhaItemList[26]; jhaItem27 = jhaItemList[27]; jhaItem28 = jhaItemList[28]; jhaItem29 = jhaItemList[29];
        jhaItem30 = jhaItemList[30]; jhaItem31 = jhaItemList[31]; jhaItem32 = jhaItemList[32]; jhaItem33 = jhaItemList[33]; jhaItem34 = jhaItemList[34];
        jhaItem35 = jhaItemList[35]; jhaItem36 = jhaItemList[36]; jhaItem37 = jhaItemList[37]; jhaItem38 = jhaItemList[38]; jhaItem39 = jhaItemList[39];
        jhaItem40 = jhaItemList[40];
        
        // Set "Affected Area" multi-select picklist values for each applicable jhaItem
        setMultiSelectPicklistValues(affectedAreaLeftSelected2, affectedAreaRightSelected2, affectedAreaLeftValues2, affectedAreaRightValues2, jhaItem2.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected3, affectedAreaRightSelected3, affectedAreaLeftValues3, affectedAreaRightValues3, jhaItem3.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected4, affectedAreaRightSelected4, affectedAreaLeftValues4, affectedAreaRightValues4, jhaItem4.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected6, affectedAreaRightSelected6, affectedAreaLeftValues6, affectedAreaRightValues6, jhaItem6.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected11, affectedAreaRightSelected11, affectedAreaLeftValues11, affectedAreaRightValues11, jhaItem11.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected12, affectedAreaRightSelected12, affectedAreaLeftValues12, affectedAreaRightValues12, jhaItem12.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected13, affectedAreaRightSelected13, affectedAreaLeftValues13, affectedAreaRightValues13, jhaItem13.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected14, affectedAreaRightSelected14, affectedAreaLeftValues14, affectedAreaRightValues14, jhaItem14.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected15, affectedAreaRightSelected15, affectedAreaLeftValues15, affectedAreaRightValues15, jhaItem15.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected17, affectedAreaRightSelected17, affectedAreaLeftValues17, affectedAreaRightValues17, jhaItem17.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected25, affectedAreaRightSelected25, affectedAreaLeftValues25, affectedAreaRightValues25, jhaItem25.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected29, affectedAreaRightSelected29, affectedAreaLeftValues29, affectedAreaRightValues29, jhaItem29.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected34, affectedAreaRightSelected34, affectedAreaLeftValues34, affectedAreaRightValues34, jhaItem34.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected36, affectedAreaRightSelected36, affectedAreaLeftValues36, affectedAreaRightValues36, jhaItem36.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected37, affectedAreaRightSelected37, affectedAreaLeftValues37, affectedAreaRightValues37, jhaItem37.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected38, affectedAreaRightSelected38, affectedAreaLeftValues38, affectedAreaRightValues38, jhaItem38.Affected_Area__c);
        setMultiSelectPicklistValues(affectedAreaLeftSelected39, affectedAreaRightSelected39, affectedAreaLeftValues39, affectedAreaRightValues39, jhaItem39.Affected_Area__c);
        
        // Set "PPE ID" multi-select picklist values for each applicable jhaItem
        setMultiSelectPicklistValues(ppeIdLeftSelected2, ppeIdRightSelected2, ppeIdLeftValues2, ppeIdRightValues2, jhaItem2.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected3, ppeIdRightSelected3, ppeIdLeftValues3, ppeIdRightValues3, jhaItem3.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected4, ppeIdRightSelected4, ppeIdLeftValues4, ppeIdRightValues4, jhaItem4.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected6, ppeIdRightSelected6, ppeIdLeftValues6, ppeIdRightValues6, jhaItem6.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected11, ppeIdRightSelected11, ppeIdLeftValues11, ppeIdRightValues11, jhaItem11.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected12, ppeIdRightSelected12, ppeIdLeftValues12, ppeIdRightValues12, jhaItem12.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected13, ppeIdRightSelected13, ppeIdLeftValues13, ppeIdRightValues13, jhaItem13.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected14, ppeIdRightSelected14, ppeIdLeftValues14, ppeIdRightValues14, jhaItem14.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected15, ppeIdRightSelected15, ppeIdLeftValues15, ppeIdRightValues15, jhaItem15.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected16, ppeIdRightSelected16, ppeIdLeftValues16, ppeIdRightValues16, jhaItem16.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected17, ppeIdRightSelected17, ppeIdLeftValues17, ppeIdRightValues17, jhaItem17.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected18, ppeIdRightSelected18, ppeIdLeftValues18, ppeIdRightValues18, jhaItem18.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected25, ppeIdRightSelected25, ppeIdLeftValues25, ppeIdRightValues25, jhaItem25.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected29, ppeIdRightSelected29, ppeIdLeftValues29, ppeIdRightValues29, jhaItem29.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected34, ppeIdRightSelected34, ppeIdLeftValues34, ppeIdRightValues34, jhaItem34.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected36, ppeIdRightSelected36, ppeIdLeftValues36, ppeIdRightValues36, jhaItem36.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected37, ppeIdRightSelected37, ppeIdLeftValues37, ppeIdRightValues37, jhaItem37.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected38, ppeIdRightSelected38, ppeIdLeftValues38, ppeIdRightValues38, jhaItem38.PPE_ID__c);
        setMultiSelectPicklistValues(ppeIdLeftSelected39, ppeIdRightSelected39, ppeIdLeftValues39, ppeIdRightValues39, jhaItem39.PPE_ID__c);

    }
    
    
    public PageReference retrieveAccountAndAddressFields() {
        Account acctTemp = null;
        Address__c addrTemp = null;
        Account_Address__c acctAddrJunctionObj = null;
        JHA_Form__c jhaFormTemp = null;
        
        try {
            System.debug('retrieveAccountAndAddressFields');
            addrTemp = [SELECT Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c FROM Address__c WHERE id = :jhaForm.Jobsite_Address__c];
            
            if (String.isNotEmpty(addrTemp.Address_Line_1__c))
                jobSiteAddress = addrTemp.Address_Line_1__c;
            if (String.isNotEmpty(addrTemp.Address_Line_2__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_2__c;
            if (String.isNotEmpty(addrTemp.Address_Line_3__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_3__c;
            if (String.isNotEmpty(addrTemp.Address_Line_4__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_4__c;
            if (String.isNotEmpty(addrTemp.City__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.City__c;
            if (String.isNotEmpty(addrTemp.State_Province__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.State_Province__c;
            if (String.isNotEmpty(addrTemp.Postal_Code__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Postal_Code__c;
            
            addr.Address_Line_1__c = addrTemp.Address_Line_1__c;
            addr.Address_Line_2__c = addrTemp.Address_Line_2__c;
            addr.Country__c = addrTemp.Country__c;
            addr.State_Province__c = addrTemp.State_Province__c;
            addr.City__c = addrTemp.City__c;
            addr.Postal_Code__c = addrTemp.Postal_Code__c;
            
            disableFlag = true;
            if (loadExistingForm) {
                addrState = addr.State_Province__c;
            }
            else {
                addrState = null;
            }
            
            
            acctAddrJunctionObj = [SELECT Id, Name, Account__c, Address__c, Active__c, Physical__c FROM Account_Address__c WHERE Address__c = :addrTemp.Id];
            jhaForm.Customer_Name__c = acctAddrJunctionObj.Account__c;
            
            return null;
        }
        catch (QueryException e) {
            String msg = null;
            
            if (addrTemp == null) {
                jhaForm.Customer_Name__c = null;
                jhaForm.Jobsite_Address__c = null;
                jobSiteAddress = null;
                addr.Address_Line_1__c = null;
        		addr.Address_Line_2__c = null;
        		addr.Country__c = null;
        		addr.State_Province__c = null;
        		addr.City__c = null;
        		addr.Postal_Code__c = null;
                disableFlag = false;
                addrState = null;
                loadExistingForm = false;
                msg = 'Address not found or invalid!';
            }
            else if (acctAddrJunctionObj == null) {
                jhaForm.Customer_Name__c = null;
                msg = 'No customer account exists for this address!  Please leave blank and proceed with the rest of the form.';
            }
            else {
                msg = e.getMessage();
            }
            ApexPages.Message exMsg = new ApexPages.Message(ApexPages.Severity.INFO, msg);
            ApexPages.addMessage(exMsg);
            
            return null;
        }
        finally {
            // Check if there is an existing form for this jobsite address in the case where the user selected to Create a new form
            // but may not have realized that there is an existing form for this jobsite.  If so, then open the most recent one.
            if ((addrTemp != null) && !loadExistingForm) {
                try {
                    jhaFormTemp = [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c ORDER By CreatedDate DESC LIMIT 1];
                    
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp.Id + '&msg=This jobsite has an existing form!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?id=' + jhaFormTemp.Id + '&msg=This jobsite has an existing form!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                    
                    System.Debug('url1=' + url1 + ',  url2=' + url2 + ', url3=' + url3 + ', host=' + host);
        			System.debug('retrieveAccountAndAddressFields - formURLName: ' + formURLName);
                    
                    PageReference formPage = new PageReference(formURLName);
                    formPage.setRedirect(true);
                    return formPage;
                }
                catch (QueryException e) {
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?addrId=' + jhaForm.Jobsite_Address__c + '&msg=This jobsite has no existing forms!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?addrId=' + jhaForm.Jobsite_Address__c + '&msg=This jobsite has no existing forms!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                    
                    PageReference formPage = new PageReference(formURLName);
                    formPage.setRedirect(true);
                    return formPage;
                }
            }
            else {
                return null;
            }
        }
    }
    
    
    public PageReference retrieveJobSiteAddress() {
        Account acctTemp = null;
        Address__c addrTemp = null;
        JHA_Form__c jhaFormTemp = null;
        
        try {
            System.debug('retrieveJobSiteAddress');
            acctTemp = [SELECT Id, Name, Physical_Address__c FROM Account WHERE Id = :jhaForm.Customer_Name__c];
            addrTemp = [SELECT Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, Address_Name__c, Postal_Code__c, City__c, Country__c, State_Province__c FROM Address__c WHERE Id = :acctTemp.physical_address__c];
            
            if (String.isNotEmpty(addrTemp.Address_Line_1__c))
                jobSiteAddress = addrTemp.Address_Line_1__c;
            if (String.isNotEmpty(addrTemp.Address_Line_2__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_2__c;
            if (String.isNotEmpty(addrTemp.Address_Line_3__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_3__c;
            if (String.isNotEmpty(addrTemp.Address_Line_4__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Address_Line_4__c;
            if (String.isNotEmpty(addrTemp.City__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.City__c;
            if (String.isNotEmpty(addrTemp.State_Province__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.State_Province__c;
            if (String.isNotEmpty(addrTemp.Postal_Code__c))
                jobSiteAddress = jobSiteAddress + ' ' + addrTemp.Postal_Code__c;
                
            
            jhaForm.Jobsite_Address__c = acctTemp.physical_address__c;
            
            addr.Address_Line_1__c = addrTemp.Address_Line_1__c;
            addr.Address_Line_2__c = addrTemp.Address_Line_2__c;
            addr.Country__c = addrTemp.Country__c;
            addr.State_Province__c = addrTemp.State_Province__c;
            addr.City__c = addrTemp.City__c;
            addr.Postal_Code__c = addrTemp.Postal_Code__c;
            
            disableFlag = true;
            if (loadExistingForm) {
                addrState = addr.State_Province__c;
            }
            else {
                addrState = null;
            }
            
            return null;
        }
        catch (QueryException e) {
            String msg = null;
            
            jhaForm.Jobsite_Address__c = null;
            jobSiteAddress = null;
            addr.Address_Line_1__c = null;
            addr.Address_Line_2__c = null;
            addr.Country__c = null;
            addr.State_Province__c = null;
            addr.City__c = null;
            addr.Postal_Code__c = null;
            disableFlag = false;
            addrState = null;
            loadExistingForm = false;
            
            if (acctTemp == null) {
                jhaForm.Customer_Name__c = null;
                msg = 'Customer Name not found or invalid!';
            }
            else if (addrTemp == null) {
                msg = 'No address exists for this account!  Please add address information on the form.';
            }
            else {
                msg = e.getMessage();
            }
            ApexPages.Message exMsg = new ApexPages.Message(ApexPages.Severity.INFO, msg);
            ApexPages.addMessage(exMsg);
            
            return null;
        }
        finally {
            // Check if there is an existing form for this jobsite address in the case where the user selected to Create a new form
            // but may not have realized that there is an existing form for this jobsite.  If so, then open the most recent one.
            if ((addrTemp != null) && !loadExistingForm) {
                try {
                    jhaFormTemp = [SELECT Id, Name, Customer_Name__c, Date__c, Employee__c, Evaluation_Type__c, Facility_Type__c, Jobsite_Address__c, Special_Comments__c FROM JHA_Form__c WHERE Jobsite_Address__c = :jhaForm.Jobsite_Address__c ORDER By CreatedDate DESC LIMIT 1];
                    
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?id=' + jhaFormTemp.Id + '&msg=This jobsite has an existing form!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?id=' + jhaFormTemp.Id + '&msg=This jobsite has an existing form!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                    
                    PageReference formPage = new PageReference(formURLName);
                    formPage.setRedirect(true);
                    return formPage;
                }
                catch (QueryException e) {
                    if (forceDotComSite) {formURLName = url2 + '/LaunchForm/JHA_Form?addrId=' + jhaForm.Jobsite_Address__c + '&msg=This jobsite has no existing forms!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                	else {formURLName = '/apex/JHA_Form?addrId=' + jhaForm.Jobsite_Address__c + '&msg=This jobsite has no existing forms!' + '&epriseLoginId=' + epriseLoginId + '&email=' + email + '&firstName=' + firstName + '&lastName=' + lastName;}
                    
                    PageReference formPage = new PageReference(formURLName);
                    formPage.setRedirect(true);
                    return formPage;
                }
            }
            else {
                return null;
            }
        }
    }
    
    
    private void setMultiSelectPicklistValues(List<string> leftSelected, List<string> rightSelected, Set<string> leftValues, Set<string> rightValues, string pickListValues) {
        if (String.isNotBlank(pickListValues)) {
            leftSelected.clear();
            rightSelected.clear();
            rightValues.clear();
            List<string> pickListValuesParts = pickListValues.split(';');
            for(String s : pickListValuesParts) {
                leftValues.remove(s);
                rightValues.add(s);
            }
        }
    }
    
    
    private string returnMultiSelectSetAsString(Set<string> s_set) {
        string s_val = null;
        integer i=0;
        List<string> tempList = new List<String>();
        tempList.addAll(s_set);
        tempList.sort();

        for(String s : tempList) {
            if (i == 0) {
                s_val = s;
            }
            else {
                s_val = s_val + ';' + s;
            }
            i++;
        }

        return s_val;
    }
    
    
    // called from action function
    public void checkIfHTA2ValuePickedIsYes() {
        if (jhaItem2.Hazard_Type_Assessment__c == 'Yes') {
        //if (hazardTypeAssessment2 == 'Yes') {
            hta2ReturnValueYes = true;
        }
        else {
            hta2ReturnValueYes = false;
        }
    }
        
    // called from action function
    public void checkIfHTA26and25ValuesPickedAreNo() {
        if ((jhaItem26.Hazard_Type_Assessment__c == 'No') && (jhaItem25.Hazard_Type_Assessment__c == 'No')) {
        //if ((hazardTypeAssessment26 == 'No') && (hazardTypeAssessment25 == 'No')) {
            hta26and25ReturnValuesAreNo = true;
        }
        else {
            hta26and25ReturnValuesAreNo = false;
        }
    }
    
    // called from action function
    public void checkIfRatePickedIsGT2() {
        integer rate;
        if ((String.isBlank(jhaItem27.Hazard_Type_Assessment_Rate__c)) || (jhaItem27.Hazard_Type_Assessment_Rate__c == '--None--')) {
        //if (hazardTypeAssessment27 == '--None--') {
            htaReturnValueRateGT2 = false;
        }
        else {
            rate = integer.valueOf(jhaItem27.Hazard_Type_Assessment_Rate__c);
            //rate = integer.valueOf(hazardTypeAssessment27);
            if (rate > 2) {
                htaReturnValueRateGT2 = true;
            }
            else {
                htaReturnValueRateGT2 = false;
            }
        }
    }
    
    // called from action function
    public void checkIfHTA28ValuePickedIsYesAndHTA25No() {
        if ((jhaItem28.Hazard_Type_Assessment__c == 'Yes') && (jhaItem25.Hazard_Type_Assessment__c == 'No')) {
        //if ((hazardTypeAssessment28 == 'Yes') && (hazardTypeAssessment25 == 'No')) {
            hta28ReturnValueYesAndHta25No = true;
        }
        else {
            hta28ReturnValueYesAndHta25No = false;
        }
    }
    
    
    private void checkIfFormFieldsHaveValue() {
        if (jhaForm.Date__c == null) {
                jhaForm.Date__c.addError('Required');
                throw new SubmitException('Date field not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaForm.Evaluation_Type__c)) || (jhaForm.Evaluation_Type__c == '--None--')) {
                jhaForm.Evaluation_Type__c.addError('Required');
                throw new SubmitException('Evaluation Type field not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaForm.Facility_Type__c)) || (jhaForm.Facility_Type__c == '--None--')) {
                jhaForm.Facility_Type__c.addError('Required');
                throw new SubmitException('Facility Type field not set. Form will not be saved!');
        }
                                               
        if ((String.isBlank(jhaItem0.Hazard_Type_Assessment__c)) || (jhaItem0.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem0.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Customer has site specific safety plan" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem1.Hazard_Type_Assessment__c)) || (jhaItem1.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem1.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "High crime area; potential for harm" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem2.Hazard_Type_Assessment__c)) || (jhaItem2.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem2.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Asbestos, mold, chemical exposure, etc" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem3.Hazard_Type_Assessment__c)) || (jhaItem3.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem3.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Airborne debris, soot, dust, etc" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem4.Hazard_Type_Assessment__c)) || (jhaItem4.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem4.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Potential for larger airborne objects (i.e., chips, weld splatter)" not set. Form will not be saved!');
        }
		
        if ((String.isBlank(jhaItem5.Hazard_Type_Assessment__c)) || (jhaItem5.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem5.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Area hot/cold (not weather related)" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem6.Hazard_Type_Assessment__c)) || (jhaItem6.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem6.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Area wet or slippery" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem7.Hazard_Type_Assessment__c)) || (jhaItem7.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem7.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Crowded public area" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem8.Hazard_Type_Assessment__c)) || (jhaItem8.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem8.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "High vehicular traffic, cranes, forklifts, etc" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem9.Hazard_Type_Assessment__c)) || (jhaItem9.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem9.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Poor or no lighting" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem10.Hazard_Type_Assessment__c)) || (jhaItem10.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem10.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Excessively bright light or radiation exposure" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem11.Hazard_Type_Assessment__c)) || (jhaItem11.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem11.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "High noise area" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem12.Hazard_Type_Assessment__c)) || (jhaItem12.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem12.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Exposure to flammable liquids or gases" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem13.Hazard_Type_Assessment__c)) || (jhaItem13.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem13.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Potential for poisonous animals" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem14.Hazard_Type_Assessment__c)) || (jhaItem14.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem14.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Slip, trip and fall hazards" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem15.Hazard_Type_Assessment__c)) || (jhaItem15.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem15.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Potential for blood borne pathogens" not set. Form will not be saved!');
        }
        
        if ((String.isBlank(jhaItem16.Hazard_Type_Assessment__c)) || (jhaItem16.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem16.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Leading edge work/fall hazard/no guard rails" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem17.Hazard_Type_Assessment__c)) || (jhaItem17.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem17.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Walking/working surface unsafe" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem18.Hazard_Type_Assessment__c)) || (jhaItem18.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem18.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Excessive height to work area" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem19.Hazard_Type_Assessment__c)) || (jhaItem19.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem19.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Restricted physical access" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem20.Hazard_Type_Assessment__c)) || (jhaItem20.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem20.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Work area is a confined space" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem21.Hazard_Type_Assessment__c)) || (jhaItem21.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem21.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Are installed ladders/stairs safe and secure" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem22.Hazard_Type_Assessment__c)) || (jhaItem22.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem22.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Skylights are guarded/protected from fall through" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem23.Hazard_Type_Assessment__c)) || (jhaItem23.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem23.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Roof structure is safe/adequate for load bearing" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem24.Hazard_Type_Assessment__c)) || (jhaItem24.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem24.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Energy sources are identified" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem25.Hazard_Type_Assessment__c)) || (jhaItem25.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem25.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Energy sources can be locked/tagged out" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem26.Hazard_Type_Assessment__c)) || (jhaItem26.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem26.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Electrical components are guarded with at least 3ft clearance" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem27.Hazard_Type_Assessment_Rate__c)) || (jhaItem27.Hazard_Type_Assessment_Rate__c == '--None--')) {
                jhaItem27.Hazard_Type_Assessment_Rate__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Electrical hazard category rate for location" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem28.Hazard_Type_Assessment__c)) || (jhaItem28.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem28.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Electrical voltage exceeds 600V" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem29.Hazard_Type_Assessment__c)) || (jhaItem29.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem29.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Is there a potential for electrical arc" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem30.Hazard_Type_Assessment__c)) || (jhaItem30.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem30.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Only one exit route available" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem31.Hazard_Type_Assessment__c)) || (jhaItem31.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem31.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Fire extinguishers available" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem32.Hazard_Type_Assessment__c)) || (jhaItem32.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem32.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Customer is aware that you are on-site" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem33.Hazard_Type_Assessment__c)) || (jhaItem33.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem33.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "No cell phone coverage/signal in work area or site" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem34.Hazard_Type_Assessment__c)) || (jhaItem34.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem34.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Moving parts are guarded" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem35.Hazard_Type_Assessment__c)) || (jhaItem35.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem35.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Equipment anchored or secured" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem36.Hazard_Type_Assessment__c)) || (jhaItem36.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem36.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Sharp edges/points that could cause a puncture/laceration" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem37.Hazard_Type_Assessment__c)) || (jhaItem37.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem37.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Rough surfaces that could cause abrasions" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem38.Hazard_Type_Assessment__c)) || (jhaItem38.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem38.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Work area or equipment has low/no clearance" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem39.Hazard_Type_Assessment__c)) || (jhaItem39.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem39.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Work area has overhead hazards" not set. Form will not be saved!');
        }

        if ((String.isBlank(jhaItem40.Hazard_Type_Assessment__c)) || (jhaItem40.Hazard_Type_Assessment__c == '--None--')) {
                jhaItem40.Hazard_Type_Assessment__c.addError('Required');
                throw new SubmitException('Hazard Type Assessment field, "Special permits required (hot work, confined space, etc)" not set. Form will not be saved!');
        }
    }


    @TestVisible private Id checkIfContactExists() {
        // Check if the eprise login id exists in the Contact table, if not then add it. Return contact id.
        Contact contactTemp = null;
        RecordType recordTypeTemp = null;
        Account acctTemp = null;
        Id contactId = null;
        
        try {
            if (String.isNotBlank(epriseLoginId) && epriseLoginId != 'null') {
                contactTemp = [SELECT Id FROM Contact WHERE Eprise_Login_ID__c = :epriseLoginId];
                contactId = contactTemp.Id;
            }
        }
        catch (QueryException e) {
            if (contactTemp == null) {
                // Contact record does not exist so add it.
                // Required fields when adding a Contact record:
                // AccountId = lookup reference to the 'Daikin Applied Americas Corporate' account
                // RecordTypeId = lookup reference to a RecordType where Name="Daikin Applied" and SObjectType="Contact"
                // Email
                // Name = contains Salutation, FirstName and LastName
                // Status__c = "Active"
                // Eprise_Login_ID__c

                System.debug('Contact not found');
                recordTypeTemp = [SELECT Id FROM RecordType WHERE Name='Daikin Applied' AND SObjectType='Contact'];
                acctTemp = [SELECT Id FROM Account WHERE Name = 'Daikin Applied Americas Corporate' AND Type != ''];
                contactTemp = new Contact();
                contactTemp.Eprise_Login_ID__c = epriseLoginId;
                contactTemp.RecordTypeId = recordTypeTemp.Id;
                contactTemp.AccountId = acctTemp.Id;
                contactTemp.Status__c = 'Active';
                contactTemp.Email = email;
                contactTemp.FirstName = firstName;
                contactTemp.LastName = lastName;
                insert contactTemp;
                contactId = contactTemp.Id;
                System.debug('Insert Contact');
            }
        }
        return contactId;
    }
    
}
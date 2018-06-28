public without sharing class ExamReportsController 
{
    public string examTypeId{get;set;}
    public string examMonthId{get;set;}
    public string examYearId{get;set;}
    public string reportTypeId {get;set;}    
    
    public Boolean disableExamYear {get;set;}   
    public Boolean disableExamMonth {get;set;}   
    public Boolean disableExamType {get;set;}
    
    public Boolean includeUnPaid {get;set;}   
    
    public ExamReportsController ()
    {
    	includeUnPaid=true;
        selectType();
    }
    
    public void selectType() {
        if(reportTypeId == 'Exam Regitrations By Day Of Year' || reportTypeId == 'Exam Regitrations By Type By Year') {
            disableExamYear=true;
        } else if(reportTypeId == 'ERP Exam Regitrations By Year' || reportTypeId == 'FRM Exam Regitrations By Year') {
            disableExamYear=true;
            disableExamMonth=true;
            disableExamType=true;
        } else  {
			disableExamYear=false;
            disableExamMonth=false;
            disableExamType=false;
        }
    }
    
    public PageReference goReport() {
        PageReference gourl;
        
        String allOrders = 'New Lead,Closed Won,Closed, Closed Lost';
        String paidOrders = 'Closed Won, Closed';
        String passOrderType;
        
        Map<String,String> abbrevMap = new Map<String,String>();
        abbrevMap.put('ERP','ERP');
        abbrevMap.put('FRM I','FRM Part 1');
        abbrevMap.put('FRM II','FRM Part 2');
        abbrevMap.put('May','May');
        abbrevMap.put('November','Nov');
        
        
        if(includeUnPaid)
            passOrderType = allOrders;
        else passOrderType = paidOrders;
        
        if(reportTypeId == 'Exam Regitrations By Country')
            gourl = new PageReference('/00O400000048zEv?pv0=' + abbrevMap.get(examMonthId) + ' ' + examYearId + ' ' + abbrevMap.get(examTypeId) + '&pv1=' + passOrderType);
        else if(reportTypeId == 'Exam Attendance By Country')
            gourl = new PageReference('/00O400000048zF0?pv0=' + abbrevMap.get(examMonthId) + ' ' + examYearId + ' ' + abbrevMap.get(examTypeId) + '&pv1=' + passOrderType);
        else if(reportTypeId == 'Exam Regitrations By Day Of Year')
            gourl = new PageReference('/00O400000048zFP?pv0=' + abbrevMap.get(examMonthId) + '&pv1=' + abbrevMap.get(examTypeId) + '&pv2=' + passOrderType);
        else if(reportTypeId == 'Exam Regitrations By Type By Year')
            gourl = new PageReference('/00O400000048zVS?pv0=' + abbrevMap.get(examMonthId) + '&pv1=' + abbrevMap.get(examTypeId) + '&pv2=' + passOrderType);
        else if(reportTypeId == 'ERP Exam Regitrations By Year')
            gourl = new PageReference('/00O400000048zUA?&pv1=' + passOrderType);
        else if(reportTypeId == 'FRM Exam Regitrations By Year')
            gourl = new PageReference('/00O400000048zVN?&pv1=' + passOrderType);
            
        return gourl;
    }

    public List<SelectOption> ReportTypeList
    {
        get
        {            
            ReportTypeList= new List<SelectOption>();

            ReportTypeList.add(new SelectOption('Exam Regitrations By Country', 'Exam Regitrations By Country'));
            ReportTypeList.add(new SelectOption('Exam Attendance By Country', 'Exam Attendance By Country'));
            ReportTypeList.add(new SelectOption('Exam Regitrations By Day Of Year', 'Exam Regitrations By Day Of Year'));
            ReportTypeList.add(new SelectOption('Exam Regitrations By Type By Year', 'Exam Regitrations By Type By Year'));
            ReportTypeList.add(new SelectOption('ERP Exam Regitrations By Year', 'ERP Exam Regitrations By Year'));
            ReportTypeList.add(new SelectOption('FRM Exam Regitrations By Year', 'FRM Exam Regitrations By Year'));

            return ReportTypeList;
        }
        set;
    }

    
    public List<SelectOption> ExamTypeList
    {
        get
        {
            ExamTypeList= new List<SelectOption>();

            ExamTypeList.add(new SelectOption('ERP', 'ERP'));                    
            ExamTypeList.add(new SelectOption('FRM I', 'FRM I'));                    
            ExamTypeList.add(new SelectOption('FRM II', 'FRM II'));                    

            return ExamTypeList;
        }
        set;
    }

    public List<SelectOption> ExamMonthList
    {
        get
        {            
            ExamMonthList= new List<SelectOption>();
            ExamMonthList.add(new SelectOption('May', 'May')); 
            ExamMonthList.add(new SelectOption('November', 'November'));
            
            return ExamMonthList;
        }
        set;
    }

    public List<SelectOption> ExamYearList
    {
        get
        {
            ExamYearList= new List<SelectOption>();
            
            Integer Cnt = 2010;
            
            while(Cnt <= 2015)
            {
                 ExamYearList.add(new SelectOption(String.ValueOf(Cnt), String.ValueOf(Cnt)));                    
                 Cnt++;
            }            

            return ExamYearList;
        }
        set;
    }

    
}
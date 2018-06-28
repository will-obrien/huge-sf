public class gantt_controller {
    public String task_data{set;get;}
    private Map<String,Id> serial_to_id;
    private Id project_id;
    private String project_name;
    
    public String currently_selected_task{get;set;}
    public String new_start_date{get;set;}
    public String new_end_date{get;set;}
    public String changed_task{get;set;}
    
    public gantt_controller(ApexPages.StandardController sc){
        serial_to_id = new Map<String,Id>();
        currently_selected_task = '1';
        project_id = sc.getId();
        changed_task = '';
        
       getdata();
        
        System.debug('HEADERS MAP: ' + ApexPages.currentPage().getHeaders());
        System.debug('CURRENT PAGE: ' + ApexPages.currentPage().getUrl());
    }

    public void getdata(){
                                
        String gantt_styles = xmlConfiguration.xml_style_header;                                
        
        String gantt_task_header = xmlConfiguration.xml_task_header;
        String gantt_task_body = xmlConfiguration.xml_task_body;
        String gantt_task_footer = xmlConfiguration.xml_task_footer;
        
        String gantt_connector_header = xmlConfiguration.xml_connector_header;
        String gantt_connector_body = xmlConfiguration.xml_connector_body;
        String gantt_connector_footer = xmlConfiguration.xml_connector_footer;
        
        //String xml_header = '<anygantt>' + gantt_styles.XML_Header__c;
        String xml_header = '<anygantt>' + gantt_styles;
        String xml_task = gantt_task_body;
        
        task_data = xml_header + gantt_task_header;
        
        
        Project__c project = [SELECT Id, Stop_Date__c, Start_Date__c, Name, Percent_Complete__c
                                            FROM Project__c
                                            WHERE Id = :project_id][0];
        
        
        
        task_data = task_data + xml_task;

        serial_to_id.put('1',project.Id);
        task_data = task_data.replace('[task_id]', '1');
        task_data = task_data.replace('[name]', project.Name);
        task_data = task_data.replace('\'', '_');
        project_name = project.Name;
        task_data = task_data.replace('[parent]', '');
        if(project.Percent_Complete__c == null){
            task_data = task_data.replace('[progress]', '0');
        }else{
            task_data = task_data.replace('[progress]', String.valueOf(project.Percent_Complete__c));
        }
        Date start_date = Date.valueOf(project.Start_Date__c);
        task_data = task_data.replace('[start_date]', String.valueOf(start_date.year()) + '.' + String.valueOf(start_date.month()) + '.' + String.valueOf(start_date.day()) + ' 0.0');
        Date end_date = Date.valueOf(project.Stop_Date__c);
        task_data = task_data.replace('[end_date]', String.valueOf(end_date.year()) + '.' + String.valueOf(end_date.month()) + '.' + String.valueOf(end_date.day()) + ' 1.0');
        
        List<Project_Task__c> proj_tasks = [SELECT Id, Start_Date__c, Project__c, Percent_Complete__c, Name__c, Name, Due_Date__c, Preceeding_Task__c
                                                                FROM Project_Task__c
                                                                WHERE Project__c = :project_id AND Parent_Task__c = null
                                                                ORDER BY Start_Date__c];
        System.debug('PROJECT TASKS: ' + proj_tasks);
        List<Project_Task__c> sub_tasks = null;
        if(proj_tasks.size() > 0){
            
            Integer counter = 2;
            List<connector> list_connectors = new List<connector>();
            
            sub_tasks = [SELECT Id, Start_Date__c, Parent_Task__c, Project__c, Percent_Complete__c, Name__c, Due_Date__c, Preceeding_Task__c
                                                                FROM Project_Task__c
                                                                WHERE Project__c = :project_id AND Parent_Task__c != null
                                                                ORDER BY Start_Date__c];
                                                                
            for(Project_Task__c task : proj_tasks){
                task_data = task_data + xml_task;
                serial_to_id.put(String.valueOf(counter),task.Id);
                task_data = task_data.replace('[task_id]', String.valueOf(counter));
                System.debug('TASK NAME: ' + task.Name__c);
                task_data = task_data.replace('[name]', task.Name__c);
                task_data = task_data.replace('\'', '_');
                task_data = task_data.replace('[parent]', '1');
                if(task.Percent_Complete__c == null){
                    task_data = task_data.replace('[progress]', '0');
                }else{
                    task_data = task_data.replace('[progress]', String.valueOf(task.Percent_Complete__c));
                }
                if(task.Start_Date__c == null){
                    Date task_start_date = Date.valueOf(project.Start_Date__c);
                    task_data = task_data.replace('[start_date]', String.valueOf(task_start_date.year()) + '.' + String.valueOf(task_start_date.month()) + '.' + String.valueOf(task_start_date.day()) + ' 0.0');
                }else{
                    Date task_start_date = Date.valueOf(task.Start_Date__c);
                    task_data = task_data.replace('[start_date]', String.valueOf(task_start_date.year()) + '.' + String.valueOf(task_start_date.month()) + '.' + String.valueOf(task_start_date.day()) + ' 0.0');
                }
                if(task.Due_Date__c == null){
                    Date task_end_date = Date.valueOf(project.Stop_Date__c);
                    if(String.valueOf(task.Name__c).contains('Milestone')){
                        task_data = task_data.replace('actual_end="[end_date]', 'actual_end1="' + String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                    }else{
                        task_data = task_data.replace('[end_date]', String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                    }
                }else{
                    Date task_end_date = Date.valueOf(task.Due_Date__c);
                    if(String.valueOf(task.Name__c).contains('Milestone')){
                        task_data = task_data.replace('actual_end="[end_date]', 'actual_end1="' + String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                    }else{
                        task_data = task_data.replace('[end_date]', String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                    }
                }
                
                Integer parent_task_id = counter;
                counter++;
                for(Project_Task__c sub_task : sub_tasks){
                    if(sub_task.Parent_Task__c != task.Id){
                        continue;
                    }
                    task_data = task_data + xml_task;
                    serial_to_id.put(String.valueOf(counter),sub_task.Id);
                    task_data = task_data.replace('[task_id]', String.valueOf(counter));
                    task_data = task_data.replace('[name]', sub_task.Name__c);
                    task_data = task_data.replace('\'', '_');
                    task_data = task_data.replace('[parent]', String.valueOf(parent_task_id));
                    if(sub_task.Percent_Complete__c == null){
                        task_data = task_data.replace('[progress]', '0');
                    }else{
                        task_data = task_data.replace('[progress]', String.valueOf(sub_task.Percent_Complete__c));
                    }
                    if(sub_task.Start_Date__c == null){
                        Date task_start_date = Date.valueOf(project.Start_Date__c);
                        task_data = task_data.replace('[start_date]', String.valueOf(task_start_date.year()) + '.' + String.valueOf(task_start_date.month()) + '.' + String.valueOf(task_start_date.day()) + ' 0.0');
                    }else{
                        Date task_start_date = Date.valueOf(sub_task.Start_Date__c);
                        task_data = task_data.replace('[start_date]', String.valueOf(task_start_date.year()) + '.' + String.valueOf(task_start_date.month()) + '.' + String.valueOf(task_start_date.day()) + ' 0.0');
                    }
                    if(sub_task.Due_Date__c == null){
                        Date task_end_date = Date.valueOf(project.Stop_Date__c);
                        if(String.valueOf(task.Name__c).contains('Milestone')){
                            task_data = task_data.replace('actual_end="[end_date]', 'actual_end1="' + String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                        }else{
                            task_data = task_data.replace('[end_date]', String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                        }
                    }else{
                        Date task_end_date = Date.valueOf(sub_task.Due_Date__c);
                        if(String.valueOf(task.Name__c).contains('Milestone')){
                            task_data = task_data.replace('actual_end="[end_date]', 'actual_end1="' + String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                        }else{
                            task_data = task_data.replace('[end_date]', String.valueOf(task_end_date.year()) + '.' + String.valueOf(task_end_date.month()) + '.' + String.valueOf(task_end_date.day()) + ' 1.0');
                        }
                    }
                    counter++;
                }
            }
        }
        //task_data = task_data + '<task id="50" name="Test milestone" parent="1" progress="10" actual_start="2009.12.02 0.0" actual_end1="2009.12.02 1.0"/>';
        task_data = task_data + gantt_task_footer + gantt_connector_header;
        
        List<connector> list_connectors = new List<connector>();
        
        for(String key : serial_to_id.keySet()){
            if(key != '1'){
                //List<Project_Task__c> task_list = [SELECT Id FROM Project_Task__c WHERE Parent_Task__c = :serial_to_id.get(key)];
                List<Project_Task__c> task_list = new List<Project_Task__c>();
                for(Project_Task__c each_task : sub_tasks){
                    if(each_task.Parent_Task__c == serial_to_id.get(key)){
                        task_list.add(each_task);
                    }
                }
                for(Project_Task__c following_task : task_list){
                    for(String k : serial_to_id.keySet()){
                        if(serial_to_id.get(k) == following_task.Id){
                            connector conn = new connector();
                            conn.from_connector = key;
                            conn.to_connector = k;
                            list_connectors.add(conn);
                        }
                    }
                }
            }
        }
        
        System.debug('CONNECTORS: ' + list_connectors);
        
        for(connector connection : list_connectors){
            task_data = task_data + gantt_connector_body;
            task_data = task_data.replace('[from]', connection.from_connector);
            task_data = task_data.replace('[to]', connection.to_connector);
        }
        
        task_data = task_data + gantt_connector_footer + '</project_chart></anygantt>';
        System.debug('TASK DATA: ' + task_data);
    }
    
    public String getnew_task_link(){
        Id task_recordtype = [SELECT Id FROM RecordType WHERE Name = 'Project Task' AND SObjectType = 'Project_Task__c' LIMIT 1][0].Id;
        //Sandbox
        //String link = '/a0W/e?retURL=%2F' + project_id + '&CF00NQ0000000Zvdk=' + project_name +'&CF00NQ0000000Zvdk_lkid' + project_id + '&RecordType=' + task_recordtype;
        //Production
        String link = '/a0b/e?retURL=%2F' + project_id + '&CF00N80000004Uxcu=' + project_name +'&CF00N80000004Uxcu_lkid' + project_id + '&RecordType=' + task_recordtype;
        return link;
    }
    
    public PageReference new_subtask(){
    	Id task_recordtype = [SELECT Id FROM RecordType WHERE Name = 'Project Task' AND SObjectType = 'Project_Task__c' LIMIT 1][0].Id;
        PageReference p = null;
        if(currently_selected_task != '1'){
            List<Project_Task__c> list_task = [SELECT Id, Name FROM Project_Task__c WHERE Id = :serial_to_id.get(currently_selected_task) LIMIT 1];
            System.debug('SUB TASK PARENT: ' + list_task);
            if(list_task.size() > 0){
                //Sandbox
                //p = new PageReference('/a0W/e?retURL=%2F' + project_id + '&CF00NQ0000000Zvdk=' + project_name +'&CF00NQ0000000Zvdk_lkid=' + project_id + '&CF00NQ0000000ZviW=' + list_task[0].Name + '&CF00NQ0000000ZviW_lkid=' + list_task[0].Id + '&RecordType=' + task_recordtype);
                //Production
                p = new PageReference('/a0b/e?retURL=%2F' + project_id + '&CF00N80000004Uxcu=' + project_name +'&CF00N80000004Uxcu_lkid=' + project_id + '&CF00N80000004Uxfy=' + list_task[0].Name + '&CF00N80000004Uxfy_lkid=' + list_task[0].Id + '&RecordType=' + task_recordtype);
                p.setRedirect(true);
            }
        }else{
            //Sandbox
            //p = new PageReference('/a0W/e?retURL=%2F' + project_id + '&CF00NQ0000000Zvdk=' + project_name +'&CF00NQ0000000Zvdk_lkid=' + project_id + '&RecordType=' + task_recordtype);
            //Production
            p = new PageReference('/a0b/e?retURL=%2F' + project_id + '&CF00N80000004Uxcu=' + project_name +'&CF00N80000004Uxcu_lkid=' + project_id + '&RecordType=' + task_recordtype);
            p.setRedirect(true);
        }
        return p;
    }
    
    public PageReference task_assign(){
    	Id project_team_member_recordtype = [SELECT Id FROM RecordType WHERE Name = 'Project Team Member' AND SObjectType = 'Project_Member__c' LIMIT 1][0].Id;
    	Id task_team_member_recordtype = [SELECT Id FROM RecordType WHERE Name = 'Task Team Member' AND SObjectType = 'Project_Member__c' LIMIT 1][0].Id;
        
        PageReference p = null;
        if(currently_selected_task != '1'){
            Project_Task__c selected_task = [SELECT Id, Name FROM Project_Task__c WHERE Id = :serial_to_id.get(currently_selected_task) LIMIT 1][0];
            //Sandbox
            //p = new PageReference('/a0V/e?CF00NQ0000000ZvhY=' + selected_task.Name +'&CF00NQ0000000ZvhY_lkid=' + selected_task.Id + '&retURL=%2F' + project_id + '&RecordType=' + task_team_member_recordtype);
            //Production
            p = new PageReference('/a0a/e?CF00N80000004UxfS=' + selected_task.Name +'&CF00N80000004UxfS_lkid=' + selected_task.Id + '&retURL=%2F' + project_id + '&RecordType=' + task_team_member_recordtype);
            p.setRedirect(true);
        }else{
            //Sandbox
            //p = new PageReference('/a0V/e?CF00NQ0000000ZvhS=' + project_name +'&CF00NQ0000000ZvhS_lkid=' + project_id + '&retURL=%2F' + project_id + '&RecordType=' + project_team_member_recordtype);
            //Production
            p = new PageReference('/a0a/e?CF00N80000004UxfP=' + project_name +'&CF00N80000004UxfP_lkid=' + project_id + '&retURL=%2F' + project_id + '&RecordType=' + project_team_member_recordtype);
            p.setRedirect(true);
        }
        return p;
    }
    
    public PageReference task_detail(){
        PageReference p = null;
        System.debug('CURRENTLY SELECTED: ' + currently_selected_task);
        System.debug('DETAIL TASK: ' + serial_to_id.get(currently_selected_task));
        List<Project_Task__c> detail_task = [SELECT Id FROM Project_Task__c WHERE Id = :serial_to_id.get(currently_selected_task) LIMIT 1];
        String task_detail_link = '';
        if(detail_task.size() > 0){
            p = new ApexPages.StandardController(detail_task[0]).view();
            p.setRedirect(true);
            
            
        }
        return p;
    }
    
    public PageReference task_edit(){
        PageReference p = null;
        System.debug('CURRENTLY SELECTED: ' + currently_selected_task);
        System.debug('DETAIL TASK: ' + serial_to_id.get(currently_selected_task));
        List<Project_Task__c> detail_task = [SELECT Id FROM Project_Task__c WHERE Id = :serial_to_id.get(currently_selected_task) LIMIT 1];
        String task_detail_link = '';
        if(detail_task.size() > 0){
            p = new PageReference('/' + detail_task[0].Id + '/e?returl=%2F' + project_id);
            p.setRedirect(true);
            
            
        }
        return p;
    }
    
    public PageReference task_delete(){
        System.debug('CURRENTLY SELECTED: ' + currently_selected_task);
        System.debug('TASK TO DELETE: ' + serial_to_id.get(currently_selected_task));
        List<Project_Task__c> task_to_delete = [SELECT Id FROM Project_Task__c WHERE Id = :serial_to_id.get(currently_selected_task) LIMIT 1];
        if(task_to_delete.size() > 0){
            delete task_to_delete[0];
        }
        getdata();
        return null;
    }
    
    public PageReference task_save(){
        changed_task = changed_task.replaceFirst('##', '');
        System.debug('CHANGED TASKS: ' + changed_task);

        Map<String, connector> task_map = new Map<String, connector>();
        
        List<String> split_string = changed_task.split('##');
        System.debug('SPLIT STRING: ' + split_string + ' SIZE: ' + split_string.size());
        
        for(Integer i = 0; i < split_string.size();){
            if(split_string[i].length() <= 2){
                connector conn = new connector();
                conn.from_connector = split_string[i + 1];
                conn.to_connector = split_string[i + 2];
                conn.extra_string = split_string[i + 3];
                task_map.put(split_string[i], conn);
                i = i + 4;
            }
        }
        
        System.debug('TASK MAP: ' + task_map);
        List<Project_Task__c> changed_tasks_list = new List<Project_Task__c>();
        for(String key : task_map.keySet()){
            if(key != '1'){
                Project_Task__c task = new Project_Task__c(Id = serial_to_id.get(key), Percent_Complete__c = Double.valueof(task_map.get(key).extra_string), Start_Date__c = convert_date(task_map.get(key).from_connector), Due_Date__c = convert_date(task_map.get(key).to_connector));
                changed_tasks_list.add(task);
            }
        }
        
        System.debug('TASKS TO UPDATE: ' + changed_tasks_list);
        
        Revisions__c revision = new Revisions__c();
        
        List<Revisions__c> list_revisions = [SELECT Gantt_Data__c, SObject_Id__c, Revision_Name__c, Version__c
                                                    FROM Revisions__c
                                                    WHERE SObject_Id__c = :project_id
                                                    ORDER BY Version__c DESC];
        if(list_revisions.size() > 0){
            revision.Gantt_Data__c = task_data;
            revision.SObject_Id__c = project_id;
            revision.Version__c = list_revisions[0].Version__c + 1;
            revision.Revision_Name__c = project_name + '-' + String.valueof(revision.Version__c);
        }else{
            revision.Gantt_Data__c = task_data;
            revision.SObject_Id__c = project_id;
            revision.Version__c = 1;
            revision.Revision_Name__c = project_name + '-' + String.valueof(revision.Version__c);
        }
        
        insert revision;
        
        Attachment attach = new Attachment();
        attach.body = Blob.valueOf(task_data);
        attach.name = revision.Revision_Name__c + '-data.xml';
        attach.ParentId = revision.Id;
        attach.ContentType = 'text/plain';
        insert attach;
        
        update changed_tasks_list;
        
        getdata();
        changed_task = '';
        
        return null;
    }
    
    public String getview_revisions_link(){
        String link = '/apex/view_revisions?id=' + project_id;
        return link;
    }
    
    private class connector{
        public String from_connector{set;get;}
        public String to_connector{set;get;}
        public String extra_string{set;get;}
    }
    
    private Date convert_date(String date_string){
        String day_of_week = date_string.substring(0,3);
        System.debug('DAY OF WEEK: ' + day_of_week);
        String month = date_string.substring(4,7);
        System.debug('MONTH: ' + month);
        if(month == 'Jan'){
            month = '01';
        }else if(month == 'Feb'){
            month = '02';
        }else if(month == 'Mar'){
            month = '03';
        }else if(month == 'Apr'){
            month = '04';
        }else if(month == 'May'){
            month = '05';
        }else if(month == 'Jun'){
            month = '06';
        }else if(month == 'Jul'){
            month = '07';
        }else if(month == 'Aug'){
            month = '08';
        }else if(month == 'Sep'){
            month = '09';
        }else if(month == 'Oct'){
            month = '10';
        }else if(month == 'Nov'){
            month = '11';
        }else if(month == 'Dec'){
            month = '12';
        }
        System.debug('MONTH: ' + month);
        String day = date_string.substring(8,10);
        System.debug('DAY: ' + day);
        String year = date_string.substring(11,15);
        System.debug('YEAR: ' + year);
        
        return Date.valueof(year + '-' + month + '-' + day + ' 00:00:00');
        
    }
}
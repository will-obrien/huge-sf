public class jqSlider_Con {
      
        public String sSliderField { get; set; }
        public jqSlider_Con(){
          sSliderField ='0';  
        }
        
        public void checkSliderVal(){
             
             System.debug('###-------------+'+sSliderField );
        }
        
        static testMethod void test_jqSlider_con(){
            new jqSlider_Con().checkSliderVal();
        }
 }
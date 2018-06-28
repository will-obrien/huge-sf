<script>

                 //--------------------------------------Function to initiate tab nature-------------------------------------------
                  function initiateTabs(tabWrapper,options){
                    var optionsJson = jQuery.parseJSON(options);
                    if(optionsJson.activeTab != null){
                        $(tabWrapper).children('.tabdiv').hide().eq(optionsJson.activeTab).show();
                    }
                    else{
                        $(tabWrapper).children('.tabdiv').hide().eq(0).show();
                    }
                  };
                  //-------------------------------------Function to check and show errors in discovery tab-------------------------
                  function CheckErrorTabs(){
                    $.each($(".box-wrap").children(".tabdiv"),function(){
                         var parent = $(this);
                        $(this).find(".errorMsg").filter(function(){

                                $(".box-wrap").siblings("ul").find("li[id*="+parent.attr('id')+"]").each(function(){
                                     $(this).addClass("errorTab");
                                //     alert($(this).attr("id"));

                                });
                            });
                    });
                  };
                 //-------------------------------------Function to check and show errors in discovery tab-------------------------
                 //-------------------------------------Function to check length of field on page level/7/3/2014----------------------------
                function TextAreaLengthCheck(areaId,FieldName,validlength){

                        $(areaId).keyup(function () {
                            var maxLength = validlength;
                            var text = $(this).val();
                            var textLength = text.length;
                            if (textLength > maxLength) {
                                $(this).val(text.substring(0, (maxLength)));
                                alert("Sorry, you are only " + maxLength + " characters allowed for "+FieldName);
                            }
                            else {
                                //alert("Required Min. 500 characters");
                            }
                        });
                };
               //------------------------Methods to show and hide overlay on page----------------------------
               function showOverlay() {
                    var o = document.getElementById('overlay');
                    o.style.visibility = 'visible';
                }
                function hideOverlay() {
                    var o = document.getElementById('overlay');
                    o.style.visibility = 'hidden';
                }
                //------------------------Method to  refresh parent page of current Inline page--------------
                function parentRefresh(){
                    //--------------------Accessing parent view url and reloading----------------------------
                    window.top.location.href = '{!redirectUrl}';
                }
                //------------------------Method to confirm user action--------------------------------------
                function ConfirmUserAction(msg){
                    var action = confirm(msg);
                    if(action){
                        parentRefresh();
                    }else{

                        return false;
                    }

                }

        </script>

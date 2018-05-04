
exports.test_jstree = function(){
  $(document).ready(function(){
    var reportUrl;
    var returnData;
    
    var reportJsonTreeData = [{"id":"generic_program_data","parent":"report_root","text":"Generic Program Data","data":{"description":"Reports displaying general information about one or more programs"},"icon":null},{"id":"monthly_reports","parent":"scheduled_reports","text":"Monthly Reports","data":{"description":"Reports to be once a month"},"icon":null},{"id":"report_root","parent":"#","text":"All Programs","data":{"description":"List of all reports"},"icon":null},{"id":"scheduled_reports","parent":"report_root","text":"Scheduled Reports","data":{"description":"List of all reports to be run on  a schedule "},"icon":null},{"id":"42bd5dd7-16c5-416e-80a3-3c8d1b591f04","parent":"monthly_reports","text":"Authorizing Psychiatrists with Clients","data":{"description":"This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.."},"icon":"jstree-file"},{"id":"8a3e4cd3-7c9b-4bde-bc24-a929555793b6","parent":"generic_program_data","text":"Special Populations Served by the Selected Programs","data":{"description":"This report summarizes the special populations served by the selected programs during the defined time period. The special populations summarized are unaccompanied and parenting youth, domestic violence survivors, veterans, chronically homeless, adults with various disabilities, and the elderly."},"icon":"jstree-file"},{"id":"fc5095f2-9033-4722-9806-da1370d3d0a8","parent":"generic_program_data","text":"NY-501 Housing Summary Report","data":{"description":"This report summarizes by household type, age group, and housing type the number of people and households housed in the NY-501 CoC housing programs over a selected time period. The starting date and the ending date of the time period must be entered when calling the report. "},"icon":"jstree-file"},{"id":"09b300ae-ae41-4950-bfee-5a97e4615616","parent":"monthly_reports","text":"General Public Assistance and TANF Income of Adults Participating in the Selected Programs","data":{"description":"This report reports the latest General Public Assistance and TANF income amount for all participants in the selected programs over the chosen time period. When the report is run the starting and ending dates of the time period and a comma delimited ist of the ids of the selected programs must be entered."},"icon":"jstree-file"},{"id":"e9a34faf-2be2-48d7-a044-9f8ebfc28a85","parent":"generic_program_data","text":"Demographics of People Served by the Selected Programs","data":{"description":"This report summarizes a number of demographic measures over all the clients and households who received services from or were housed by one or more selected programs over defined time period. This function is used to report each discrete demographic variable separately. It reports no interactions among the demographic variables, such as age by gender or race by ethnicity."},"icon":"jstree-file"},{"id":"dd925661-15fa-4118-b113-d0fae6316f03","parent":"monthly_reports","text":"CCST Managment Summary Monthly Report","data":{"description":"This report provides a summary of the performance on all CCST programs over a single month and compares it to that of the year through the previous month. The starting date of the month must be entered when calling the report."},"icon":"jstree-file"}];
  
    var programJsonTreeData = []
    
    $('#treeview_div').jstree();
    $('#reporttreeview_json').jstree({
        'core' : {
            'data' : reportJsonTreeData
        },
        "plugins" : [ "sort" ]
    });
  $('#reporttreeview_json').on("changed.jstree", function (e, data) {
    
    var objNode = data.instance.get_json(data.selected);
    var objNodeS = JSON.stringify(objNode);
    reportUrl = 'http://localhost:5000/report_manager_api/load_selected_report?login=opal&report_id=' + objNode.id;
    console.log (reportUrl);

    $('#showDesc').val(objNode.data.description);
    //document.getElementById("showDesc").value = objNode.data.description;     
  });

    $('#button1').click(function(){
        console.log ('Report URL = ' + reportUrl );
        /*$.getJSON(reportUrl).done (
                        function (data) {
                            alert ('In success');
                            alert (JSON.stringify (data));
                        })
                        .fail (
                        function (data,textStatus,jqXHR ) {
                            alert ('Fail function');
                            alert (JSON.stringify (data));
                            var strResponse = jqXHR.getAllResponseHeaders();
                            alert ('Fail 2');
                         });*/

    $.ajax({
      crossOrigin: true,
      url: reportUrl,
      success: function(data) {
          console.log ('in callback');
            $('#showDesc').val(JSON.stringify (data.action_load_selected_report.report_name));
      }
    });
    /*     $.ajax (crossOrigin: true, reportUrl, function (data, textStatus, jqXHR ) {
            console.log ('in callback');
            $('#showDesc').val(JSON.stringify (data.action_load_selected_report.report_name));
        });*/

    //alert ('Continue');
    });
    
    $('#programtreeview_json').jstree({
        'core' : {
            'data' : programJsonTreeData
        },
        "plugins" : ["checkbox", "sort" ]
    });
  });
  
}
</script>
	   this.report_json = [
          {
          "id":"report_root",
          "text":"All Reports",
          "value":"Root of report tree",
          "icon":"",
          "opened": false,
          "selected": false,
          "disabled": false,
          "loading": false,
          "children": 
        [
          {
            "id":"data_quality_reports_for_selected_programs",
            "text":"Data Quality Reports for Selected Programs",
            "value":"Holds the reports showing the HMIS data quality over the whole Continuum",
            "icon":"",
            "opened": false,
            "selected": false,
            "disabled": false,
            "loading": false,
            "children": 
              [
                {
                  "id":"b99df294-86ff-4d59-848a-623527af1da7",
                  "text":"Data Quality Summmary for Selected Programs Version 5.2",
                  "value":"The Data Quality Summmary for Selected Programs Version 5.2 report shows the data quality of the HUD defined Universal Data Elements as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017 for the selected programs over a seleted time period. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.",
                  "icon":"jstree-file",
                  "opened": false,
                  "selected": false,
                  "disabled": false,
                  "loading": false
                }
              ]
          },
          
          {
            "id":"generic_program_data",
            "text":"Generic Program Data",
            "value":"These reports provide data that is interesting to most programs",
            "icon":"",
            "opened": false,
            "selected": false,
            "disabled": false,
            "loading": false,
            "children": 
              [
                {"id":"c26cfa45-5aa4-47fa-9b66-b3353bb1d80a",
                "text":"Special Populations Served by the Selected Programs",
                "value":"This report summarizes the special populations served by the selected programs during the defined time period. The special populations summarized are unaccompanied and parenting youth, domestic violence survivors, veterans, chronically homeless, adults with various disabilities, and the elderly. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.",
                "icon":"jstree-file"
                },
                {
                  "id":"c59678aa-ee2a-4564-bde1-0b2991ef13f5",
                  "parent":"generic_program_data",
                  "text":"United Way Demographics Report People Served",
                  "value":"This report provides the United Way of the Southern Tier Demographics data about the people who received a service from one or more selected programs over a selected time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.",
                  "icon":"jstree-file"
                }
              ]
          }
        ]

Find roots
For each root 
	get all report children
	get all folder children
		for each folder child
			get all report children
			get all folder children
			for each folder child
				get all report children
				get all folder children

get all allowed reports with parent folder
	convert each report to a json object
	conver report jsons to the folder's children array
	
	
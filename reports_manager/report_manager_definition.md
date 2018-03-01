report_manager definition

	The report_manager is a component exposing the actions (functions) needed to manage the reports available from the system and the folders under which they are displayed. 
	
	The report is a "model" which can be loaded and run. It is defined by the JSON below
		
		report	{
					report_id:
					report_name:
					description:
					url:
					containing_folder_id:	//the unique identifier of the folder under which the report is displayed
					parameters:	[parameter
								]	//the parametrs array can contain one or more json parameter objects or be empty (null) if there are no parameters
				};
						
	The folder entity is defined by the following json.
		folder	{
					folder_id:
					folder_name:
					folder_display_name:
					description:
					folder_parent_id:	//the folders and their reports will be displayed in a tree. One folder will be the root and all other folders will be a child of tnhe rolt or another folder. The root folder will have its folder_id = folder_parent_id 	
				}
				
	Tjhe parameter entity is defined by the following json
		parameter	{
						parameter_id:
						parameter_name:
						parameter_type:
						parameter_load_method:	// this indicates the UI widget or data load used to choose the parameter's options
					}
						//parameters could be one or more of the following or no parameters, parameters = null
									AgencyName
									County:
									MonthStartDate:
									PIT_date:
									ProgramIds:
									QuarterStart:
									ReportEndDate:
									ReportScope:
									ReportStartDate:
									SelectedDate:
									YearStartDate:		
report_manager architecture

	the report_manager microservice will be implemented as postgresql functions in the report_manager database.
		each function will define an action
			the action function presents the action to the report model which then completes it if it's appropriate to the report's state and allowed by the business logic. The state comparison is done inside the function, and all business logic is carried out by the action function or other functions it calls
			
	the report's configuration will be persisted in the following tables:
		reports and report_allowed_actions. 
		The data in these tables will be modifed only by the action functions or the functions they call; they WON'T BE exposed outside the database
		
	The action functions will be exposed only through the report_manager API which will  be implemented in a nodejs application. The API can be used by an user agent or other microservices to call the action functions. The report_manager will use the Seneca microservices toolkit and the API will defined as Seneca json paterns
	
Actions list

	The actions available to the report_manager are:
		enter_edit_folders
		enter_edit_parameters
		enter_edit_reports
		enter_edit_report_parameters
		load_report_list
		load_run_selected_report
		enter_edit_allowed_reports
	
	These actions are defined below with their Seneca calling patterns with their input and output json objects
	
		enter_edit_folders patterns
		
			input pattern
			{
				micro_service:	report_manager,
				action:	add_new_folder,
				user_data:	{								
								folder_name:
								folder_display_name:
								description:
								folder_parent_id:
								changing_user_login:
							}
			};
			
			output json
			{
				result_indicator:
				message:
				folder_id:
				folder_name:
				folder_display_name:
				description:
				folder_parent_id:
				changing_user_login:
			};
			
			
		enter_edit_reports patterns
		
			input pattern
			{
				micro_service:	report_manager,
				action:	add_new_report,
				user_data:	{
								report_name:	// the name of the report as displayed to the user
								description:	// a detailed description of the report displayed to the user
								url:	// the url used to run the report using the BIRT viewer
								containing_folder_name:	// the name of the folder under which the report is displayed to the user
								changing_user_login:
								parameters:	[	]	// an array listing the parameters to be used in running the report as json objects
							}
			};
					report_name:
					description:
					url:
					containing_folder_name:
					changing_user_login:
					parameters:	[	]			
			output json
			{
				report_id:	the uuid unique idenifier for the report
				report_name:	// the name of the report as displayed to the user
				url:	// the url used to run the report using the BIRT viewer
				changing_user_login:
			};
			
		load_report_list patterns
		
			input pattern
			{
				micro_service:	report_manager,
				action:	load_report_list,
				user_data:	{
								login:	// the login of the user requesting the report list; it will  be used to load only those folders and reports they are allowed to see
							}
			};
			
			output json
			{
				result_indicator:
				message:
				folders [{
							folder_id:
							folder_name:
							folder_description:
							sub_folders: [{	//if any, there can be up to three levels of folders each level having a folder_id, folder_name, folder_description, and a sub_folder array if there is one
							}],
							reports: [{  // The final folder or sub-folder must contain a reports array listing all reports in that folder as json objects with the properies below
									report_id:	the uuid unique idenifier for the report, used to identify a report when it's selected
									report_name:	// the name of the report as displayed to the user
									description:	// a detailed description of the report displayed to the user
							}]
			};
			
		enter_edit_allowed_reports patterns
		
			input pattern
			{
				micro_service:	report_manager,
				action:	enter_edit_allowed_reports,
				user_data:	{
								login:
								report_id:
								report_name:
								task:	// viewable (set system_user_allowed_reports.report_viewable to TRUE) or not_viewable (set system_user_allowed_reports.report_viewable to FALSE)
								changing_user_login:
							}
							}
			};
			
			output json
			{
				result_indicator:
				message:
				login:
				report_id:
				report_name:
				viewable:
				changing_user_login:
			};
			
			
			

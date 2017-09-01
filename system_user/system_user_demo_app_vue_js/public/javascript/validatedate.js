

exports.validateDate = function (inputText)  {
	var date_parts = inputText.split('/');
	//console.log (date_parts);
	parts_length = date_parts.length;
	//console.log (typeof parts_length);
	// Extract the string into month, date and year
	if (parts_length != 3) {
		//console.log ('parts_length != 3');
		return false;
	} else {
		//console.log ('else of parts_length != 3');
		var dd = parseInt(date_parts[1]);
		var mm  = parseInt(date_parts[0]);
		var yy;
		if (isNaN (parseInt(date_parts[2]))) {
			yy = 0;
		} else {
			yy = parseInt(date_parts[2]);
		}
		//console.log (dd + '-' + mm + '-' + yy );
		// Create list of days of a month [assume there is no leap year by default]
		var ListofDays = [31,28,31,30,31,30,31,31,30,31,30,31];
		
		if (yy < 1990) {
			//console.log ('In yy < 1990' );
			return false;
		} else if (mm > 12 || mm == 0) {
			//console.log ('In mm > 12 || mm == 0' );
			return false;
		}  else if (mm==1 || mm>2) {
			//console.log (mm + ' dd = ' + dd + ' from_list ' + ListofDays[mm-1]);
			if (dd > ListofDays[mm-1] || dd == 0){
				return false;
			} else {
				return true;
			}
		}  else if (mm==2) {
			//console.log ('In mm = 2' );
			if (yy % 400 == 0 || (yy % 100 != 0 && yy % 4 == 0)) {
				maxDays = 29;
			} else {
				maxDays = 28;
			}
			if (dd > maxDays) {
				return false;
			} else {
				return true;
			}
 
		} else {
			return false;
		} 
	}
}
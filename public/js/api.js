var API = {
	get: function(method, headers, data, success, fail) {
		var url = "/api/" + method;
		
		if(data) {
			url += "?" + Object.keys(data).map(function(k) {
				return encodeURIComponent(k) + "=" + encodeURIComponent(data[k]);
			}).join("&");
		}
		
		fetch(url).then((response) => {
			return response.json();
		}).then((data) => {
			success(data);
		}).catch(function() {
			console.log("There was an error!");
		});
	},

	post: function(method, headers, data, success, fail) {
		var postParams = new FormData();
		for(var key in data) {
			postParams.append(key, data[key]);
		}
		
		fetch(url, {
			method: "POST",
			headers: {
				// "Content-Type": "application/json; charset=utf-8",
				"Content-Type": "application/x-www-form-urlencoded",
			}
		}).then((response) => {
			return response.json();
		}).then((data) => {
			var jsonData = JSON.parse(data);
			
			success(jsonData);
		}).catch(function() {
			console.log("There was an error!");
		});
	},

	put: function() {

	},

	patch: function() {

	},

	devare: function() {

	}
};
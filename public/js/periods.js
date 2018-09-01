/* Created by Anastas Dolushanov<anastas@digitalvoivode.com> */
"use strict";

var Periods = {
	getAll: function(params) {


		console.log(params);
		var page = params && params.page ? params.page : 1;
		var filter = params && params.filter ? params.filter : $.trim($("#search").val());

		API.get("getperiods", {}, {
			page: page,
			filter: filter
		}, function(response) {
console.log(response);	
// return false;		
			var i, tblSrc = "", ulSrc = "";

			for(i = 0; i < response.periods.length; i++) {
				tblSrc += "<tr>";
				tblSrc += "<td>" + response.periods[i].id + "</td>";
				tblSrc += "<td>" + response.periods[i].company_name + "</td>";
				tblSrc += "<td>" + (response.periods[i].name || "") + "</td>";
				tblSrc += "<td>" + (response.periods[i].start || "") + "</td>";
				tblSrc += "<td>" + (response.periods[i].end || "") + "</td>";

				//tblSrc += "<td>" + (response.periods[i].description || "") + "</td>";
				tblSrc += "<td>" + (response.periods[i].last_modified || "") + "</td>";
				tblSrc += "<td>";
				tblSrc += "<a href=\"/company/" + response.periods[i].id + "\" class=\"material-icons\">mode_edit</a>";
				tblSrc += "<a href=\"javascript:Periods.remove(" + response.periods[i].id + ");\" class=\"material-icons text-danger\">clear</a>";
				tblSrc += "</td>";
				tblSrc += "</tr>";
			}

			$("#tblPeriods tbody").html(tblSrc);

			var minPage = Math.max(1, parseInt(response.page) - 2);
			var maxPage = Math.min(response.pages, parseInt(response.page) + 2);
			for(i = minPage; i <= maxPage; i++) {
				ulSrc += "<li class=\"page-item " + (i == response.page ? "active" : "") + "\"><a href=\"javascript:Periods.getAll({page:" + i + "})\" class=\"page-link\">" + i + "</a></li>";
			}
			ulSrc += "<li class=\"page-item\"><a href=\"javascript:Periods.getAll({page:'all'});\" class=\"page-link\">Show All</a></li>";

			$(".pagination").html(ulSrc).show();
		});
	},
	
	exportCompanies: function() {
		API.get("exportcompanies", {}, {
			filter: $.trim($("#search").val())
		}, function(response) {
			download(response, "companies.csv", "application/vnd.ms-excel");
		});
	},
	
	remove: function(id) {
		if(confirm("Are you sure you want to delete this contact?")) {
			API.get("removecontact", {}, {id: id}, function() {
				Companies.getAll();
			});
		}
	},

	parseCSVHeader: function() {
		var blobSlice = Blob.prototype.slice;
		var fileObj = document.getElementById("fleDataImport").files[0];

		var reader = new FileReader();
		reader.onload = function(e) {
			var src = e.target.result;
			var headSrc = "",
				bodySrc = "",
				i, j;

			API.post("parsesample", {}, {
				sample: src
			}, function(response) {
				for(i = 0; i < response.length; i++) {
					if(i == 0) {
						for(j = 0; j < response[0].length; j++) {
							headSrc += "<th>";
							headSrc += "<select class=\"col_name\" data-rel=\"" + j + "\">";
							headSrc += "<option value=\"\">- ignore -</option>";
							headSrc += "<option value=\"district\">District name</option>";
							headSrc += "<option value=\"enrollment\">Enrolment</option>";
							headSrc += "<option value=\"email\">Email</option>";
							headSrc += "<option value=\"website\">Website</option>";
							headSrc += "<option value=\"address\">Street address</option>";
							headSrc += "<option value=\"city\">City</option>";
							headSrc += "<option value=\"state\">State</option>";
							headSrc += "<option value=\"country\">Country</option>";
							headSrc += "<option value=\"zip\">ZIP</option>";
							headSrc += "<option value=\"ncesid\">NCES-ID</option>";
							headSrc += "</select>";
							headSrc += "</th>";
						}

						$("#tblDataPreview thead").html(headSrc);
					}

					bodySrc += "<tr>";
					for(j = 0; j < response[i].length; j++) {
						bodySrc += "<td>" + response[i][j] + "</td>";
					}
					bodySrc += "</tr>";
				}

				$("#divDataPreview").show();
				$("#tblDataPreview tbody").html(bodySrc);
			});
		};
		reader.readAsText(blobSlice.call(fileObj, 0, 1000));
	},

	importCompanies: function() {
		var valid = true;
		var fields = {
			skip_first: $("#chkbSkipRow").is(":checked")
		};
		$("select.col_name").each(function() {
			var rel = $(this).attr("data-rel");
			var value = $(this).val();

			if(value !== "") {
				if(fields[value] > -1) {
					alert("Please use each column name only once");
					valid = false;
				} else {
					fields[value] = rel;
				}
			}
		});

		if(valid) {
			$("#btnImport").text("Please wait ...");
			
			var blobSlice = Blob.prototype.slice;
			var fileObj = document.getElementById("fleDataImport").files[0];
			var fileHash = fileObj.name.hashCode();
			var chunkSize = 256*1024;
			var chunkCnt = Math.ceil(fileObj.size / chunkSize);
			var currentChunk = 0;
			var chunkScr = "";
	
			var reader = new FileReader();
			reader.onload = function(e) {
				chunkScr = reader.result;
				if(currentChunk === chunkCnt) {
					API.post("importcompanies", {}, {
						file: fileHash,
						src: chunkScr,
						fields: JSON.stringify(fields),
						end: "yes"
					}, function(response) {
						$("#btnImport").text("Proceed with import");
						$("#modalImport").modal("hide");
						Companies.getAll();
					});
				} else {
					API.post("importcompanies", {}, {
						file: fileHash,
						src: chunkScr,
						fields: JSON.stringify(fields),
						end: "no"
					}, function() {
						var start = currentChunk * chunkSize;
						var end = ((start + chunkSize) >= fileObj.size) ? fileObj.size : start + chunkSize;
						reader.readAsText(blobSlice.call(fileObj, start, end));
						currentChunk++;
					});
				}
			};
	
			reader.readAsText(blobSlice.call(fileObj, currentChunk + chunkSize, chunkSize));
		}
	},
	
	clearCompanies: function() {
		if(confirm("Are you sure you want to remove all companies?")) {
			API.get("clearcompanies", {}, {}, function() {
				Companies.getAll();
			});
		}
	},
	
	removeMatch: function() {
		$("#school_id").val("");
		$("#divSchoolMatch").hide();
		$("#divSchoolMatches").show();
	},
	
	findMatches: function(id) {
		API.get("findmatch", {}, {id: id}, function(response) {
			Companies.matches = response;
			var ulSrc = "";
			
			if(response.length > 0) {
				for(var i = 0;i < response.length;i++) {
					ulSrc += "<li class=\"list-group-item\" data-rel=\"" + response[i].id + "\">";
					ulSrc += "<span class=\"match-name\">" + response[i].name + "</span>, " + response[i].address + ", " + response[i].zip + ", " + response[i].city + ", " + response[i].enrollment + " students, <a href=\"" + response[i].website + "\" target=\"_blank\">" + response[i].website + "</a>";
					ulSrc += "&nbsp;&nbsp;<code>" + response[i].rating + " %</code>";
					ulSrc += "<button type=\"button\" class=\"btn btn-link btn-sm float-right\" onclick=\"Companies.selectMatch(" + response[i].id + ")\">Select</button>";
				}
			} else {
				ulSrc += "<li class=\"list-group-item\">No matches found</li>";
			}
			
			$("#ulSchoolMatches").html(ulSrc);
			$("#divSchoolMatches").show();
		});
	},
	
	autoMatch: function() {
		var tmout;
		
		$("#btnAutoMatch").text("Please wait ...");
		API.get("automatch", {}, {}, function(response) {
			var alertMsg  = response.matched + " records matched. ";
			if(response.not_matched.length > 0) {
				alertMsg += "Records with no matches: " + response.not_matched.join("; ");
			}
			alert(alertMsg);
			
			$("#btnAutoMatch").text("Auto-match all");
			clearTimeout(tmout);
			Companies.getAll();
			
			
		});
		
		tmout = setTimeout(function() {
			alert("Matching time exceed server execution time. Please click 'Auto-match all' again");
			window.location.reload();
		}, 60000);
	},
	
	selectMatch: function(id) {
		$("#spanMatchName").text($("[data-rel='" + id + "'] .match-name").text());
		$("#school_id").val(id);
		$("#divSchoolMatches").hide();
		$("#divSchoolMatch").show();
	}
};

function logout() {
	API.get("logout", {}, {}, function() {
		window.location.reload();
	});
}

String.prototype.hashCode = function() {
	return this.split("").reduce(function(a, b) {
		a = ((a << 5) - a) + b.charCodeAt(0);
		return a & a;
	}, 0).toString(16);
};
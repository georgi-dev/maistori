<?php
global $container;

include_once('head.php');
include_once('header.php');
?>
<style type="text/css">
	#sort_by option{padding: 5px;}
</style>
<div class="container">
	<div class="jumbotron">
		<h1 class="display-4">Periods</h1>
		<br />
		<label>Sort by</label>
		<select id="sort_by" class="form-control" style="width:300px;">
			<option value="id">Period id</option>
			<option value="name">Period name</option>
			<option value="start">Period start</option>
			<option value="end">Period end</option>
		</select>
		<table id="tblPeriods" class="table table-striped">
			<thead>
				<tr>
					<th>ID</th>
					<th>Company</th>
					<th>Name</th>
					<th>Start</th>
					<th>End</th>
					<th>Last modified</th>
					<th>#</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<ul class="pagination"></ul>
	</div>

	<!-- <button id="add_filter">Add filter</button> -->
</div>

<script type="text/javascript" src="/js/periods.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		Periods.getAll();

		$('#sort_by').on('change',function(){
			
			Periods.getAll({filter: $(this).val()});
			//window.history.pushState("object or string", "Title", "/periods/?order_by="+$(this).val()+"");

		});
	});
	
</script>
<?php
include_once('foot.php');
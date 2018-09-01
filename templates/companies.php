<?php
global $container;

include_once('head.php');
include_once('header.php');
?>

<div class="container">
	<div class="jumbotron">
		<h1 class="display-4">Companies</h1>
		<br />
		<table id="tblCompanies" class="table table-striped">
			<thead>
				<tr>
					<th>ID</th>
					<th>Name</th>
					<th>Description</th>
					<th>Last modified</th>
					<th>#</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<ul class="pagination"></ul>
	</div>
</div>

<script type="text/javascript" src="/js/companies.js"></script>
<script type="text/javascript">
	$(function() {
		Companies.getAll();
	});
</script>
<?php
include_once('foot.php');
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<a class="navbar-brand" href="/"><?php echo $container->get("settings")["applicationName"];?></a>
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
		<span class="navbar-toggler-icon"></span>
	</button>

	<div class="collapse navbar-collapse" id="navbarColor01">
		<ul class="navbar-nav mr-auto">
<?php
if((int) $_SESSION["user"]["id"] > 0):
?>
			<li class="nav-item active">
				<a class="nav-link" href="/">Contacts <span class="sr-only">(current)</span></a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="/schools">Salesforce data</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="/help">Help</a>
			</li>
<?php
endif;
?>
		</ul>
		
		<ul class="navbar-nav pull-right">
			<li>
<?php
if((int) $_SESSION["user"]["id"] == 0):
?>
	<a class="nav-link" href="/login">Login</a>
<?php
else:
?>
	<a class="nav-link" href="javascript:logout();">Logout</a>
<?php
endif;
?>
			</li>
		</ul>
	</div>
</nav>
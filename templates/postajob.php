
<?php 
global $container;
include_once('head.php');
include_once('header.php');
?>
<h1 class="text-center">Post a job</h1>


	<form method="post" action="../save_a_posted_job" style="width:600px;margin:100px auto;">
	  <div class="form-group">
	    <label for="exampleInputEmail1">Аз търся</label>
	    <select name="job_kind">
	    	<option>Зидар</option>
	    	<option>Бояджия</option>
	    	<option>Шпакловчик</option>
	    </select>
	  </div>
	  <div class="form-group">
	    <label for="exampleInputPassword1">Дайте заглавие на вашата обява за работа</label>
	    <input type="text" class="form-control" name="job_title" id="exampleInputPassword1" placeholder="Добавете заглавие">
	  </div>
	  <div class="form-group">
	    <label for="exampleInputEmail1">Описание на работата</label>
	    <textarea class="form-control" name="job_description" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Добавете описание"></textarea>
	    
	  </div>

	  <div class="form-group">
	    <label for="exampleInputEmail1">Завършете вашата обява</label>
	    
	    <input type="email" class="form-control" name="client_email" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Добавете имейл">
	    
	  </div>
	  <button type="submit" class="btn btn-primary submit">Публикувай обявата</button>
	</form>

<script type="text/javascript" src="/js/postajob.js"></script>
<script type="text/javascript">
	// $(function() {
	// 	Companies.getAll();
	// });
</script>
<?php
include_once('foot.php');
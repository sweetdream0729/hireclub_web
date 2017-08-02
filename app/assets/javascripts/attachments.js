$('#upload_attachment').click(function() {
    $('#attachment_file').click();
});
$("#attachment_file").change(function(){
	if(this.value){
	  name = this.value.replace(/^.*[\\\/]/, '');
	  $('#file_selection_msg').html(name);
	}else{
	  $('#file_selection_msg').html("No file choosen");
	}
});

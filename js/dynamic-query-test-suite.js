/* Function to replace xml special characters */
function htmlSpecialChars(unsafe) {
  return unsafe
  .replace(/&/g, "&amp;")
  .replace(/</g, "&lt;")
  .replace(/>/g, "&gt;")
  .replace(/"/g, "&quot;");
}

/* Test button click should trigger the ajax request for the jsp
 On Success load the pre formated content to the response tab
 On failure load the response to the response tab */
$('#jsps button.test').on("click",function(){
  var btn = $(this);
  /* Remove success class from every button */
  btn.removeClass("btn-success btn-danger");
  var row = btn.closest(".row-fluid");
  var fullLink = "/csa/propertysources/" + row.find("label").text() + "?" +  row.find("input").val();
  $.ajax({
    url: fullLink,
    dataType: "text"
  })
  .done(function( data ) {
    $("#myResponse").html("<pre class='prettyprint linenums languague-xml' style='min-height:580px;'>" + htmlSpecialChars(data) + "</pre>");
      prettyPrint();
      /* Add the success class to this button to show its success */
     btn.addClass("btn-success");
  })
  .fail(function( data ) {
    $("#myResponse").html(data.responseText);
    /* Add the danger class to this button to show its failure */
      btn.addClass("btn-danger");
  });
/* Return false to override default click behaviour */
return false;
});

$('#jsps button.save').on("click",function(){
  var params = [];
  var rowList = $('#jsps .row-fluid');
  rowList.each(function(){
    var row = $(this);
    params.push(row.find("label").text() + "?" +  row.find("input").val());
  });

  /* Ajax post back to self with saveConfig action */
  $.post("/csa/propertysources/",{"action":"saveConfig","config":params.join("\n")}, function(data){
    alert(data);
  });
  return false;
});
